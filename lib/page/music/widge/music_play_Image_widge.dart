import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


/// 歌曲图像
class MusicPlayImageWidge extends StatelessWidget {
  String imagepath = "";
  Map lyrics =Map();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var image  =CachedNetworkImage(
      width: size.width * 0.9,
      height: size.width * 0.9,
      fit: BoxFit.fill,
      placeholder: (context, url) =>
          CircularProgressIndicator(),
      imageUrl: imagepath,
    );
    return InkWell(
      child: Center(
          child: Container(
            // color: Colors.yellow,
            child: ClipOval(
              child: image,
            ),
            width: size.width * 0.5,
            height: size.width * 0.5,
            // color: AppTheme.white
          )),
    );
  }

  MusicPlayImageWidge(String imagepath) {
    this.imagepath = imagepath;

  }
}