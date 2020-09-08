import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';


circularProgress() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
     crossAxisAlignment: CrossAxisAlignment.center,
     children: <Widget>[
       Padding(
         padding: EdgeInsets.only(top: 15),
       child: JumpingText(
         "Loading...",style: TextStyle(
           fontSize: 20,
       ),
       ),
       ),
       SizedBox(height: 20,)
     ],

    ),
  );

}

linearProgress() {
  Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation (Colors.blue),
    ),
  );
}
