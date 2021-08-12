import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrivePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_DrivePage();

}
class _DrivePage extends State<DrivePage>{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SafeArea(
            child: Text("云页面")
        )
    );
  }

}