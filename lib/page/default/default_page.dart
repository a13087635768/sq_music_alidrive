import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:sq_music_alidrive/alidrive/client.dart';
import 'package:sq_music_alidrive/controller/music/music_play_controller.dart';
import 'package:sq_music_alidrive/db/dbService.dart';
import 'package:sq_music_alidrive/theme/my_colors.dart';
import 'package:sq_music_alidrive/utils/db_utils.dart';

class DefaultPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_DefaultPage();

}
class _DefaultPage extends   State<DefaultPage>{
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    // init();
    return Scaffold(
      backgroundColor: MyColors.MainBackgroundColor,
        body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height*0.2),
                Center(child: Text("SQ MUSIC",style: TextStyle(fontSize: size.height*0.07),)),
                SizedBox(height: size.height*0.2),
                Center(child: Text("广告位招租",style: TextStyle(fontSize: size.height*0.03),)),
                SizedBox(height: size.height*0.2),
                GFLoader(
                  size: size.height*0.07,
                ),
              ],
            )
        )
    );
  }


  @override
  void initState() {
    super.initState();
    MusicPlayController musiccontroller = Get.find<MusicPlayController>();
    musiccontroller.assetsAudioPlayer;
    // init();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());

  }

  init() async {

    //检查token
    bool iserror=false;
    try {
      String refresh_token =DBUtil.instance.userinfo.get("refresh_token");
      if(refresh_token!=null){
        //刷新token
        bool refreshToken = await Client.refreshToken();
        if(!refreshToken){
          //一共检查5次
          int count=0;
          const timeout = const Duration(seconds: 2);
          Timer.periodic(timeout, (timer) async{ //callback function
            if(await Client.refreshToken()){
              iserror=false;
              timer.cancel();
            }else{
              count++;
              if(count==5){
                //在规定次数内还没有获取成功
                iserror=true;
                timer.cancel();
                //错误重新登录
                Get.offAndToNamed("/login");
                return;
              }
            }

          });

        }else{
          iserror=false;
        }
        if(await DbServices.openDB()){
          iserror=false;
        }else{
          iserror=true;
        }
      }else{
        iserror=true;
      }

      if(iserror){
        //错误重新登录
        Get.offAndToNamed("/login");
      }else{
        Get.offAndToNamed("/index");
      }

    } catch (e) {
      print(e);
      Get.offAndToNamed("/login");
    }
  }
}