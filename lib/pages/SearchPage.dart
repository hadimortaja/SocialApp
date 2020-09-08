
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social/models/user.dart';
import 'package:social/pages/ProfilePage.dart';
import 'package:social/pages/home_page.dart';
import 'package:social/widgets/ProgressWidget.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage> {
  TextEditingController searchTextEditingController =TextEditingController();
  Future<QuerySnapshot> futureSearchResults;

  AppBar searchPageHeader(){
    return AppBar(
      backgroundColor: Colors.white,
      title: TextFormField(
        style: TextStyle(fontSize: 18,color: Colors.black),
        controller: searchTextEditingController,
        decoration: InputDecoration(
          hintText: "Search here...",
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
            filled: true,
          prefixIcon: Icon(Icons.person_pin,color: Colors.blueAccent,size: 30,),
          suffixIcon: IconButton(icon: Icon(Icons.clear,color: Colors.grey ,),onPressed: emptyTheTextFormField,)
      ),
        onFieldSubmitted: controlSearching,
      ),
    );
  }

  emptyTheTextFormField(){
     searchTextEditingController.clear();
  }
  controlSearching(String str){
    Future<QuerySnapshot>allUsers =userReference.where("profileName",isGreaterThanOrEqualTo: str).getDocuments();
    setState(() {
      futureSearchResults =allUsers;
    });
  }
 Container displayNoSearchResultScreen(){
    final Orientation orientation =MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.group,color: Colors.blueAccent,size: 50,),
            Text("Search Users",textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),),
          ],
        ),
      ),
    );
  }
  displayUsersFoundScreen(){
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context,dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress();
        }
        List<UserResult>searchUserResult =[];
        dataSnapshot.data.documents.forEach((document){
          User eachUser =User.fromDocument(document);
          UserResult userResult =UserResult(eachUser);
          searchUserResult.add(userResult);
        });
        return ListView(children: searchUserResult);
      },
    );
  }
  bool get wantKeepAlive=>true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.white54,
      appBar: searchPageHeader(),
      body: futureSearchResults ==null ? displayNoSearchResultScreen() :displayUsersFoundScreen(),
    );
  }

}

class UserResult extends StatelessWidget {
  final User eachUser;
  UserResult(this.eachUser);////////
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        color: Colors.white54,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: ()=>displayUserProfile(context,userProfileId:eachUser.id),
              child:  ListTile(
                leading: CircleAvatar(backgroundColor: Colors.black,backgroundImage: CachedNetworkImageProvider(eachUser.url),),
                title: Text(eachUser.profileName,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                subtitle: Text(eachUser.username,style: TextStyle(color: Colors.black ,fontSize: 13),),
              ),
            )
          ],
        ),
      ),
    );
  }
displayUserProfile(BuildContext context,{String userProfileId}){
Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>ProfilePage(userProfileId: userProfileId,)));
}
}

