import 'package:flutter/material.dart';

AppBar header(context,{bool isAppTitle=false ,String strTitle,disappearedBackButton =false}) {
  return AppBar(
    elevation: 5,
    iconTheme: IconThemeData(
      color: Colors.black
    ),
    automaticallyImplyLeading: disappearedBackButton ? false :true,
    title: Text(
      isAppTitle ? "HadisGram": strTitle,
      style: TextStyle(color: Colors.black,
      fontFamily:  isAppTitle ? "Signatra": "",
        fontSize: isAppTitle ? 45 : 22,

      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true ,
    backgroundColor: Colors.white,
  );
}
