import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motivational_quotes/services/storage.dart';

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  //DatabaseService database = DatabaseService();
  Storage storage = Storage();

  File _image;
  //String imageLink;
  final picker = ImagePicker();

  Future pickImage() async {

    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
      _image = File(pickedFile.path);
                
      setState(() {
         _image = File(pickedFile.path);
      });

    // calling upload function 
    storage.uploadimage(_image);
  
  }

  

  @override
  Widget build(BuildContext context) {

    return Material(
          child: Container(
        child: FlatButton(
          child: Text('Upload'),
          onPressed: () {
            pickImage();
          },
        ),
      ),
    );
  }
}