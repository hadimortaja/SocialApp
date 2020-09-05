import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:social/models/user.dart';
import 'package:social/widgets/ProgressWidget.dart';
import 'package:social/pages/home_page.dart';
import 'home_page.dart';

//final GoogleSignIn _googleSignIn =GoogleSignIn();


class EditProfilePage extends StatefulWidget {
  final String currentOnlineUserId;
  EditProfilePage({this.currentOnlineUserId});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController profileNameTextEditingController = TextEditingController();
  TextEditingController bioTextEditingController = TextEditingController();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  User user;
  bool _profileNameValid = true;
  bool _bioValid = true;


  @override
  void initState() {
    super.initState();

    getAndDisplayUserInformation();
  }
  getAndDisplayUserInformation()async{
    setState(() {
      loading =true;
    });
    DocumentSnapshot documentSnapshot = await userReference.document(
        widget.currentOnlineUserId).get();
    user = User.fromDocument(documentSnapshot);

    profileNameTextEditingController.text = user.profileName;
    bioTextEditingController.text = user.bio;

    setState(() {
      loading =false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Edit Profile", style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done, color: Colors.black, size: 30,),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      body: loading ? circularProgress() : ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 7),
                  child: CircleAvatar(
                    radius: 52,
                    backgroundImage: CachedNetworkImageProvider(user.url),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      createProfileNameTextFormField(),
                      createBioTextFormField(),

                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 29,
                    left: 50,right: 50),
                  child: RaisedButton(
                    onPressed: updateUserData,
                    child: Text(
                      "          Update          ",
                      style: TextStyle(color: Colors.black,fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 50,right: 50),
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: logOutUser,
                    child: Text(
                      "          Log Out          ",
                      style: TextStyle(color: Colors.white,fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  logOutUser()async{
    await gSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));


  }


  Column createProfileNameTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 13),
          child: Text(
            "Profile Name", style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          style: TextStyle(color: Colors.black,),
          controller: profileNameTextEditingController,
          decoration: InputDecoration(
            hintText: "Write profile name here..",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),

            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),

            ),
            hintStyle: TextStyle(color: Colors.grey),
            errorText: _profileNameValid ? null : "Profile Name is very Short",
          ),
        )
      ],
    );
  }

  Column createBioTextFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 13),
          child: Text(
            "Bio", style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          style: TextStyle(color: Colors.black,),
          controller: bioTextEditingController,
          decoration: InputDecoration(
            hintText: "Write Bio here..",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),

            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),

            ),
            hintStyle: TextStyle(color: Colors.grey),
            errorText: _bioValid ? null : "Bio is Very Long.",
          ),
        )
      ],
    );
  }
  updateUserData(){
    setState(() {
      profileNameTextEditingController.text.trim().length<3
          ||profileNameTextEditingController.text.isEmpty?_profileNameValid=false:_profileNameValid=true;
      bioTextEditingController.text.trim().length>110 ?_bioValid =false :_bioValid =true;
    });
    if(_bioValid && _profileNameValid){
      userReference.document(widget.currentOnlineUserId).updateData({
        "profileName":profileNameTextEditingController.text,
        "bio":bioTextEditingController.text,
      });
      SnackBar successsnackBar =SnackBar(
        content:Text("Profile has been Updated Successfully."));
      _scaffoldGlobalKey.currentState.showSnackBar(successsnackBar);
    }
  }
}
