import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social/models/user.dart';
import 'package:social/pages/home_page.dart';
import 'package:social/widgets/CImageWidget.dart';
import 'package:social/widgets/ProgressWidget.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final dynamic likes;
  final String username;
  final String description;
  final String location;
  final String url;
  Post({
    this.postId,
    this.ownerId,
    this.likes,
    this.username,
    this.description,
    this.location,
    this.url,
  });
  factory Post.fromDocument(DocumentSnapshot documentSnapshot){
    return Post(
      postId: documentSnapshot["postId"],
      ownerId: documentSnapshot["ownerId"],
      likes: documentSnapshot["likes"],
      username: documentSnapshot["username"],
      description: documentSnapshot["description"],
      location: documentSnapshot["location"],
      url: documentSnapshot["url"],
    );
  }
  int getTotalNumberOfLikes(likes){
    if(likes==null){
      return 0;
    }
    int counter =0;
    likes.values.forEach((eachValue){
      if(eachValue==true){
        counter =counter+1;
      }
    });
    return counter;
  }
  @override
  _PostState createState() => _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        likes: this.likes,
        username: this.username,
        description: this.description,
        location: this.location,
        url: this.url,
        likeCount: getTotalNumberOfLikes(this.likes),
      );
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  Map likes;
  final String username;
  final String description;
  final String location;
  final String url;
  int likeCount;
  bool isLiked;
  bool showHeart =false;
  final String currentOnlineUserId =currentUser?.id;

  _PostState({
    this.postId,
    this.ownerId,
    this.likes,
    this.username,
    this.description,
    this.location,
    this.url,
    this.likeCount,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          createPostHead(),
          createPostPicture(),
          createPostFooter(),
        ],
      ),
    );
  }
  createPostHead(){
    return FutureBuilder(
      future: userReference.document(ownerId).get(),
      builder: (context,dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress();
        }
        User user =User.fromDocument(dataSnapshot.data);
        bool isPostOwner =currentOnlineUserId==ownerId;
        return ListTile(
          leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(user.url),backgroundColor: Colors.grey,),
          title: GestureDetector(
            onTap: ()=>print("Show Profile"),
            child: Text(user.username,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
            ),
          ),
          subtitle: Text(location,style: TextStyle(color: Colors.black),),
          trailing: isPostOwner ? IconButton(icon: Icon(Icons.more_vert,color: Colors.black,),
            onPressed: ()=>print("Delete"),
          ):Text(""),
        );
      },
    );
  }
  createPostPicture(){
    return GestureDetector(
onDoubleTap: ()=>print("Post Liked"),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(url),
        ],
      ),
    );
  }
  createPostFooter(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40,left: 20)),
            GestureDetector(
              onTap:()=>print("Liked Post"),
              child: Icon(
                Icons.favorite,color: Colors.grey,
//                isLiked ? Icons.favorite:Icons.favorite_border,
//                size: 28,
//                color: Colors.red,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(right: 20,)),
            GestureDetector(
              onTap:()=>print("show comments"),
              child: Icon(Icons.chat_bubble_outline,size: 25,color: Colors.grey,),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text("$likeCount likes",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text("$username ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
            ),
            Expanded(
              child: Text(description ,style: TextStyle(color: Colors.black),),
            )
          ],
        )
      ],
    );
  }
}
