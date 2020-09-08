import 'dart:io';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social/models/user.dart';
import 'package:social/pages/home_page.dart';
import 'package:social/widgets/ProgressWidget.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart'as ImD;

class UploadPage extends StatefulWidget {
  final User gCurrentUser;

  UploadPage({this.gCurrentUser});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>with AutomaticKeepAliveClientMixin<UploadPage> {
  File file;
  bool uploading =false;
  String postId =Uuid().v4();
  TextEditingController descriptionTextEditingController =TextEditingController();
  TextEditingController locationTextEditingController =TextEditingController();


  bool get wantKeepAlive=>true;
  @override
  Widget build(BuildContext context) {
    return file == null ?displayUploadScreen():displayUploadFormScreen();
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
            onPressed: ()=>Navigator.of(context).pop(),
          )
        ],
      );
  },
);
  }
  captureImageWithCamera()async{
try {
  Navigator.of(context).pop();
  File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970
  );
  setState(() {
    this.file = imageFile;
  });
}catch(e){

}
  }
  pickImageFromGallery()async{
    try {
      Navigator.of(context).pop();
      File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        this.file = imageFile;
      });
    }catch(e){

    }
  }
  displayUploadFormScreen(){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),
        onPressed: clearPostInfo,),
        title: Text("New Post",style: TextStyle(
          fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold
        ),),
        actions: <Widget>[
          FlatButton(
            onPressed: uploading ? null : ()=>controlUploadAndSave(),
            child: Text("Share",style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold,fontSize: 16),),
          )
        ],
      ),
      body: ListView(
          children: <Widget>[
            uploading ? linearProgress() :Text(""),
            Container(
              height: 230,
              width: MediaQuery.of(context).size.width *0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: FileImage(file),fit: BoxFit.cover)
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),),
            ListTile(
              leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(widget.gCurrentUser.url),),
              title: Container(
                width: 250,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: descriptionTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Say Something About Image..",
//                  hintStyle:
                  border: InputBorder.none
                  ),
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person_pin_circle,color: Colors.black,size: 36,),
              title: Container(
                width: 250,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: locationTextEditingController,
                  decoration: InputDecoration(
                      hintText: "Write the location here..",
//                  hintStyle:
                      border: InputBorder.none
                  ),
                ),
              ),
            ),
Container(
  width: 220,
  height: 110,
  alignment: Alignment.center,
  child: RaisedButton.icon(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35 )),
    color: Colors.blueAccent ,
    icon: Icon(Icons.location_on,color: Colors.white,),
    label: Text("Get My Current Location",style: TextStyle(color: Colors.white),),
    onPressed: getUserCurrentLocation,

  ),
)
          ],
        ),
    );
  }
  clearPostInfo(){
    locationTextEditingController.clear();
    descriptionTextEditingController.clear();
    setState(() {
      file =null;
    });
  }
  getUserCurrentLocation()async{
    Position position =await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark>placeMarks =await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mplaceMark =placeMarks[0];
    String completeAddressInfo ='${mplaceMark.subThoroughfare} ${mplaceMark.thoroughfare}, ${mplaceMark.subLocality} ${mplaceMark.locality}, '
        '${mplaceMark.subAdministrativeArea} ${mplaceMark.administrativeArea}, ${mplaceMark.postalCode} ${mplaceMark.country},';
    String specificAddress ='${mplaceMark.postalCode}, ${mplaceMark.country}';
    locationTextEditingController.text =specificAddress;
  }

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });
    await compressingPhoto();

    String downloadUrl =await uploadPhoto(file);

    savePostInfoToFireStore(url:downloadUrl,location:locationTextEditingController.text,
        description:descriptionTextEditingController.text);
    locationTextEditingController.clear();
    descriptionTextEditingController.clear();
    setState(() {
      file =null;
      uploading =false;
      postId =Uuid().v4();
    });
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image mImageFile = ImD.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(mImageFile, quality: 80));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    StorageUploadTask mStorageUploadTask =
        storageReference.child("post_$postId.jpg").putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot = await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  savePostInfoToFireStore({String url, String location, String description}) {
    postReference.document(widget.gCurrentUser.id).collection("usersPosts").document(postId).setData({
      "postId":postId,
      "ownerId":widget.gCurrentUser.id,
      "timestamp":DateTime.now(),
      "likes":{},
      "username":widget.gCurrentUser.username,
      "description":description,
      "location":location,
      "url":url,

    });
  }
}
