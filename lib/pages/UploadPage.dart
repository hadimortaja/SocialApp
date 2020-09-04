import 'dart:io';
//import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File file;
  @override
  Widget build(BuildContext context) {
    return displayUploadScreen();
  }
  displayUploadScreen(){
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.add_photo_alternate,color: Colors.grey,size: 50,),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
              child: Text("Upload Image",style: TextStyle(color: Colors.white),),
              color: Colors.blue,
              onPressed: ()=>takeImage(context),
            ),
          )
        ],
      ),
    );
  }
  takeImage(mcontext){
return showDialog(
    context: mcontext,
  builder: (context){
      return SimpleDialog(
        backgroundColor: Colors.white,
        title: Text("New Post",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        children: <Widget>[
          SimpleDialogOption(
            child: Text("Capture Image ",style: TextStyle(color: Colors.black),),
            onPressed: captureImageWithCamera,
          ),
          SimpleDialogOption(
            child: Text("Select From Gallery",style: TextStyle(color: Colors.black),),
            onPressed: pickImageFromGallery,
          ),
          SimpleDialogOption(
            child: Text("Cancel",style: TextStyle(color: Colors.black),),
            onPressed: ()=>Navigator.pop(context),
          )
        ],
      );
  },
);
  }
  captureImageWithCamera()async{

Navigator.pop(context);
File imageFile  =await ImagePicker.pickImage(
    source: ImageSource.camera,
  maxHeight: 680,
  maxWidth: 970
);
setState(() {
this.file =imageFile;
});

  }
  pickImageFromGallery()async{
    Navigator.pop(context);
    File imageFile  =await ImagePicker.pickImage(
        source: ImageSource.gallery,
    );
    setState(() {
      this.file =imageFile;
    });
  }
}
