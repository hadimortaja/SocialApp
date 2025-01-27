import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social/widgets/HeaderWidget.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _scaffoldKey =GlobalKey<ScaffoldState>();
  final _formKey =GlobalKey<FormState>();
  String username;

  submitUsername(){
    final form =_formKey.currentState;
    if(form.validate()){
       form.save();
       SnackBar snackBar =SnackBar(
         content: Text("Welcome "+username),
       );
       _scaffoldKey.currentState.showSnackBar(snackBar);
       Timer(Duration(seconds: 4),(){
         Navigator.pop(context,username);
       });
    }
  }


  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context,strTitle: "Settings",disappearedBackButton: true),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(padding:EdgeInsets.only(top: 26) ,
                child: Center(
                  child: Text("Set up a username",style: TextStyle(fontSize: 26),),
                ),
                ),
                Padding(
                  padding: EdgeInsets.all(17),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black),
                        validator: (val){
                           if(val.trim().length<5||val.isEmpty){
                             return "Username is Very Short";
                           }else if(val.trim().length>15){
                             return "Username is Very Long";
                           }else{
                             return null;
                           }
                        },
                        onSaved: (val)=>username =val,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          border: OutlineInputBorder(),
                          labelText: "Username",
                          labelStyle: TextStyle(fontSize: 16),
                          hintText: "must be at least 5 characters",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submitUsername,
                  child: Container(
                    height: 55,
                    width: 360,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text("Proceed",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),),
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
}
