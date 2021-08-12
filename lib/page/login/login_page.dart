import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  Size size;
  String refresh_token;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          // border: BoxBorder(),
          image: DecorationImage(
              image: AssetImage("file/login_bg.jpg"), fit: BoxFit.fitHeight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: BlurryContainer(
            child: Column(
              children: [
                //  log
                //   Image.asset("file/log.png"),
                SizedBox(
                  height: size.height * 0.1,
                ),
                SizedBox(
                  child: Text(
                    "SQ  Music",
                    style: TextStyle(
                        fontSize: size.height * 0.08, color: Colors.red[300]),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.15,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  maxLines: 4,
                  //不限制行数
                  /// 设置字体
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    //提交
                    Get.offAndToNamed("/checklogin",arguments: refresh_token);
                    print(value);
                  },
                  onChanged: (value){
                    refresh_token=value;
                  },

                  /// 设置输入框样式
                  decoration: InputDecoration(
                    // icon: Icon(LineIcons.cloud),
                    border: OutlineInputBorder(),
                    // suffixIcon: Icon(Icons.search),
                    // prefixText: 'prefixText ',
                    // suffixText: 'suffixText',
                    labelText: "阿里云盘token",
                    // helperText: '阿里云盘token',
                    // hintText: "用户名或手机号",
                    // prefixIcon: Icon(LineIcons.cloud)
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Container(
                  width: size.width*0.9,
                  child: TextButton(
                    onPressed: () {
                      Get.offAndToNamed("/checklogin",arguments: refresh_token);
                      // print("dsaasd");
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)))),
                    child: new Text(
                      '登录',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
