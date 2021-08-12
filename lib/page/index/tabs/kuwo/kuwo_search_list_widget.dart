import 'package:cached_network_image/cached_network_image.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sq_music_alidrive/controller/home/tabs/kuwo_controller/kuwo_controller.dart';
import 'package:sq_music_alidrive/controller/music/music_play_controller.dart';
import 'package:sq_music_alidrive/theme/my_colors.dart';
import 'package:sq_music_alidrive/utils/music_cach.dart';
import 'package:sq_music_alidrive/utils/other_utils.dart';

class KuwoSearchListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KuwoSearchListWidget();
}

class _KuwoSearchListWidget extends State<KuwoSearchListWidget> {
  String key = "";
  ScrollController _scrollController = ScrollController();
  var musicinfo = [];
  int total = 0;
  int pagesize = 30;
  int pageindex = 1;
  var listView ;
  KuwoController controller = Get.find<KuwoController>();
  MusicPlayController musiccontroller = Get.find<MusicPlayController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.MainBackgroundColor,
      body: SafeArea(
        child: Container(
          child: listView
        ),
      ),
    );
  }


  @override
  void initState() {
    //搜索关键字
    key = Get.arguments;

    controller.search(key, limit: pagesize, offset: pageindex).then((value) =>
    {
      //加载数据
      if (value["code"] == 200)
        {
          setState(() {
            total = int.parse(value["data"]["total"]);
            musicinfo = value["data"]["list"];
            listView =ListView.separated(
                controller: _scrollController,
                // scrollDirection: Axis.vertical,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 0),
                itemBuilder: (context, item) {
                  return Container(
                    // width: 1000,
                    // height: 10000,
                    color: Colors.transparent,
                    child: FLListTile(
                      isThreeLine: false,
                      backgroundColor: Colors.transparent,
                      leading: CachedNetworkImage(
                        placeholder: (context, url) => CircularProgressIndicator(),
                        imageUrl: musicinfo[item]["pic"],
                      ),
                      title: new Text(
                        musicinfo[item]["name"],
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Align(
                          child: new Text(musicinfo[item]["artist"]
                            // style: TextStyle(
                            //     color: Colors.white54),
                          ),
                          alignment: FractionalOffset.topLeft),
                      trailing: new Icon(
                        Icons.keyboard_arrow_right,
                        // color: Colors.white,
                      ),
                      onTap: () {

                        print("点击歌曲");
                        print(musicinfo[item]["name"]);
                        Future<dynamic> gelyric() async {
                          print("---------------加载歌词----------------");
                          var value = await controller.lyric(musicinfo[item]["rid"].toString());
                          return value["lyric_str"];
                        }
                        //判断是否是当前歌曲
                        bool skip = false;
                        if (musiccontroller.isCurrentPlayingMusic(
                            MusicCach.simpleMusicGenerateSha1(
                                MusicName: musicinfo[item]["name"],
                                MusicAlbum: musicinfo[item]["album"],
                                MusicSongSour: "kugou",
                                MusicArtists: musicinfo[item]["artist"]))) {
                          skip = true;
                        }
                        if (!skip) {
                          //获取下载地址后在进行跳转
                          controller.SongPlayUrl(musicinfo[item]["rid"]).then((value) => {
                            if (value["code"] == 200)
                              {
                                // musiccontroller.addAudio(value["url"], musicList[index]["name"], musicList[index]["artist"], musicList[index]["album"], musicList[index]["pic"],"酷我").then((auto) => {
                                // ;
                                // controller.lyric(musicList[index]["rid"].toString()).then((value) => {
                                //   MusicCach.lyrics[MusicCach.simpleMusicGenerateSha1(MusicName:musicList[index]["name"],MusicArtists:musicList[index]["artist"],MusicAlbum: musicList[index]["album"],MusicSongSour:"kugou")]=value["lyric_str"]
                                // }),
                                //播放歌曲后再跳转
                                Get.toNamed("/musicplay", arguments: {
                                  "songname": musicinfo[item]["name"],
                                  "imageurl":musicinfo[item]["pic"],
                                  "artist": musicinfo[item]["artist"],
                                  "playurl": value["url"],
                                  "source": "kugou",
                                  "id": musicinfo[item]["rid"],
                                  "album": musicinfo[item]["album"],
                                  "data": musicinfo[item],
                                  "gelyric": gelyric()
                                })
                                //歌词缓存

                                // })
                              }
                            else
                              {OtherUtils.showToast("获取播放地址失败请稍后再试。。。")}
                          });
                        } else {
                          Get.toNamed("/musicplay", arguments: {
                            "songname": musicinfo[item]["name"],
                            "imageurl": musicinfo[item]["pic"],
                            "artist": musicinfo[item]["artist"],
                            "playurl": musiccontroller
                                .assetsAudioPlayer.current.value.audio.audio.path,
                            "source": "kugou",
                            "id": musicinfo[item]["rid"],
                            "album": musicinfo[item]["album"],
                            "data": musicinfo[item],
                            "gelyric": gelyric()
                          });
                        }
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                new Divider(
                  color: Colors.transparent,
                ),
                itemCount: musicinfo.length);

          })
        }
      else
        {OtherUtils.showToast("搜索失败请稍后再试。。"), Get.back()}
    });
  }


}
