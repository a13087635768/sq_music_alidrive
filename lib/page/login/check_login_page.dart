import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sq_music_alidrive/alidrive/client.dart';
import 'package:sq_music_alidrive/db/dbService.dart';
import 'package:sq_music_alidrive/theme/my_colors.dart';
import 'package:sq_music_alidrive/utils/db_utils.dart';
import 'package:sq_music_alidrive/utils/other_utils.dart';

class CheckLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CheckLoginPage();
}

class _CheckLoginPage extends State<CheckLoginPage> {
  Size size;

  // <i class="las la-check-circle"></i>

  double percentage = 0.0;

  var logicon0 =  Icon(LineIcons.checkCircle);
  var logicon1 = Icon(LineIcons.checkCircle);
  var logicon2 =Icon(LineIcons.checkCircle);
  var logicon3 = Icon(LineIcons.checkCircle);
  var logicon4 = Icon(LineIcons.checkCircle);
  var logicon5 = Icon(LineIcons.checkCircle);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return BlurryContainer(
      bgColor:  MyColors.MainBackgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.15,
              ),
              //旋转的加载进度条
              Container(
                height: size.height * 0.2,
                width: size.width,
                child: GFProgressBar(
                  percentage: percentage,
                  lineHeight: 20,
                  // circleStartAngle: 20,
                  circleWidth: 20,
                  radius: 200,
                  type: GFProgressType.circular,
                  reverse: true,
                  child: Text("${percentage * 100}%",
                      style: TextStyle(fontSize: 30), textAlign: TextAlign.end),
                  backgroundColor: Colors.black26,
                  progressBarColor: GFColors.WARNING,
                ),
              ),
              //当前任务
              SizedBox(
                height: size.height * 0.15,
              ),
              Container(
                width: size.width,
                height: size.height * 0.4,
                // color: Colors.deepPurple,
                child: ListView(
                  children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("开始检查:", style: TextStyle(fontSize: 20)),
                    logicon0
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("检查token有效性", style: TextStyle(fontSize: 20)),
                    logicon1
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("正在获取阿里云数据", style: TextStyle(fontSize: 20)),
                    logicon2
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("开始下载config.db文件", style: TextStyle(fontSize: 20)),
                    logicon3
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("正在加载数据库", style: TextStyle(fontSize: 20)),
                    logicon4
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("完毕准备跳转页面", style: TextStyle(fontSize: 20)),
                    logicon5
                  ],
                ),
                  ],
                ),

                // Column(
                //   children: [
                //     Text("开始检查:",style: TextStyle(fontSize: 20)),
                //     Text("检查token有效性",style: TextStyle(fontSize: 20)),
                //     Text("开始写入缓存",style: TextStyle(fontSize: 20)),
                //     Text("正在获取阿里云数据",style: TextStyle(fontSize: 20)),
                //     Text("正在加载数据库",style: TextStyle(fontSize: 20)),
                //     Text("完毕准备跳转页面",style: TextStyle(fontSize: 20))
                //   ],
                // ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init(Get.arguments));

  }

  init(String refresh_token) async {
    //开始加载
    await DBUtil.instance.userinfo.put("refresh_token", refresh_token);
    //开始检查显示为绿色
    setState(() {
      logicon0 = Icon(
        LineIcons.checkCircle,
        color: Colors.green,
      );
      percentage = 0.2;
    });
    //刷新token
    bool refreshToken = await Client.refreshToken();
    if (refreshToken) {
      //获取到token
      setState(() {
        logicon1 = Icon(
          LineIcons.checkCircle,
          color: Colors.green,
        );
        logicon2 = Icon(
          LineIcons.checkCircle,
          color: Colors.green,
        );
        percentage = 0.3;
      });
    } else {
      //失败跳转到登录页面并提示重新输入
      Get.offAndToNamed("/login");
      OtherUtils.showToast("获取RefreshToken失败请减产是否输入正确。");
    }
    setState(() {
      percentage = 0.4;
      logicon3 = Icon(
        LineIcons.checkCircle,
        color: Colors.green,
      );
    });

    bool openDB = await DbServices.openDB();
    if (openDB) {
      setState(() {
        //获取到token
        logicon4 = Icon(
          LineIcons.checkCircle,
          color: Colors.green,
        );
        percentage = 0.8;
      });
    } else {
      Get.offAndToNamed("/login");
      OtherUtils.showToast("阿里云中未发现config.db文件或者config.db损坏");
    }
    setState(() {
      percentage = 1;
    });
    logicon5 = Icon(
      LineIcons.checkCircle,
      color: Colors.green,
    );
    Get.offAndToNamed("/index");
  }
}
