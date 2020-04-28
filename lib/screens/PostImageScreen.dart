import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart';

class PostImageScreen extends StatefulWidget {
  @override
  _PostImageScreenState createState() => _PostImageScreenState();
}

class _PostImageScreenState extends State<PostImageScreen> {
  File _image;

  TextEditingController _captionInputController = TextEditingController();
  bool _isUploading = false;
  bool _isUploadCompleted = false;

  double _uploadProgress = 0;

  // firebase

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // firebase

  pickFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    cropImage(image);
  }

  pickFromPhone() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    cropImage(image);
  }

  cropImage(File image) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path, compressQuality: 40);

    setState(() {
      _image = croppedImage;
    });
  }

  uploadImage() async {
    try {
      if (_image != null) {
        setState(() {
          _isUploading = true;
          _uploadProgress = 0;
        });

        FirebaseUser user = await _auth.currentUser();

        String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
            basename(_image.path);

        final StorageReference storageReference =
            _storage.ref().child("posts").child(user.uid).child(fileName);

        final StorageUploadTask uploadTask = storageReference.putFile(_image);

        final StreamSubscription<StorageTaskEvent> streamSubscription =
            uploadTask.events.listen((event) {
          var totalBytes = event.snapshot.totalByteCount;
          var transferred = event.snapshot.bytesTransferred;

          double progress = ((transferred * 100) / totalBytes) / 100;
          setState(() {
            _uploadProgress = progress;
          });
        });

        StorageTaskSnapshot onComplete = await uploadTask.onComplete;

        String photoUrl = await onComplete.ref.getDownloadURL();

        _db.collection("posts").add({
          "photoUrl": photoUrl,
          "name": user.displayName,
          "caption": _captionInputController.text,
          "date": DateTime.now(),
          "uploadedBy": user.uid
        });

        // when completed
        setState(() {
          _isUploading = false;
          _isUploadCompleted = true;
        });

        streamSubscription.cancel();
        Navigator.pop(this.context);
      } else {
        showDialog(
            context: this.context,
            builder: (ctx) {
              return AlertDialog(
                content: Text("Please select image!"),
                title: Text("Alert"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              );
            });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Image"),
        actions: <Widget>[
          IconButton(
            tooltip: "Take from camera",
            icon: Icon(Icons.add_a_photo),
            onPressed: () {
              pickFromCamera();
            },
          ),
          IconButton(
            tooltip: "Select from phone",
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () {
              pickFromPhone();
            },
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _image != null
                  ? Image.file(_image)
                  : Image(
                      image: AssetImage("assets/placeholder.png"),
                    ),
              _isUploading
                  ? LinearProgressIndicator(
                      value: _uploadProgress,
                      backgroundColor: Colors.grey,
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _captionInputController,
                  decoration: InputDecoration(
                    hintText: "Write Caption here",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                child: Text("Done"),
                onPressed: () {
                  uploadImage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
