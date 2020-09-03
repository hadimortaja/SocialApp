import 'package:cloud_firestore/cloud_firestore.dart';
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

final GoogleSignIn _googleSignIn =GoogleSignIn();
final userReference =Firestore.instance.collection("users");

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
    _googleSignIn.onCurrentUserChanged.listen((gSigninAccount) {
      controlSignIn(gSigninAccount);
    },onError: (gError){
      print("Error Message : "+gError);
    });
    try {
      _googleSignIn.signInSilently(suppressErrors: false).then((
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
    final GoogleSignInAccount gCurrentUser =_googleSignIn.currentUser;
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
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
  _logout(){
    _googleSignIn.signOut();

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
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("HadisGram",style: TextStyle(fontSize: 92,color: Colors.white,fontFamily: "Signatra"),),
            InkWell(
              onTap: ()=>_login(),
              child: Container(
                width: 270,
                height: 65,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/google_signin_button.png"),
                        fit: BoxFit.cover
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
          UploadPage(),
          NotificationsPage(),
          ProfilePage(),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapChangePage,
        backgroundColor: Theme.of(context).accentColor,
        activeColor: Colors.white,
        inactiveColor: Colors.blueGrey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera,size: 35,)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
//    return RaisedButton.icon(onPressed: ()=>_logout(),
//      icon: Icon(Icons.close),
//      label: Text("Sign Out"),
//    );
  }
  whenPageChanges(int pageIndex){
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }
  onTapChangePage(int pageIndex){
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);

  }

}
