import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sq_music_alidrive/db/dbService.dart';
import 'package:sq_music_alidrive/theme/my_colors.dart';
import 'package:sq_music_alidrive/utils/music_cach.dart';
import 'package:sq_music_alidrive/utils/other_utils.dart';
import 'package:uuid/uuid.dart';

class MyPlayListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyPlayListPage();
}

class _MyPlayListPage extends State<MyPlayListPage> {
  Size size;
  int mylikesize = 0;
  List<Map<String, Object>> mylikedata;

  List<Map<String, Object>> PlayList;
  String inputvalue;
  Widget PlayListWidget = Container();
  Map<String, dynamic> PlayListData = {};
  Widget mylikesimages;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        // width: size.width,
        child: Column(
          children: [
            //顶部  本人信息(移动至头部)
            // Expanded(
            //   flex: 2,
            //   child: Container(color: Colors.blue,child:
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       //头像
            //
            //       Expanded(flex: 1,child: Image.network("https://img3.kuwo.cn/star/upload/3/6/1627080092.png")),
            //       //名称
            //       Expanded(
            //         flex: 7,
            //         child: Container(
            //           color: Colors.green,
            //           child: Row(
            //             children: [
            //               Column(
            //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                 children: [
            //                   Text("SQ MUSIC",textAlign:TextAlign.start),
            //                   Text("共4首歌",textAlign:TextAlign.start),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         flex: 1,
            //         child: IconButton(icon: Icon(LineIcons.table), onPressed: (){
            //           OtherUtils.showToast("还没想好做啥功能");
            //         }),
            //       )
            //     ],
            //   )
            //   ),
            // ),

            //歌曲推荐
            Expanded(
              flex: 6,
              child: BlurryContainer(
                blur: 3,
                bgColor: Colors.white60,
                child: Container(
                    child: Container(
                  // color: Colors.deepPurple,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text("歌曲推荐地方"),
                        ],
                      ),
                    ],
                  ),
                )),
              ),
            ),
            // //云盘所有歌曲（只展示活播放不做管理）
            // Expanded(
            //   flex: 1,
            //   child: Container(color: Colors.red,child: Text("云盘所有歌曲")),
            // ),
            // Expanded(flex: 1, child: Container()),
            //我喜欢的歌曲
            // Expanded(
            //   flex: 7,
            //   child: BlurryContainer(
            //     blur: 1,
            //     bgColor: Colors.white60,
            //     child: Container(
            //         child: GFListTile(
            //             onTap: (){
            //               Get.toNamed("/listdetailpage");
            //             },
            //             avatar:mylikesimages,
            //             titleText: "我喜欢的歌曲",
            //             subTitleText: '共计' +
            //                mylikesize
            //                     .toString() +
            //                 '首歌',
            //             icon: Icon(LineIcons.angleRight))),
            //         ),
            // ),
            // Expanded(flex: 1, child: Container()),
            //歌单操作 （增加。。）
            Expanded(
              flex: 2,
              child: BlurryContainer(
                // blur:0,
                // bgColor: Colors.yellow,
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "我的歌单",
                      style: TextStyle(fontSize: size.height * 0.017),
                    ),
                    IconButton(
                        icon: Icon(LineIcons.plusCircle),
                        onPressed: () {
                          //新增歌曲
                          Alert(
                              style: AlertStyle(
                                backgroundColor: MyColors.MainBackgroundColor,
                                // titleStyle: TextStyle(color: Colors.white)
                              ),
                              context: context,
                              title: "新增歌单",
                              content: Column(
                                children: <Widget>[
                                  TextField(
                                    decoration: InputDecoration(
                                        // icon: Icon(Icons.account_circle),
                                        // labelText: 'Username',
                                        ),
                                    onChanged: (value) {
                                      inputvalue = value;
                                    },
                                  ),
                                  // TextField(
                                  //   obscureText: true,
                                  //   decoration: InputDecoration(
                                  //     icon: Icon(Icons.lock),
                                  //     labelText: 'Password',
                                  //   ),
                                  // ),
                                ],
                              ),
                              buttons: [
                                DialogButton(
                                    color: Colors.transparent,
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      "取消",
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 20),
                                    )),
                                DialogButton(
                                  color: Colors.transparent,
                                  onPressed: () {
                                    if (inputvalue != null) {
                                      DbServices.addPlayList(inputvalue).then(
                                          (value) => {
                                                OtherUtils.showToast("添加成功"),
                                                inputvalue = null,
                                                Get.back(),
                                                init()
                                              });
                                    } else {
                                      OtherUtils.showToast("请输入歌单名称");
                                    }
                                  },
                                  child: Text(
                                    "确定",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 20),
                                  ),
                                )
                              ]).show();
                          print("新增歌单");
                        })
                    // Text("操作",style: TextStyle(fontSize: size.height*0.015),),
                  ],
                )),
              ),
            ),
            // Expanded(
            //     flex: 1,
            //     child: Container()
            // ),

            //所有歌单列表
            Expanded(
              flex: 15,
              child: BlurryContainer(
                  bgColor: Colors.white60, child:
                  Column(
                    children: [
                      Container(
                          child: GFListTile(
                              onTap: (){
                                Get.toNamed("/listdetailpage");
                              },
                              avatar:mylikesimages,
                              titleText: "我喜欢的歌曲",
                              subTitleText: '共计' +
                                  mylikesize
                                      .toString() +
                                  '首歌',
                              icon: Icon(LineIcons.angleRight))),
                      PlayListWidget
                    ],
                  )


              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    //获取我喜欢的歌曲列表(全部获取)
    //异步获取提高加载速度
    super.initState();

    DbServices.myLikeMusic()
        .then((value) => {

          mylikesize = value.length, mylikedata = value,
          if(mylikesize>0&&mylikesize<4){
            //显示第一个
        setState(() {
      mylikesimages =
          GFAvatar(
              backgroundImage: NetworkImage(
                  mylikedata[0]["MusicImagePath"]),
              shape: GFAvatarShape.square);
    })

          }else if(mylikesize>3){
            //显示TOP4
            mylikesimages = Column(
              children: [
                Row(
                  children: [
                    GFAvatar(
                      size: size.height*0.025,
                        backgroundImage: NetworkImage(
                            mylikedata[0]["MusicImagePath"]),
                        shape: GFAvatarShape.square),
                    GFAvatar(
                        size: size.height*0.025,
                        backgroundImage: NetworkImage(
                            mylikedata[1]["MusicImagePath"],
                        ),
                        shape: GFAvatarShape.square)
                  ],
                ),
                Row(
                  children: [
                    GFAvatar(
                        size: size.height*0.025,
                        backgroundImage: NetworkImage(
                            mylikedata[2]["MusicImagePath"]),
                        shape: GFAvatarShape.square),
                    GFAvatar(
                        size: size.height*0.025,
                        backgroundImage: NetworkImage(
                            mylikedata[3]["MusicImagePath"]),
                        shape: GFAvatarShape.square)
                  ],
                ),
              ],
            )

          }else{
            //显示默认
            mylikesimages =GFAvatar(
                // size: size.height*0.025,
                backgroundImage: AssetImage(
                   "file/no_music.jpg"),
                shape: GFAvatarShape.square)

          }

        });
    init();
  }

  init() async {
    PlayList = await DbServices.myAllPlayList();
    for (var plydata in PlayList) {
      var TEMP = await DbServices.playListMusic(plydata["UUID"]);
      PlayListData[plydata["UUID"]] = TEMP;
    }
    setState(() {
      PlayListWidget = PlayList.length == 0
          ? Container(
              width: size.width,
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(
                      LineIcons.plusCircle,
                      color: Colors.black12,
                    ),
                    iconSize: size.height * 0.3,
                    onPressed: () {
                      Alert(
                          style: AlertStyle(
                            backgroundColor: MyColors.MainBackgroundColor,
                            // titleStyle: TextStyle(color: Colors.white)
                          ),
                          context: context,
                          title: "新增歌单",
                          content: Column(
                            children: <Widget>[
                              TextField(
                                decoration: InputDecoration(
                                    // icon: Icon(Icons.account_circle),
                                    // labelText: 'Username',
                                    ),
                                onChanged: (value) {
                                  inputvalue = value;
                                },
                              ),
                              // TextField(
                              //   obscureText: true,
                              //   decoration: InputDecoration(
                              //     icon: Icon(Icons.lock),
                              //     labelText: 'Password',
                              //   ),
                              // ),
                            ],
                          ),
                          buttons: [
                            DialogButton(
                                color: Colors.transparent,
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  "取消",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 20),
                                )),
                            DialogButton(
                              color: Colors.transparent,
                              onPressed: () {
                                if (inputvalue != null) {
                                  DbServices.addPlayList(inputvalue).then(
                                      (value) => {
                                            OtherUtils.showToast("添加成功"),
                                            inputvalue = null,
                                            Get.back(),
                                            init()
                                          });
                                } else {
                                  OtherUtils.showToast("请输入歌单名称");
                                }
                              },
                              child: Text(
                                "确定",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 20),
                              ),
                            )
                          ]).show();
                    },
                  ),
                  Text("点击添加歌单")
                  // Text("所有歌单列表"),
                ],
              ),
            )
          : ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 0),
              itemBuilder: (context, item) {
                Widget temp;
                if(PlayListData[PlayList[item]["UUID"]]
                    .length>0&&PlayListData[PlayList[item]["UUID"]]
                    .length<4){
                  //单个图片
                  temp = GFAvatar(
                      backgroundImage: NetworkImage(
                          PlayListData[PlayList[item]["UUID"]][0]["MusicImagePath"]),
                      shape: GFAvatarShape.square);
                }else if (PlayListData[PlayList[item]["UUID"]]
                    .length>3){

                  temp = Column(
                    children: [
                      Row(
                        children: [
                          GFAvatar(
                              size: size.height*0.025,
                              backgroundImage: NetworkImage(
                                  PlayListData[PlayList[item]["UUID"]][0]["MusicImagePath"]),
                              shape: GFAvatarShape.square),
                          GFAvatar(
                              size: size.height*0.025,
                              backgroundImage: NetworkImage(
                                  PlayListData[PlayList[item]["UUID"]][1]["MusicImagePath"]),
                              shape: GFAvatarShape.square)
                        ],
                      ),
                      Row(
                        children: [
                          GFAvatar(
                              size: size.height*0.025,
                              backgroundImage: NetworkImage(
                                  PlayListData[PlayList[item]["UUID"]][2]["MusicImagePath"]),
                              shape: GFAvatarShape.square),
                          GFAvatar(
                              size: size.height*0.025,
                              backgroundImage:NetworkImage(
                                  PlayListData[PlayList[item]["UUID"]][3]["MusicImagePath"]),
                              shape: GFAvatarShape.square)
                        ],
                      ),
                    ],
                  );


                }else{
                  temp =GFAvatar(
                    // size: size.height*0.025,
                      backgroundImage: AssetImage(
                          "file/no_music.jpg"),
                      shape: GFAvatarShape.square);
                }


                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.transparent,
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                        // color: Colors.white,
                        child: GFListTile(
                          onTap: (){
                            Get.toNamed("/listdetailpage", arguments:  PlayList[item]["UUID"]);
                          },
                            avatar: temp,
                            titleText: PlayList[item]["playName"],
                            subTitleText: '共计' +
                                PlayListData[PlayList[item]["UUID"]]
                                    .length
                                    .toString() +
                                '首歌',
                            icon: Icon(LineIcons.angleRight))),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: '修改',
                        color: Colors.black45,
                        icon: Icons.more_horiz,
                        onTap: () {
                          Alert(
                              style: AlertStyle(
                                backgroundColor: MyColors.MainBackgroundColor,
                                // titleStyle: TextStyle(color: Colors.white)
                              ),
                              context: context,
                              title: "修改歌单名称",
                              content: Column(
                                children: <Widget>[
                                  TextField(
                                    decoration: InputDecoration(
                                        // icon: Icon(Icons.account_circle),
                                        // labelText: 'Username',
                                        ),
                                    onChanged: (value) {
                                      inputvalue = value;
                                    },
                                  ),
                                  // TextField(
                                  //   obscureText: true,
                                  //   decoration: InputDecoration(
                                  //     icon: Icon(Icons.lock),
                                  //     labelText: 'Password',
                                  //   ),
                                  // ),
                                ],
                              ),
                              buttons: [
                                DialogButton(
                                    color: Colors.transparent,
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      "取消",
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 20),
                                    )),
                                DialogButton(
                                  color: Colors.transparent,
                                  onPressed: () {
                                    if (inputvalue != null) {
                                      DbServices.updatePlayListName(
                                              PlayList[item]["UUID"].toString(),
                                              inputvalue)
                                          .then((value) => {
                                                OtherUtils.showToast("修改成功"),
                                                inputvalue = null,
                                                Get.back(),
                                                init()
                                              });
                                    } else {
                                      OtherUtils.showToast("请输入歌单名称");
                                    }
                                  },
                                  child: Text(
                                    "确定",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 20),
                                  ),
                                )
                              ]).show();
                        },
                      ),
                      IconSlideAction(
                        caption: '删除',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          Alert(
                              context: context,
                              style: AlertStyle(
                                backgroundColor: MyColors.MainBackgroundColor,
                                // titleStyle: TextStyle(color: Colors.white)
                              ),
                              title: "是否删除该歌单",
                              buttons: [
                                DialogButton(
                                    color: Colors.transparent,
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      "取消",
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 20),
                                    )),
                                DialogButton(
                                  color: Colors.transparent,
                                  onPressed: () {
                                    DbServices.delPlayList(
                                            PlayList[item]["UUID"])
                                        .then((value) => {
                                              Get.back(),
                                              OtherUtils.showToast(value
                                                  ? "删除成功！"
                                                  : "删除失败稍后再试！"),
                                              init()
                                            });
                                  },
                                  child: Text(
                                    "确定",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 20),
                                  ),
                                )
                              ]).show();
                        },
                      ),
                    ],
                  ),

                  // FLListTile(
                  //   isThreeLine: false,
                  //   backgroundColor: Colors.transparent,
                  //   leading: CachedNetworkImage(
                  //     placeholder: (context, url) => CircularProgressIndicator(),
                  //     imageUrl: musicinfo[item]["pic"],
                  //   ),
                  //   title: new Text(
                  //     musicinfo[item]["name"],
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //     ),
                  //   ),
                  //   subtitle: Align(
                  //       child: new Text(musicinfo[item]["artist"]
                  //         // style: TextStyle(
                  //         //     color: Colors.white54),
                  //       ),
                  //       alignment: FractionalOffset.topLeft),
                  //   trailing: new Icon(
                  //     Icons.keyboard_arrow_right,
                  //     // color: Colors.white,
                  //   ),
                  //   onTap: () {
                  //
                  //
                  //   },
                  // ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  new Divider(
                    color: MyColors.DividerColor,
                  ),
              itemCount: PlayList.length);
    });
  }
}
