 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_SetPage();

}
class _SetPage extends State<SetPage>{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: SafeArea(
            child: Text("设置页面")
        )
    );
  }
}