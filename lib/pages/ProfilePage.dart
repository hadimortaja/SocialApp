import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social/models/user.dart';
import 'package:social/pages/EditProfilePage.dart';
import 'package:social/pages/home_page.dart';
import 'package:social/widgets/HeaderWidget.dart';
import 'package:social/widgets/ProgressWidget.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;
  ProfilePage({this.userProfileId});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentOnlineUserId =currentUser?.id;////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, strTitle: "Profile"),
        body: ListView(
          children: <Widget>[
            createProfileTopView(),
          ],
        )
    );
  }
  createProfileTopView(){
    return FutureBuilder(
      future: userReference.document(widget.userProfileId).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(dataSnapshot.data);
        return Padding(
          padding: EdgeInsets.all(17),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(user.url),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                            createColumns("Posts",0),
                            createColumns("Followers",0),
                            createColumns("Following",0),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            createButton(),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
//              Container(
//                alignment: Alignment.centerLeft,
//                padding: EdgeInsets.only(top: 5),
//                child: Text(user.username,style: TextStyle(fontSize: 15,color: Colors.black),),
//              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 5),
                child: Text(user.profileName,style: TextStyle(fontSize: 14,color: Colors.black),),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 5),
                child: Text(user.bio,style: TextStyle(fontSize: 14,color: Colors.grey),),
              )
            ],
          ),
        );
      },
    );
  }

  Column createColumns(String title ,int count){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(count.toString(),style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            title,
            style: TextStyle(fontSize: 16,color: Colors.grey,fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
  createButton(){
bool ownProfile =currentOnlineUserId ==widget.userProfileId;
if(ownProfile){
  return createButtonTitleAndFunction(title:"Edit Profile",performFunction:editUserProfile,);
}
  }
 Container createButtonTitleAndFunction({String title,Function performFunction}){
    return Container(
      padding: EdgeInsets.only(top: 3),
      child: FlatButton(
        onPressed: performFunction,
        child: Container(
          width: 230,
          height: 26,
          child: Text(title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(6),

          ),
        ),
      ),
    );
  }
  editUserProfile(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProfilePage(currentOnlineUserId:currentOnlineUserId)));
  }
}
