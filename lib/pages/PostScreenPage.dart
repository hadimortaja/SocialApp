import 'package:flutter/material.dart';
import 'package:social/widgets/HeaderWidget.dart';
import 'package:social/widgets/PostWidget.dart';
import 'package:social/widgets/ProgressWidget.dart';
import 'home_page.dart';

class PostScreenPage extends StatelessWidget {
  final String postId;
  final String userId;
  PostScreenPage({
    this.postId,
    this.userId,
});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postReference.document(userId).collection("usersPosts").document(postId).get(),
      builder: (context,dataSnapshot){
        if(!dataSnapshot.hasData){
           return circularProgress();
        }
        Post post =Post.fromDocument(dataSnapshot.data);
        return Center(
child: Scaffold(
  appBar: header(context,strTitle:"Posts",disappearedBackButton: false),

  body: ListView(
    children: <Widget>[
      Container(
        child: post,
      ),
    ],
  ),
),
        );
      },

    );
  }
}
