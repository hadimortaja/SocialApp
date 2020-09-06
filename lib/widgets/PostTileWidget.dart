import 'package:flutter/material.dart';
import 'package:social/pages/PostScreenPage.dart';
import 'package:social/widgets/PostWidget.dart';

class PostTile extends StatelessWidget {
  final Post post;
  PostTile(this.post);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>displayFullPost(context),
      child: Image.network(post.url),
    );
  }
  displayFullPost(context){
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>PostScreenPage(postId:post.postId,userId:post.ownerId)));
  }
}
