import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sq_music_alidrive/controller/music/music_play_controller.dart';
import 'package:sq_music_alidrive/page/drive/drive_page.dart';
import 'package:sq_music_alidrive/page/home/home_page.dart';
import 'package:sq_music_alidrive/page/playlist/my_play_list_page.dart';
import 'file:///F:/flutter_git/sq_music_alidrive/sq_music_alidrive/lib/page/index/tabs/kuwo/kuwo_home_widget.dart';
import 'package:sq_music_alidrive/page/set/set_page.dart';
import 'package:sq_music_alidrive/theme/my_colors.dart';
import 'package:get/get.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IndexPage();
}

class _IndexPage extends State<IndexPage> {
  MusicPlayController musiccontroller = Get.find<MusicPlayController>();

  ///页面大小
  Size size;
  var playbox = 0.obs;

  ///底部导航数据
  List<IconData> _iconList = [
    Ionicons.home_outline,
    Ionicons.file_tray_full_outline,
    // Ionicons.musical_notes_outline,
    Ionicons.cog_outline,
    // Icons.code,
  ];
  var homepage = HomePage();
  // var drivepage = DrivePage();
 var myplaylistpage= MyPlayListPage();

  var setpage = SetPage();
  var showplaymusic = false.obs;

  var nowtime = Duration().obs;

  bool ishow = null;

  // var serviceMusicListPage=null;
  // var searchMusicPage=null;
  // var setPage=null;
  List<Widget> _currents;
  TabController _tabController;

  final List<Tab> tabs = <Tab>[
    new Tab(
      child: Text(
        "酷我",
        style: TextStyle(color: Colors.black),
      ),
    ),
    new Tab(
        child: Text(
      "QQ",
      style: TextStyle(color: Colors.black),
    )),
    new Tab(
        child: Text(
      "暂定",
      style: TextStyle(color: Colors.black),
    ))
  ];

  ///导航选择的当前对象
  int _NavIndex = 0;
  String selectedValueSingleDialog = "";
  List<DropdownMenuItem> items = [];
  var tabbar ;



  int appbarlength =0;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    // final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return MaterialApp(
      debugShowCheckedModeBanner: true,
      builder: EasyLoading.init(),
      home: DoubleBack(
        message: "再次返回后退出",
        child: DefaultTabController(
          length: appbarlength,
          child: Scaffold(
            backgroundColor: MyColors.MainBackgroundColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(size.height * 0.07),
              child: tabbar,
            ),
            body: Container(
              // height: size.height*0.9,
              child: Column(
                children: [
                  _currents[_NavIndex]
                  ,
                  StreamBuilder(
                      stream: musiccontroller.assetsAudioPlayer.isPlaying,
                      builder: (context, snapshot) {
                        bool isPlaying = snapshot.data;

                        ishow = true;

                        try {
                          return isPlaying || ishow
                              ? Expanded(
                                  flex: 1,
                                  child: Container(
                                      width: size.width,
                                      // color: Colors.redAccent,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //图片增加点击事件
                                          InkWell(
                                            child: Container(
                                              width: size.width * 0.15,
                                              // color: Colors.red,
                                              child: CachedNetworkImage(
                                                width: size.width,
                                                fit: BoxFit.fitHeight,
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                imageUrl: musiccontroller
                                                    .assetsAudioPlayer
                                                    .current
                                                    .value
                                                    .audio
                                                    .audio
                                                    .metas
                                                    .image
                                                    .path,
                                              ),
                                            ),
                                            onTap: () {
                                              //进图歌曲页面
                                              Get.toNamed("/musicplay",
                                                  arguments: null);

                                              // print("进入歌曲");
                                            },
                                          ),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: InkWell(
                                              child: Container(
                                                // color: Colors.blue,
                                                width:size.width*0.4,
                                                child: Text(musiccontroller
                                                        .assetsAudioPlayer
                                                        .current
                                                        .value
                                                        .audio
                                                        .audio
                                                        .metas
                                                        .title +
                                                    " - " +
                                                    musiccontroller
                                                        .assetsAudioPlayer
                                                        .current
                                                        .value
                                                        .audio
                                                        .audio
                                                        .metas
                                                        .artist,style: TextStyle(fontSize: size.height*0.015),),
                                              ),
                                              onTap: () {
                                                //进图歌曲页面
                                                Get.toNamed("/musicplay",
                                                    arguments: null);

                                                // print("进入歌曲");
                                              },
                                            ),
                                          ),
                                          //播放时长
                                          InkWell(
                                            child: Container(
                                              // width:size.width*0.2,

                                              child: Row(
                                                children: [
                                                  //正在播放的时长
                                                  Obx(() => Container(
                                                        child: Text(
                                                            "${musiccontroller.MuisicDurationtoString(nowtime.value)}/${musiccontroller.MuisicDurationtoString(musiccontroller.assetsAudioPlayer.current.value.audio.duration)}"),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            onTap: () {
                                              //进图歌曲页面
                                              Get.toNamed("/musicplay",
                                                  arguments: null);

                                              // print("进入歌曲");
                                            },
                                          ),

                                          Container(
                                            // width:size.width*0.2,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: isPlaying
                                                      ? Icon(LineIcons.pause)
                                                      : Icon(LineIcons.play),
                                                  onPressed: () {
                                                    print("点击了播放");
                                                    if (isPlaying) {
                                                      musiccontroller
                                                          .assetsAudioPlayer
                                                          .pause();
                                                    } else {
                                                      musiccontroller
                                                          .assetsAudioPlayer
                                                          .play();
                                                    }
                                                  },
                                                ),
                                                // SizedBox(
                                                //   width: size.width*0.04,
                                                // ),
                                                // IconButton(
                                                //   icon: Icon(LineIcons.list),
                                                //   onPressed: () {
                                                //     //todo 稍后再做
                                                //     print("点击了歌曲列表");
                                                //   },
                                                // ),
                                              ],
                                            ),
                                          ),

                                          //歌曲名称-歌手
                                          //歌曲操作 （暂停播放等）
                                        ],
                                      )),
                                )
                              : Container();
                        } catch (e) {
                          return Container();
                        }
                      })
                ],
              ),
            ),
            bottomNavigationBar: AnimatedBottomNavigationBar(
              backgroundColor: MyColors.MainBackgroundColor,
              icons: _iconList,
              activeIndex: _NavIndex,
              gapLocation: GapLocation.none,
              notchSmoothness: NotchSmoothness.smoothEdge,
              // notchSmoothness: NotchSmoothness.defaultEdge,
              leftCornerRadius: 0,
              rightCornerRadius: 0,
              // backgroundColor: Colors.purple[200],
              // activeColor: Colors.purple[400],
              onTap: (index) {

                if(index==0){
                  setState(() {
                    appbarlength=tabs.length;
                    tabbar =
                        AppBar(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          // leading: new IconButton(
                          //   icon: new Icon(Icons.arrow_back, color: Colors.black),
                          //   onPressed: () => Navigator.of(context).pop(),
                          // ),
                          bottom: new TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BubbleTabIndicator(
                              // indicatorHeight: 25.0,
                              indicatorColor: Colors.blueAccent,
                              tabBarIndicatorSize: TabBarIndicatorSize.tab,
                              // Other flags
                              // indicatorRadius: 1,
                              // insets: EdgeInsets.all(1),
                              // padding: EdgeInsets.all(10)
                            ),
                            tabs: tabs,
                            // controller: _t   abController,
                          ),
                        );
                  });

                }else{
                  setState(() {
                    tabbar=AppBar(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        title: Text("其他页面"),
                    );
                  });
                }
                setState(() {
                    _NavIndex =index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    //获取正在播放歌曲的时长
    musiccontroller.assetsAudioPlayer.currentPosition.listen((event) {
      nowtime.value = event;
    });

    setState(() {
      appbarlength =tabs.length;
      tabbar =
          AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            // leading: new IconButton(
            //   icon: new Icon(Icons.arrow_back, color: Colors.black),
            //   onPressed: () => Navigator.of(context).pop(),
            // ),
            bottom: new TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BubbleTabIndicator(
                // indicatorHeight: 25.0,
                indicatorColor: Colors.blueAccent,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
                // Other flags
                // indicatorRadius: 1,
                // insets: EdgeInsets.all(1),
                // padding: EdgeInsets.all(10)
              ),
              tabs: tabs,
              // controller: _t   abController,
            ),
          );
    });

    //判断是否有歌曲正在播放
    // showplaymusic.value= musiccontroller.assetsAudioPlayer.isPlaying.value;

    //打开数据库
    //  DbServices.openDB();
    _currents = [
      Container(
        child: Expanded(
          flex: 11,
          child: TabBarView(
            children: [
              Container(child: KuWoHomeWidget()),
              SafeArea(child: Text("2")),
              SafeArea(child: Text("3")),
              // SafeArea(
              //     // child: Text("4")
              // ),
            ],
          ),
        ),
      ),
      // homepage,
      Container(
        child: Expanded(
          flex: 11,
          child: myplaylistpage,
        ),
      ),
      setpage,
    ];
  }
}
