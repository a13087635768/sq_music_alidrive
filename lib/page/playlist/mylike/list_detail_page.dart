import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/getwidget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sq_music_alidrive/db/dbService.dart';
import 'package:sq_music_alidrive/theme/my_colors.dart';

class ListDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListDetailPage();
}

class _ListDetailPage extends State<ListDetailPage> {
  Widget bodyWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text("我的"),
      ),
      body: SafeArea(
        child: Container(
          child: bodyWidget,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    var playlistid = Get.arguments;
    if (Get.arguments != null) {
      DbServices.playListMusic(Get.arguments).then((playListMusic) => {
            setState(() {
              bodyWidget = ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 0),
                  itemBuilder: (context, item) {
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
                                onTap: () {
                                  Get.toNamed("/musicplay", arguments: {
                                    "songname": playListMusic[item]
                                        ["MusicName"],
                                    "imageurl": playListMusic[item]
                                        ["MusicImagePath"],
                                    "artist": playListMusic[item]
                                        ["MusicArtists"],
                                    "playurl": playListMusic[item]["MusicPath"],
                                    "source": playListMusic[item]
                                        ["MusicSongSour"],
                                    "id": playListMusic[item]["MusicSongId"],
                                    "album": playListMusic[item]["MusicAlbum"],
                                    "data": playListMusic[item],
                                    "suffix": playListMusic[item]
                                        ["MusicCodeType"],
                                    "musuic_size": playListMusic[item]
                                        ["MusicSize"],
                                    "isdrive": true
                                  });
                                },
                                avatar: GFAvatar(
                                    // size: 20,
                                    backgroundImage: NetworkImage(
                                        playListMusic[item]["MusicImagePath"]),
                                    shape: GFAvatarShape.square),
                                titleText: playListMusic[item]["MusicName"],
                                subTitleText: playListMusic[item]
                                    ["MusicArtists"],
                                icon: Icon(LineIcons.angleRight))),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: '删除',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              Alert(
                                  context: context,
                                  style: AlertStyle(
                                    backgroundColor:
                                        MyColors.MainBackgroundColor,
                                    // titleStyle: TextStyle(color: Colors.white)
                                  ),
                                  title: "是否删除该歌曲",
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
                                        DbServices.delMusicToPlayList(
                                                playListMusic[item]["UUID"],
                                                playlistid)
                                            .then((value) => {
                                                  DbServices.playListMusic(
                                                      playlistid)
                                                      .then((playListMusic) => {
                                                    setState(() {
                                                      bodyWidget = ListView.separated(
                                                          scrollDirection: Axis.vertical,
                                                          shrinkWrap: true,
                                                          padding: EdgeInsets.only(top: 0),
                                                          itemBuilder: (context, item) {
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
                                                                        onTap: () {
                                                                          Get.toNamed("/musicplay", arguments: {
                                                                            "songname": playListMusic[item]
                                                                            ["MusicName"],
                                                                            "imageurl": playListMusic[item]
                                                                            ["MusicImagePath"],
                                                                            "artist": playListMusic[item]
                                                                            ["MusicArtists"],
                                                                            "playurl": playListMusic[item]["MusicPath"],
                                                                            "source": playListMusic[item]
                                                                            ["MusicSongSour"],
                                                                            "id": playListMusic[item]["MusicSongId"],
                                                                            "album": playListMusic[item]["MusicAlbum"],
                                                                            "data": playListMusic[item],
                                                                            "suffix": playListMusic[item]
                                                                            ["MusicCodeType"],
                                                                            "musuic_size": playListMusic[item]
                                                                            ["MusicSize"],
                                                                            "isdrive": true
                                                                          });
                                                                        },
                                                                        avatar: GFAvatar(
                                                                          // size: 20,
                                                                            backgroundImage: NetworkImage(
                                                                                playListMusic[item]["MusicImagePath"]),
                                                                            shape: GFAvatarShape.square),
                                                                        titleText: playListMusic[item]["MusicName"],
                                                                        subTitleText: playListMusic[item]
                                                                        ["MusicArtists"],
                                                                        icon: Icon(LineIcons.angleRight))),
                                                                secondaryActions: <Widget>[
                                                                  IconSlideAction(
                                                                    caption: '删除',
                                                                    color: Colors.red,
                                                                    icon: Icons.delete,
                                                                    onTap: () {
                                                                      Alert(
                                                                          context: context,
                                                                          style: AlertStyle(
                                                                            backgroundColor:
                                                                            MyColors.MainBackgroundColor,
                                                                            // titleStyle: TextStyle(color: Colors.white)
                                                                          ),
                                                                          title: "是否删除该歌曲",
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
                                                                                DbServices.delMusicToPlayList(
                                                                                    playListMusic[item]["UUID"],
                                                                                    playlistid)
                                                                                    .then((value) => {
                                                                                  DbServices.playListMusic(
                                                                                      Get.arguments)
                                                                                      .then((playListMusic) => {




                                                                                    Get.back()
                                                                                  })
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
                                                            );
                                                          },
                                                          separatorBuilder: (BuildContext context, int index) =>
                                                          new Divider(
                                                            color: MyColors.DividerColor,
                                                          ),
                                                          itemCount: playListMusic.length);
                                                    }),
                                                  Get.back()
                                                  })
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
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      new Divider(
                        color: MyColors.DividerColor,
                      ),
                  itemCount: playListMusic.length);
            })
          });
    } else {
      // //我喜欢的页面跳转来的
      DbServices.myLikeMusic().then((playListMusic) => {
            setState(() {
              bodyWidget = ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 0),
                  itemBuilder: (context, item) {
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
                                onTap: () {
                                  Get.toNamed("/musicplay", arguments: {
                                    "songname": playListMusic[item]
                                        ["MusicName"],
                                    "imageurl": playListMusic[item]
                                        ["MusicImagePath"],
                                    "artist": playListMusic[item]
                                        ["MusicArtists"],
                                    "playurl": playListMusic[item]["MusicPath"],
                                    "source": playListMusic[item]
                                        ["MusicSongSour"],
                                    "id": playListMusic[item]["MusicSongId"],
                                    "album": playListMusic[item]["MusicAlbum"],
                                    "data": playListMusic[item],
                                    "suffix": playListMusic[item]
                                        ["MusicCodeType"],
                                    "musuic_size": playListMusic[item]
                                        ["MusicSize"],
                                    "isdrive": true
                                  });
                                },
                                avatar: GFAvatar(
                                    // size: 20,
                                    backgroundImage: NetworkImage(
                                        playListMusic[item]["MusicImagePath"]),
                                    shape: GFAvatarShape.square),
                                titleText: playListMusic[item]["MusicName"],
                                subTitleText: playListMusic[item]
                                    ["MusicArtists"],
                                icon: Icon(LineIcons.angleRight))),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: '取消',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              Alert(
                                  context: context,
                                  style: AlertStyle(
                                    backgroundColor:
                                        MyColors.MainBackgroundColor,
                                    // titleStyle: TextStyle(color: Colors.white)
                                  ),
                                  title: "是否取消喜欢该歌曲",
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
                                        DbServices.dellikeMuisc(
                                                playListMusic[item]["UUID"])
                                            .then((value) => {
                                                  DbServices.myLikeMusic()
                                                      .then((playListMusic) => {
                                                            setState(() {
                                                              bodyWidget = ListView
                                                                  .separated(
                                                                      scrollDirection: Axis
                                                                          .vertical,
                                                                      shrinkWrap:
                                                                          true,
                                                                      padding: EdgeInsets.only(
                                                                          top:
                                                                              0),
                                                                      itemBuilder:
                                                                          (context,
                                                                              item) {
                                                                        return Container(
                                                                          width:
                                                                              100,
                                                                          height:
                                                                              100,
                                                                          color:
                                                                              Colors.transparent,
                                                                          child:
                                                                              Slidable(
                                                                            actionPane:
                                                                                SlidableDrawerActionPane(),
                                                                            actionExtentRatio:
                                                                                0.25,
                                                                            child: Container(
                                                                                // color: Colors.white,
                                                                                child: GFListTile(
                                                                                    onTap: () {
                                                                                      Get.toNamed("/musicplay", arguments: {
                                                                                        "songname": playListMusic[item]["MusicName"],
                                                                                        "imageurl": playListMusic[item]["MusicImagePath"],
                                                                                        "artist": playListMusic[item]["MusicArtists"],
                                                                                        "playurl": playListMusic[item]["MusicPath"],
                                                                                        "source": playListMusic[item]["MusicSongSour"],
                                                                                        "id": playListMusic[item]["MusicSongId"],
                                                                                        "album": playListMusic[item]["MusicAlbum"],
                                                                                        "data": playListMusic[item],
                                                                                        "suffix": playListMusic[item]["MusicCodeType"],
                                                                                        "musuic_size": playListMusic[item]["MusicSize"],
                                                                                        "isdrive": true
                                                                                      });
                                                                                    },
                                                                                    avatar: GFAvatar(
                                                                                        // size: 20,
                                                                                        backgroundImage: NetworkImage(playListMusic[item]["MusicImagePath"]),
                                                                                        shape: GFAvatarShape.square),
                                                                                    titleText: playListMusic[item]["MusicName"],
                                                                                    subTitleText: playListMusic[item]["MusicArtists"],
                                                                                    icon: Icon(LineIcons.angleRight))),
                                                                            secondaryActions: <Widget>[
                                                                              IconSlideAction(
                                                                                caption: '取消',
                                                                                color: Colors.red,
                                                                                icon: Icons.delete,
                                                                                onTap: () {
                                                                                  Alert(
                                                                                      context: context,
                                                                                      style: AlertStyle(
                                                                                        backgroundColor: MyColors.MainBackgroundColor,
                                                                                        // titleStyle: TextStyle(color: Colors.white)
                                                                                      ),
                                                                                      title: "是否取消喜欢该歌曲",
                                                                                      buttons: [
                                                                                        DialogButton(
                                                                                            color: Colors.transparent,
                                                                                            onPressed: () {
                                                                                              Get.back();
                                                                                            },
                                                                                            child: Text(
                                                                                              "取消",
                                                                                              style: TextStyle(color: Colors.blue, fontSize: 20),
                                                                                            )),
                                                                                        DialogButton(
                                                                                          color: Colors.transparent,
                                                                                          onPressed: () {
                                                                                            DbServices.dellikeMuisc(playListMusic[item]["UUID"]).then((value) => {
                                                                                                  DbServices.myLikeMusic().then((playListMusic) => {})
                                                                                                });
                                                                                          },
                                                                                          child: Text(
                                                                                            "确定",
                                                                                            style: TextStyle(color: Colors.blue, fontSize: 20),
                                                                                          ),
                                                                                        )
                                                                                      ]).show();
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                      separatorBuilder:
                                                                          (BuildContext context, int index) =>
                                                                              new Divider(
                                                                                color: MyColors.DividerColor,
                                                                              ),
                                                                      itemCount:
                                                                          playListMusic
                                                                              .length);
                                                            }),
                                                            Get.back()
                                                          })
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
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      new Divider(
                        color: MyColors.DividerColor,
                      ),
                  itemCount: playListMusic.length);
            })
          });
    }
  }
}
