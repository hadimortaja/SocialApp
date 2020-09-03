import 'package:flutter/material.dart';

AppBar header(context,{bool isAppTitle=false ,String strTitle,disappearedBackButton =false}) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white
    ),
    automaticallyImplyLeading: disappearedBackButton ? false :true,
    title: Text(
      isAppTitle ? "HadisGram": strTitle,
      style: TextStyle(color: Colors.white,
      fontFamily:  isAppTitle ? "Signatra": "",
        fontSize: isAppTitle ? 45 : 22,

      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true ,
    backgroundColor: Theme.of(context).accentColor,
  );
}
