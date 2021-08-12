import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sq_music_alidrive/controller/home/tabs/kuwo_controller/kuwo_controller.dart';
import 'package:sq_music_alidrive/page/index/tabs/kuwo/widget/top_list_container.dart';

class KuWoHomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KuWoHomeWidget();
}

class _KuWoHomeWidget extends State<KuWoHomeWidget> {
  Size size;
  KuwoController controller = Get.find<KuwoController>();
  Widget _body = Container();
  List<Widget> list = [];

  List<String> dummyList = [];
  TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // size = MediaQuery.of(context).size;
    return SafeArea(
        child: Container(
      // height: size.height*0.8 ,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
                margin: EdgeInsets.all(10),
                // height: size.height * 0.09,
                child: TextField(
                  /// 设置字体
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textInputAction: TextInputAction.done,
                  // onChanged: (value){
                  //   print(value);
                  //
                  // },
                  onSubmitted: (value) {
                    //提交
                    Get.toNamed("/kuwosearchlist",arguments: value);
                    // kuwosearchlist
                    print(value);
                  },

                  /// 设置输入框样式
                  decoration: InputDecoration(
                    hintText: '搜索',

                    /// 边框
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        /// 里面的数值尽可能大才是左右半圆形，否则就是普通的圆角形
                        Radius.circular(90),
                      ),
                    ),

                    ///设置内容内边距
                    contentPadding: EdgeInsets.only(
                      top: 0,
                      bottom: 0,
                    ),

                    /// 前缀图标
                    prefixIcon: Icon(Icons.search),
                  ),
                )),
          ),
          Expanded(
            flex: 8,
            child: Container(
              // height: size.height * 0.7,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    child: Column(
                      children: [
                        _body,
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    myController.addListener(_printLatestValue);
    controller.topCategory().then((value) => {
          if (value["code"] == 200)
            {
              //成功
              print(value),
              //榜单
              print(value["data"][0]),
              for (var tl in value["data"])
                {list.add(TopListContainer(tl["list"], tl["name"]))},
              setState(() {
                _body = Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: list,
                );
              })
            }
          else
            {
              //  提示请求失败
              Fluttertoast.showToast(
                  msg: "请求失败请稍后再试",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0)
            }
        });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    print("文本是: ${myController.text}");
    var suggestSearch = controller.suggestSearch(myController.text);

    // controller.
    // //添加所搜建议
    // suggestSearch
    //
    // dummyList.add(myController.text + ' Item 32432');
    //
    // fetchData().then((value) => {
    // dummyList.addAll(value)
    // });
  }
}
