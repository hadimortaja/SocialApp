import 'package:flutter/material.dart';
import 'package:social/widgets/HeaderWidget.dart';
import 'package:social/widgets/ProgressWidget.dart';

class TimeLinePage extends StatefulWidget {
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context ,isAppTitle: true,disappearedBackButton: true),
      body: circularProgress(),
    );
  }
}
