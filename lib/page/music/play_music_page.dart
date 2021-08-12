import 'dart:collection';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/radio/gf_radio.dart';
import 'package:getwidget/getwidget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sq_music_alidrive/controller/home/tabs/kuwo_controller/kuwo_controller.dart';
import 'package:sq_music_alidrive/controller/music/music_play_controller.dart';
import 'package:sq_music_alidrive/db/dbService.dart';
import 'package:sq_music_alidrive/lyric/lyric_controller.dart';
import 'package:sq_music_alidrive/lyric/lyric_util.dart';
import 'package:sq_music_alidrive/lyric/lyric_widget.dart';
import 'package:sq_music_alidrive/page/music/widge/music_play_Image_widge.dart';
import 'package:sq_music_alidrive/theme/my_colors.dart';
import 'package:sq_music_alidrive/utils/db_utils.dart';
import 'package:sq_music_alidrive/utils/music_cach.dart';
import 'package:sq_music_alidrive/utils/other_utils.dart';
import 'dart:convert';


class PlayMusicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayMusicPage();
}

class _PlayMusicPage extends State<StatefulWidget>
    with TickerProviderStateMixin {
  Size size;

  //歌曲信息
  // var musicinfo;
  Map  playinfo;
  var songname = "".obs;
  var artist = "".obs;
  var imageurl = "".obs;
  var playurl = "".obs;
  var album = "".obs;
  var audiopath = "".obs;
  var source = "".obs;
  String Lyricvalue = "[00:00.00]暂无歌词\r\n";
  var audioDuration = Duration(seconds: 0).obs;
  var isLike = false.obs;
var playListWidgetsetState;
  //歌词是不是加载完成了
  bool gelyricover = false;

  //歌曲播放时长
  var nowtime = new Duration().obs;
  Future<dynamic> ff = null;

//  歌曲播放模式
  int loopicon;

  //是显示歌词还是图片(默认显示图片)
  bool isshowimage = true;

  //是否加载页面（等歌曲信息初始化完成后在进行展示）
  bool isshow = false;

  MusicPlayController controller = Get.find<MusicPlayController>();
  KuwoController kugwocontroller = Get.find<KuwoController>();
  LyricController _lyricController = null;

  // Widget lyrcWidget = null;

  //歌词是否选择
  bool showSelect = false;

  Color maincolor = MyColors.MainBackgroundColor;

  // Colors.red
  int groupValue = 0;
  Icon isLikeIcon = Icon(LineIcons.heart);
  var allPlayListData;
  List<Widget> playListWidget = [];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery
        .of(context)
        .size;
    return !isshow
        ? Container()
        : Scaffold(
        backgroundColor: MyColors.MainBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          // foregroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       // IconButton(
        //       //   icon: Icon(
        //       //     Icons.keyboard_arrow_down,
        //       //     size: 40,
        //       //     // color: Colors.black,
        //       //   ),
        //       //   onPressed: () => {Navigator.pop(context)},
        //       // ),
        //     ],
        //   ),
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        // ),
        body: Container(
          // bgColor: maincolor,
          // blur: 10,
          child: Column(
            children: [
              Container(
                width: size.width,
                height: size.height * 0.48,
                color: Colors.transparent,
                child: InkWell(
                  child: IndexedStack(
                    children: <Widget>[
                      Obx(() => MusicPlayImageWidge(imageurl.value)),
                      Container(
                        child: Center(
                            child: LyricWidget(
                              lyricStyle: TextStyle(
                                color: Colors.yellow[100],
                                fontSize: 15,
                              ),
                              currLyricStyle: TextStyle(
                                  color: Colors.redAccent[100], fontSize: 20),
                              // remarkStyle: TextStyle(color: Colors.red,fontSize: 20),
                              controller: _lyricController,
                              size: Size(size.width, size.height * 0.48),
                              lyrics: LyricUtil.formatLyric(Lyricvalue),
                              // currentProgress: nowtime
                              //     .value.inMilliseconds
                              //     .toDouble(),
                            )),
                      ),
                    ],
                    index: isshowimage ? 0 : 1,
                  ),

                  //
                  // isshowimage
                  //     ? Obx(() => )
                  //     :lyrcWidget,
                  onTap: () {
                    if (Lyricvalue != null) {
                      setState(() {
                        isshowimage = !isshowimage;
                      });
                    } else {
                      OtherUtils.showToast("正在加载歌词请稍等。。。");
                    }
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              Container(
                width: size.width,
                // height: size.height * 0.5,
                color: Colors.transparent,
                child: Column(
                  children: [
                    Obx(() =>
                        Text(
                          songname.value,
                          // "音乐名称",
                          style: TextStyle(fontSize: 25),
                        )),
                    Obx(() =>
                        Text(
                          artist.value,
                          // "歌手名称",
                          style: TextStyle(fontSize: 25),
                        )),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    IconButton(
                      iconSize: size.height * 0.05,
                      icon: isLikeIcon,
                      onPressed: () {
                        var suffix ;
                        if(playinfo["isdrive"]!=null&&playinfo["isdrive"]){
                          suffix =playinfo["suffix"];
                        }else{
                          var lastIndexOf = playurl.value.lastIndexOf(".");
                          suffix = playurl.substring(
                              lastIndexOf, playurl.value.length);
                        }
                        if (isLike.value == true) {
                          DbServices.dellikeMuisc(controller
                              .assetsAudioPlayer
                              .current
                              .value
                              .audio
                              .audio
                              .metas
                              .id.split(",")[0])
                              .then((value) =>
                          {
                            if (value)
                              {
                                setState(() {
                                  isLikeIcon =
                                      Icon(LineIcons.heart);
                                }),
                                isLike.value = false
                              }
                            else
                              {OtherUtils.showToast("稍后再试。。")}
                          });
                        } else {
                          //不是喜欢的歌曲

                          if (!gelyricover) {
                            OtherUtils.showToast("等会呀,歌词还没加载完成呢！");
                          } else {
                            DbServices.addlikeMuisc(
                                MusicArtists: controller
                                    .assetsAudioPlayer
                                    .current
                                    .value
                                    .audio
                                    .audio
                                    .metas
                                    .artist,
                                MusicSongSour: controller
                                    .assetsAudioPlayer
                                    .current
                                    .value
                                    .audio
                                    .audio
                                    .metas
                                    .id.split(",")[1],
                                MusicAlbum: controller
                                    .assetsAudioPlayer
                                    .current
                                    .value
                                    .audio
                                    .audio
                                    .metas
                                    .album,
                                MusicName: controller
                                    .assetsAudioPlayer
                                    .current
                                    .value
                                    .audio
                                    .audio
                                    .metas
                                    .title,
                                MusicPath:
                                playinfo["isdrive"]!=null?playinfo["playurl"]:controller.assetsAudioPlayer
                                    .current.value.audio.audio.path,
                                MusicLyricPath: Lyricvalue,
                                MusicSourImageUrl: controller
                                    .assetsAudioPlayer
                                    .current
                                    .value
                                    .audio
                                    .audio
                                    .metas
                                    .image
                                    .path,
                                MusicLyricvalue: Lyricvalue,
                                MusicBr: 320,
                                MusicCodeType: suffix,
                                MusicImagePath: controller
                                    .assetsAudioPlayer
                                    .current
                                    .value
                                    .audio
                                    .audio
                                    .metas
                                    .image
                                    .path,
                                MusicLyricTrans: 'NULL',
                                isdrive:playinfo["isdrive"]!=null?playinfo["isdrive"]:false
                            )
                                .then((value) =>
                            {
                              if (value)
                                {
                                  setState(() {
                                    isLikeIcon = Icon(
                                      LineIcons.heart,
                                      color: Colors.red,
                                    );
                                  }),
                                  isLike.value = true
                                }
                              else
                                {OtherUtils.showToast("请稍后再试")}
                            });
                          }
                        }
                      },
                    ),
                    IconButton(
                        iconSize: size.height * 0.05,
                        icon: loopicon == 0
                            ? Icon(
                          LineIcons.random,
                        )
                            : loopicon == 1
                            ? Icon(Icons.repeat_one)
                            : Icon(LineIcons.alternateRedo),
                        onPressed: () {
                          // print(loopicon);
                          loopicon++;
                          setState(() {
                            loopicon = loopicon % 3;
                          });

                          controller.assetsAudioPlayer
                              .setLoopMode(LoopMode.values[loopicon]);
                          OtherUtils.showToast(loopicon == 0
                              ? "随机播放"
                              : loopicon == 1
                              ? "单曲循环"
                              : "列表循环");
                        }),
                    IconButton(
                        icon: new Icon(LineIcons.audioFileAlt),
                        iconSize: size.height * 0.05,
                        onPressed: () async {
                          //todo 增加缓存数据
                          Alert(
                              context: context,
                              title: "添加至歌单",
                              content: StatefulBuilder(
                                  builder: (context, wpsetState) {
                                    playListWidget=[];
                                    for(int i = 0; i < allPlayListData.length; i++){
                                      wpsetState(() {
                                        playListWidget.add(
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(allPlayListData[i]["playName"]),
                                                GFRadio(
                                                  size: GFSize.MEDIUM,
                                                  activeBorderColor: GFColors.SUCCESS,
                                                  value: i,
                                                  groupValue: groupValue,
                                                  onChanged: (value) {
                                                    print(groupValue);
                                                    wpsetState(() {
                                                      groupValue = value;
                                                    });
                                                  },
                                                  inactiveIcon: null,
                                                  radioColor: GFColors.SUCCESS,
                                                ),
                                              ],
                                            )
                                        );
                                      });
                                    };
                                    return Column(
                                      children: playListWidget,
                                    );
                                  }
                              ),
                              buttons: [
                                DialogButton(
                                  onPressed: () => Get.back(),
                                  child: Text(
                                    "取消",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                DialogButton(
                                  onPressed: () {
                                    // 选择完成开始添加
                                    // 添加到歌单
                                    Get.back();
                                    var lastIndexOf = playurl.value.lastIndexOf(
                                        ".");
                                    var suffix = playurl.substring(
                                        lastIndexOf, playurl.value.length);
                                    DbServices.addMusic(
                                        MusicArtists: controller
                                            .assetsAudioPlayer
                                            .current
                                            .value
                                            .audio
                                            .audio
                                            .metas
                                            .artist,
                                        MusicSongSour: controller
                                            .assetsAudioPlayer
                                            .current
                                            .value
                                            .audio
                                            .audio
                                            .metas
                                            .id.split(",")[1],
                                        MusicAlbum: controller
                                            .assetsAudioPlayer
                                            .current
                                            .value
                                            .audio
                                            .audio
                                            .metas
                                            .album,
                                        MusicName: controller
                                            .assetsAudioPlayer
                                            .current
                                            .value
                                            .audio
                                            .audio
                                            .metas
                                            .title,
                                        MusicPath: controller.assetsAudioPlayer
                                            .current.value.audio.audio.path,
                                        MusicLyricPath: Lyricvalue,
                                        MusicSourImageUrl: controller
                                            .assetsAudioPlayer
                                            .current
                                            .value
                                            .audio
                                            .audio
                                            .metas
                                            .image
                                            .path,
                                        MusicLyricvalue: Lyricvalue,
                                        MusicSongId:controller
                                            .assetsAudioPlayer
                                            .current
                                            .value
                                            .audio
                                            .audio
                                            .metas
                                            .id.split(",")[2],
                                        ///todo 码率
                                        MusicBr: 1000,
                                        MusicCodeType: suffix,
                                        MusicImagePath: controller
                                            .assetsAudioPlayer
                                            .current
                                            .value
                                            .audio
                                            .audio
                                            .metas
                                            .image
                                            .path,
                                        MusicLyricTrans: 'NULL').then((value) =>
                                    {
                                      if(value == 0){
                                        //添加成功
                                        DbServices.addMusicToPlayList(controller
                                            .assetsAudioPlayer
                                            .current
                                            .value
                                            .audio
                                            .audio
                                            .metas
                                            .id.split(",")[0],
                                            allPlayListData[groupValue]["UUID"])
                                            .then((value) {
                                          OtherUtils.showToast("添加成功");
                                        })
                                      } else
                                        {
                                          OtherUtils.showToast("添加失败！")
                                        }
                                    });
                                  },
                                  child: Text(
                                    "确定",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )
                              ]).show();

                          //展示


                        }

                    ),

                    IconButton(
                      icon: Icon(LineIcons.alternateListAlt),
                      iconSize: size.height * 0.06,
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                            context: context,
                            expand: false,
                            backgroundColor: MyColors.MainBackgroundColor,
                            builder: (context) =>
                                BlurryContainer(
                                  // bgColor: ,
                                    width: size.width * 0.8,
                                    blur: 0,
                                    child: ListView.separated(
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
                                              backgroundColor:
                                              Colors.transparent,
                                              leading: CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                imageUrl: controller
                                                    .assetsAudioPlayer
                                                    .playlist
                                                    .audios[item]
                                                    .metas
                                                    .image
                                                    .path,
                                              ),

                                              // ImageUtils.Base64toImage(_records[item]['musicImage']),
                                              title: new Text(
                                                controller
                                                    .assetsAudioPlayer
                                                    .playlist
                                                    .audios[item]
                                                    .metas
                                                    .title,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                              subtitle: Align(
                                                  child: new Text(
                                                    controller
                                                        .assetsAudioPlayer
                                                        .playlist
                                                        .audios[item]
                                                        .metas
                                                        .artist,
                                                    // style: TextStyle(
                                                    //     color: Colors.white54),
                                                  ),
                                                  alignment:
                                                  FractionalOffset.topLeft),
                                              trailing: new Icon(
                                                Icons.keyboard_arrow_right,
                                                // color: Colors.white,
                                              ),
                                              onTap: () {
                                                controller.assetsAudioPlayer
                                                    .playlistPlayAtIndex(item)
                                                    .then((value) =>
                                                {
                                                  setState(() {
                                                    songname.value =
                                                        controller
                                                            .assetsAudioPlayer
                                                            .current
                                                            .value
                                                            .audio
                                                            .audio
                                                            .metas
                                                            .title;
                                                    artist.value =
                                                        controller
                                                            .assetsAudioPlayer
                                                            .current
                                                            .value
                                                            .audio
                                                            .audio
                                                            .metas
                                                            .artist;
                                                    imageurl.value =
                                                        controller
                                                            .assetsAudioPlayer
                                                            .current
                                                            .value
                                                            .audio
                                                            .audio
                                                            .metas
                                                            .image
                                                            .path;
                                                    // controller.lyric.value = MusicCach.lyrics[OtherUtils.generateMd5(controller.assetsAudioPlayer.current.valueWrapper.value.audio.audio.path)];
                                                    // controller.trans.value = MusicCach.trans[OtherUtils.generateMd5(controller.assetsAudioPlayer.current.valueWrapper.value.audio.audio.path)];
                                                    audiopath.value =
                                                        controller
                                                            .assetsAudioPlayer
                                                            .current
                                                            .value
                                                            .audio
                                                            .audio
                                                            .path;
                                                  })
                                                });
                                                Get.back();
                                                // playInfo.addAudio(_records[item], false);
                                              },
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                        new Divider(
                                          color: Colors.transparent,
                                        ),
                                        itemCount: controller.assetsAudioPlayer
                                            .playlist.audios.length)));
                      },
                    ),
                    SizedBox(),
                  ],
                ),
              ),
              Container(
                // margin: EdgeInsets.only(top: size.height * 0.07),
                width: size.width,
                // height: size.height * 0.25,
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width * 0.1,
                          child: Obx(() =>
                              Text(
                                controller.MuisicDurationtoString(
                                    nowtime.value),
                                // style: TextStyle(color: Colors.red),
                              )),
                          // child: StreamBuilder<Duration>(
                          //   stream: controller.assetsAudioPlayer.currentPosition,
                          //   builder: (context, values){
                          //     return  Text(
                          //       controller.MuisicDurationtoString(values.data),
                          //       style: TextStyle(color: Colors.red),
                          //     );
                          //   },
                          // ),
                        ),

                        Container(
                          width: size.width * 0.7,
                          child: Obx(() =>
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  valueIndicatorTextStyle: TextStyle(
                                    // color:Colors.red,
                                  ),
                                ),
                                child: Slider(
                                  // label: '${muisicDurationtoString}',
                                  //   label: '$_sliderValue',
                                    max: audioDuration.value.inMicroseconds
                                        .toDouble(),
                                    min: 0.0,
                                    // divisions: 100,
                                    activeColor: Colors.purple,
                                    // inactiveColor: Colors.yellow,
                                    value: nowtime.value.inMicroseconds
                                        .toDouble(),
                                    onChanged: (double v) {
                                      nowtime.value = new Duration(
                                          microseconds: v.toInt());
                                      // controller.MuisicDurationtoString()
                                      // setState(() {
                                      //   this._sliderValue = v;
                                      // });
                                    },
                                    onChangeStart: (double startValue) {
                                      print(
                                          'Started change at $startValue');
                                    },
                                    onChangeEnd: (double newValue) {
                                      controller.seek(Duration(
                                          microseconds: newValue.toInt()));
                                      print('Ended change on $newValue');
                                    },
                                    semanticFormatterCallback:
                                        (double newValue) {
                                      return '${newValue.round()} dollars';
                                    }),
                              )),

                          // StreamBuilder<Duration>(
                          //   stream: controller.assetsAudioPlayer.currentPosition,
                          //
                          //   builder: (context, value){
                          //     //当前时间
                          //    var  tempduration=value.data.inMicroseconds.toDouble();
                          //
                          //     _sliderValue=value.data.inMicroseconds.toDouble();
                          //     // setState(() {
                          //     //   muisicDurationtoString=controller.MuisicDurationtoString(value.data);
                          //     // });
                          //
                          //     return Slider(
                          //         // label: '${muisicDurationtoString}',
                          //         label: '${this._sliderValue.round()}',
                          //         max: controller.assetsAudioPlayer.current
                          //             .value.audio.duration.inMicroseconds
                          //             .toDouble(),
                          //         min: 0.0,
                          //         // divisions: 1,
                          //         activeColor: Colors.purple,
                          //         // inactiveColor: Colors.yellow,
                          //         value: nowtime.value.inMicroseconds.toDouble(),
                          //         onChanged: (double v) {
                          //           setState(() {
                          //             _sliderValue =v;
                          //           });
                          //         },
                          //         onChangeStart: (double startValue) {
                          //           print('Started change at $startValue');
                          //         },
                          //         onChangeEnd: (double newValue) {
                          //           controller.seek(Duration(
                          //               microseconds: newValue.toInt()));
                          //           print('Ended change on $newValue');
                          //         },
                          //         semanticFormatterCallback:
                          //             (double newValue) {
                          //           return '${newValue.round()} dollars';
                          //         });
                          //
                          //
                          //   },
                          // ),
                        ),
                        // Container(
                        //   width: size.width * 0.8,
                        //
                        //   child: ,
                        // ),
                        Container(
                          width: size.width * 0.1,
                          child: Obx(
                                () =>
                                Text(controller.MuisicDurationtoString(
                                    audioDuration.value)),
                            // style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 20,
                        ),

                        //     <span class="material-icons">
                        // restart_alt
                        // </span>
                        //           IconButton(icon: Icon(Icons.repeat), onPressed: (){
                        //
                        //           }),

                        // IconButton(icon: Icon(Icons.repeat), onPressed: (){
                        //
                        // }),
                        // IconButton(icon: Icon(Icons.shuffle), onPressed: (){
                        //
                        // }),

                        IconButton(
                            icon: Icon(
                              LineIcons.stepBackward,
                              // color: Colors.white,
                            ),
                            iconSize: size.height * 0.05,
                            onPressed: () {
                              controller.assetsAudioPlayer.previous();
                              // controller.assetsAudioPlayer.playlist.audios.p
                            }),
                        StreamBuilder(
                          stream: controller.assetsAudioPlayer.isPlaying,
                          builder: (context, asyncSnapshot) {
                            final bool isPlaying = asyncSnapshot.data;
                            return IconButton(
                                icon: isPlaying
                                    ? Icon(
                                  LineIcons.pause,
                                  // color: Colors.white,
                                )
                                    : Icon(
                                  LineIcons.play,
                                  // color: Colors.white,
                                ),
                                iconSize: size.height * 0.05,
                                onPressed: () {
                                  controller
                                      .assetsAudioPlayer.isPlaying.value
                                      ? controller.pauseAudio()
                                      : controller.playAudio();
                                });
                          },
                        ),
                        Container(
                          child: IconButton(
                              icon: Icon(LineIcons.stepForward
                                // color: Colors.white,
                              ),
                              iconSize: size.height * 0.05,
                              onPressed: () {
                                controller.assetsAudioPlayer.next();
                              }),
                          // transform: Matrix4.identity()..rotateY(360),
                        ),

                        // IconButton(
                        //   icon: Icon(
                        //     Icons.list,
                        //     color: Colors.white,
                        //   ),
                        //   iconSize: 50,
                        // ),

                        SizedBox(
                          width: 20,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  @override
  void initState() {
    _lyricController = LyricController(vsync: this);
//获取现在有的歌单
    DbServices.myAllPlayList().then((value) =>
    {
      setState(() {
        allPlayListData = value;
      }),


      // for (var PlaytData in allPlayListData ) {
      //   playListWidget.add(value)
      // }


    });



if(Get.arguments==null){
  String jsonString = DBUtil.instance.cache.get("playinfo");
  playinfo = json.decode(jsonString.toString());
}else{
  playinfo = Get.arguments;
  LinkedHashMap map = Get.arguments;
  map.remove("gelyric");
  String jsonString = json.encode(map);
  DBUtil.instance.cache.put("playinfo",jsonString);
}

    //获取数据
      //判断来源
      // musicinfo = Get.arguments;

      setState(() {
        //歌手
        artist.value = playinfo["artist"];
        //歌曲名称
        songname.value = playinfo["songname"];
        //歌曲封面地址
        imageurl.value = playinfo["imageurl"];
        //获取歌曲播放地址
        playurl.value = playinfo["playurl"];
        //专辑
        album.value = playinfo["album"];

        source.value = playinfo["source"];
      });
      //添加歌曲
      controller
          .addAudio(
          playinfo["playurl"],
          playinfo["songname"],
          playinfo["artist"],
          playinfo["album"],
          playinfo["imageurl"],
          playinfo["source"],
          playinfo["id"].toString(),
          isdrive: playinfo["isdrive"]==null?false:playinfo["isdrive"],
          suffix: playinfo["suffix"]==null?"":playinfo["suffix"],
          musuic_size:playinfo["musuic_size"]==null?0:playinfo["musuic_size"]
      )
          .then((value) =>
      {
        //监听歌曲播放信息
        controller.assetsAudioPlayer.current.listen((event) {
          songname.value = event.audio.audio.metas.title;
          artist.value = event.audio.audio.metas.artist;
          imageurl.value = event.audio.audio.metas.image.path;
          playurl.value = event.audio.audio.path;
          audioDuration.value = event.audio.duration;
          audiopath.value = event.audio.audio.path;
          //加载歌词等信息
          WidgetsBinding.instance.addPostFrameCallback((_) => oninit());
        }),

        //监听播放时长（不能进行提取因为是异步的）
        controller.assetsAudioPlayer.currentPosition.listen((event) {
          nowtime.value = event;
          _lyricController.progress = nowtime.value;
          // lyrics = LyricUtil.formatLyric(controller.lyric.value);
        }),
        //显示
        setState(() {
          isshow = true;
        }),

      });

    }

    // else {
    //   // // Lyricvalue=null;
    //   // //没有携带歌曲信息而来的有可能是从正在播放的地方点击而来
    //   // controller.assetsAudioPlayer.current.listen((event) {
    //   //   songname.value = event.audio.audio.metas.title;
    //   //   artist.value = event.audio.audio.metas.artist;
    //   //   imageurl.value = event.audio.audio.metas.image.path;
    //   //   playurl.value = event.audio.audio.path;
    //   //   audioDuration.value = event.audio.duration;
    //   //   //加载歌词等信息
    //   //   WidgetsBinding.instance.addPostFrameCallback((_) => oninit());
    //   //
    //   //   ;
    //   // });
    //   // //监听播放时长
    //   // controller.assetsAudioPlayer.currentPosition.listen((event) {
    //   //   nowtime.value = event;
    //   //   _lyricController.progress = nowtime.value;
    //   //   // lyrics = LyricUtil.formatLyric(controller.lyric.value);
    //   // });
    //   //
    //   // //显示
    //   // setState(() {
    //   //   isshow = true;
    //   // });
    // }


  oninit() async {
    setState(() {});

    //当前歌曲播放模式
    loopicon = controller.assetsAudioPlayer.currentLoopMode.index;
    // RequestUtils.getMasterColor(musicinfo["imageurl"]).then((value) =>
    // {
    //   setState(() {
    //     var colorstr = value.data["color"].toString();
    //     var substring = colorstr.substring(1, colorstr.length);
    //     var s = "0xff" + substring;
    //     Color colorssd = Color(int.parse(s));
    //     maincolor = value.statusCode == 200 ? colorssd : Colors.purple[50];
    //   })
    // });

    //歌词以及是否是喜欢的歌曲
    //数据库查找
    DbServices.musicInfo(
        musicId: MusicCach.simpleMusicGenerateSha1(
            MusicName: songname.value,
            MusicArtists: artist.value,
            MusicAlbum: album.value,
            MusicSongSour: source.value))
        .then((value) =>
    {
      if (value != null)
        {
          //找到了

          if (value["IsLike"] == 1)
            {
              setState(() {
                isLikeIcon = Icon(
                  LineIcons.heart,
                  color: Colors.red,
                );
              }),
              isLike.value = true
            }
          else
            {
              setState(() {
                isLikeIcon = Icon(
                  LineIcons.heart,
                );
              }),
              isLike.value = false
            },

          Lyricvalue = value["MusicLyricvalue"],

          if (Lyricvalue == null ||
              Lyricvalue == 'NULL' ||
              Lyricvalue == 'null')
            {
              ff = playinfo["gelyric"],
              ff.then((value) =>
              {
                //以前没歌词现在有了则更新下
                if (Lyricvalue == 'NULL' || Lyricvalue == 'null')
                  {
                    if (value != "" || value.length > 1)
                      {
                        Lyricvalue = value,
                        //更新歌词
                        DbServices.updateMuiscLyric(
                            controller.assetsAudioPlayer.current
                                .value.audio.audio.metas.id.split(",")[0],
                            Lyricvalue)
                      }
                    else
                      {Lyricvalue = "[00:00.00]暂无歌词\r\n"}
                  }
                else
                  {Lyricvalue = value},

                gelyricover = true,
                print(Lyricvalue)
              })
            }
          else
            {
              gelyricover = true,
            },
        }
      else
        {
          setState(() {
            isLikeIcon = Icon(
              LineIcons.heart,
            );
          }),
          //特殊页面跳转来的
          // if(Get.arguments == null){
            if(controller.assetsAudioPlayer.current
                .value.audio.audio.metas.id.split(",")[1] == "kugou"){
              Get.find<KuwoController>().lyric(
                  controller.assetsAudioPlayer.current
                      .value.audio.audio.metas.id.split(",")[2]).then((value) =>
              {
                Lyricvalue =
                value["lyric_str"] != "" || value["lyric_str"].length > 1
                    ? value["lyric_str"]
                    : "[00:00.00]暂无歌词\r\n",
                gelyricover = true,
              })
            } else
              {
                //todo 其他来源歌曲稍后再研究
              }
          // }
          // else
          //   {
          //     ff = playinfo["gelyric"],
          //     ff.then((value) =>
          //     {
          //       Lyricvalue = (value != "" || value.length > 1)
          //           ? value
          //           : "[00:00.00]暂无歌词\r\n",
          //       // });
          //       gelyricover = true,
          //       print(Lyricvalue)
          //     })
          //   },
        },
    });
  }
}
