import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social/models/user.dart';
import 'package:social/pages/CreateAccountPage.dart';
import 'package:social/pages/NotificationsPage.dart';
import 'package:social/pages/ProfilePage.dart';
import 'package:social/pages/SearchPage.dart';
import 'package:social/pages/TimeLinePage.dart';
import 'package:social/pages/UploadPage.dart';

final GoogleSignIn gSignIn =GoogleSignIn();
final userReference =Firestore.instance.collection("users");
final StorageReference storageReference =FirebaseStorage.instance.ref().child("Posts Pictures");
final postReference =Firestore.instance.collection("post");
final activityFeedReference =Firestore.instance.collection("feed");
final commentsReference =Firestore.instance.collection("comments");


final DateTime timestamp =DateTime.now();

User currentUser;
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSignedIn =false;
  PageController pageController;
  int getPageIndex =0;


  @override
  void initState() {
    super.initState();
    pageController =PageController();
    gSignIn.onCurrentUserChanged.listen((gSigninAccount) {
      controlSignIn(gSigninAccount);
    },onError: (gError){
      print("Error Message : "+gError);
    });
    try {
      gSignIn.signInSilently(suppressErrors: false).then((
          gSignInAccount) {
        controlSignIn(gSignInAccount);
      }).catchError((gError) {
        print("Error Message : " + gError);
      });
    }catch(e){
      print(e);
    }
  }

  controlSignIn(GoogleSignInAccount signInAccount)async{
    if(signInAccount !=null){
      await saveUserInfoToFireStore();
      setState(() {
        isSignedIn =true;
      });
    }else{
      setState(() {
        isSignedIn=false;
      });
    }
  }

  saveUserInfoToFireStore()async{
      final GoogleSignInAccount gCurrentUser =gSignIn.currentUser;
    DocumentSnapshot documentSnapshot =await userReference.document(gCurrentUser.id).get();

    if(!documentSnapshot.exists){
      final username =await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>CreateAccountPage()));


      userReference.document(gCurrentUser.id).setData({
        "id":gCurrentUser.id,
        "profileName":gCurrentUser.displayName,
        "username":username,
        "url":gCurrentUser.photoUrl,
        "email":gCurrentUser.email,
        "bio":"",
        "timestamp" :timestamp,
      });
      documentSnapshot = await userReference.document(gCurrentUser.id).get();
    }
    currentUser =User.fromDocument(documentSnapshot);

  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  _login()async{
    try {
      await gSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
  logOutUser() async {
    gSignIn.signOut();

  }


  @override

  Widget build(BuildContext context) {
    if(isSignedIn){
      return buildHomeScreen();
    } else {
      return buildSignInScreen();
    }
  }
  Scaffold buildSignInScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pic.jpg",),
            fit: BoxFit.cover
          )
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 200),child: Text("HadisGram",style: TextStyle(fontSize: 92,color: Colors.white,fontFamily: "Signatra"),)),
            InkWell(
              onTap: ()=>_login(),
              child: Container(
                margin: EdgeInsets.only(top: 150),
                width: 250,
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                        image: AssetImage("assets/images/google_signin_button.png"),
                        fit: BoxFit.fill,
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildHomeScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          TimeLinePage(),
          SearchPage(),
          UploadPage(gCurrentUser: currentUser,),
          NotificationsPage(),
          ProfilePage(userProfileId:currentUser.id),//////
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapChangePage,
        backgroundColor:Colors.white,
        activeColor: Colors.blueAccent,
        inactiveColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera,size: 35,)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );

  }
  whenPageChanges(int pageIndex){
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }
  onTapChangePage(int pageIndex){
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);

  }

}
