import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_HomePage();

}
class _HomePage extends State<HomePage>{
  @override
  Widget build(BuildContext context) {

  return  Scaffold(
      body: SafeArea(
          child: Text("首页")
      )
    );
  }

}