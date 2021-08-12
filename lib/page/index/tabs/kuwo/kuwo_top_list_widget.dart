import 'package:cached_network_image/cached_network_image.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:sq_music_alidrive/controller/home/tabs/kuwo_controller/kuwo_controller.dart';
import 'package:sq_music_alidrive/controller/music/music_play_controller.dart';
import 'package:sq_music_alidrive/theme/my_colors.dart';
import 'package:sq_music_alidrive/utils/db_utils.dart';
import 'package:sq_music_alidrive/utils/music_cach.dart';
import 'package:sq_music_alidrive/utils/other_utils.dart';

class KuwoTopListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KuwoTopListWidget();
}

class _KuwoTopListWidget extends State<KuwoTopListWidget> {
  Size size;
  KuwoController controller = Get.find<KuwoController>();
  MusicPlayController musiccontroller = Get.find<MusicPlayController>();

  var _image = "";
  var name = "".obs;

  //listview组件
  Widget mainbody = Container();

  //查询歌曲总数
  var _musiclistcount = 0;

  //偏移量
  int offset = 0;

  //每页条数
  int limit = 30;

  //歌曲信息
  var musicList = [];

  //允许向下刷新（防止卡的时候还无线下拉）
  bool isallowdown = true;

  //listview的控制器
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MyColors.MainBackgroundColor,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   shadowColor: Colors.transparent,
      //   // foregroundColor: Colors.black,
      //   iconTheme: IconThemeData(
      //       color: Colors.black
      //   ),
      // ),
      body: SafeArea(
        child: Container(
          height: size.height,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: LineIcon.arrowLeft(),
                        color: Colors.black,
                        onPressed: () {},
                      ),
                      Obx(()=> Text( name.value,style: TextStyle(fontSize: 20),)),
                      IconButton(
                        icon: Icon(Icons.more_horiz),
                        color: Colors.black,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 14,
                child: Container(
                    height: size.height,
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: <Widget>[
                        // 如果不是Sliver家族的Widget，需要使用SliverToBoxAdapter做层包裹
                        SliverToBoxAdapter(
                          child: Container(
                            // color: Colors.black,
                            height: size.height * 0.25,
                            child: CachedNetworkImage(
                              width: size.width,
                              fit: BoxFit.fill,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              imageUrl: _image,
                            ),
                          ),
                        ),
                        // 当列表项高度固定时，使用 SliverFixedExtendList 比 SliverList 具有更高的性能
                        SliverFixedExtentList(
                            delegate: SliverChildBuilderDelegate(_buildListItem,
                                childCount: musicList.length),
                            itemExtent: size.height * 0.085),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    name.value = Get.arguments["name"].toString();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //滑动到底部了 页码加1

        //获取新增页面数据
        if ((offset + 1) * limit >= _musiclistcount) {
          print('最后一页了');
        } else {
          print('开始新增数据$offset');
          if (isallowdown) {
            isallowdown = false;
            offset++;
            print(isallowdown);

            controller.top(Get.arguments["id"], offset).then((value) => {
                  if (value["code"] == 200)
                    {
                      setState(() {
                        musicList.addAll(value["data"]["musicList"]);
                      }),
                      isallowdown = true
                    }
                  else
                    {
                      // 获取失败提示请稍后刷新
                      offset--,
                      OtherUtils.showToast("网络暂时出现问题请稍后再试!")
                    }
                });
          } else {
            // 提示稍等在进行刷新
            OtherUtils.showToast("正在努力读取数据。。。");
            print("拉的太快了 稍等。。");
          }
        }
      }
    });
    //获取数据
    if (Get.arguments != null) {
      controller.top(Get.arguments["id"], 0).then((value) => {
            if (value["code"] == 200)
              {
                setState(() {
                  musicList = value["data"]["musicList"];
                  _image = value["data"]["img"].toString();
                  _musiclistcount = int.parse(value["data"]["num"]);
                }),
              }
            else
              {
                // 返回上一页并且提示有问题
                OtherUtils.showToast("数据获取失败请检查网络后重试。。。"),
                Get.back()
              }
          });
    } else {
      // 返回上一页并且提示有问题
      OtherUtils.showToast("数据好像没加载成功请重试。。。");
      Get.back();
    }
  }

  // 列表项
  Widget _buildListItem(BuildContext context, int index) {
    Future<dynamic> gelyric() async {
      print("---------------加载歌词----------------");
      var value = await controller.lyric(musicList[index]["rid"].toString());
      return value["lyric_str"];
    }

    return Container(
      // width: 1000,
      // height: 10000,
      child: FLListTile(
        backgroundColor: Colors.transparent,
        isThreeLine: false,
        // focusColor: AppTheme.other1,
        // leading: Image.asset("image/zhuanji.jpg"),
        leading: CachedNetworkImage(
          placeholder: (context, url) => CircularProgressIndicator(),
          imageUrl: musicList[index]["pic"],
        ),

        // ImageUtils.Base64toImage(_records[item]['musicImage']),
        title: new Text(
          musicList[index]["name"],
          // style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        subtitle: Align(
            child: new Text(
              musicList[index]["artist"],
              // style: TextStyle(color: Colors.white54),
            ),
            alignment: FractionalOffset.topLeft),
        trailing: new Icon(Icons.keyboard_arrow_right),
        onTap: () {
          print("点击歌曲");
          print(musicList[index]["name"]);

          //判断是否是当前歌曲
          bool skip = false;
          if (musiccontroller.isCurrentPlayingMusic(
              MusicCach.simpleMusicGenerateSha1(
                  MusicName: musicList[index]["name"],
                  MusicAlbum: musicList[index]["album"],
                  MusicSongSour: "kugou",
                  MusicArtists: musicList[index]["artist"]))) {
            skip = true;
          }
          if (!skip) {
            //获取下载地址后在进行跳转
            controller.SongPlayUrl(musicList[index]["rid"]).then((value) => {
                  if (value["code"] == 200)
                    {
                      // musiccontroller.addAudio(value["url"], musicList[index]["name"], musicList[index]["artist"], musicList[index]["album"], musicList[index]["pic"],"酷我").then((auto) => {
                      // ;
                      // controller.lyric(musicList[index]["rid"].toString()).then((value) => {
                      //   MusicCach.lyrics[MusicCach.simpleMusicGenerateSha1(MusicName:musicList[index]["name"],MusicArtists:musicList[index]["artist"],MusicAlbum: musicList[index]["album"],MusicSongSour:"kugou")]=value["lyric_str"]
                      // }),
                      //播放歌曲后再跳转
                      Get.toNamed("/musicplay", arguments: {
                        "songname": musicList[index]["name"],
                        "imageurl": musicList[index]["pic"],
                        "artist": musicList[index]["artist"],
                        "playurl": value["url"],
                        "source": "kugou",
                        "id": musicList[index]["rid"],
                        "album": musicList[index]["album"],
                        "data": musicList[index],
                        "gelyric": gelyric(),
                        "isdrive":false
                      })
                      //歌词缓存

                      // })
                    }
                  else
                    {OtherUtils.showToast("获取播放地址失败请稍后再试。。。")}
                });
          } else {
            Get.toNamed("/musicplay", arguments: {
              "songname": musicList[index]["name"],
              "imageurl": musicList[index]["pic"],
              "artist": musicList[index]["artist"],
              "playurl": musiccontroller
                  .assetsAudioPlayer.current.value.audio.audio.path,
              "source": "kugou",
              "id": musicList[index]["rid"],
              "album": musicList[index]["album"],
              "data": musicList[index],
              "gelyric": gelyric()
            });
          }
        },
      ),
    );
  }
}
