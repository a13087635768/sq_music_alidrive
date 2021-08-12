import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sq_music_alidrive/page/default/default_page.dart';
import 'package:sq_music_alidrive/page/drive/drive_page.dart';
import 'package:sq_music_alidrive/page/home/home_page.dart';
import 'package:sq_music_alidrive/page/index/index_page.dart';
import 'package:sq_music_alidrive/page/index/tabs/kuwo/kuwo_search_list_widget.dart';
import 'package:sq_music_alidrive/page/index/tabs/kuwo/kuwo_top_list_widget.dart';
import 'package:sq_music_alidrive/page/login/check_login_page.dart';
import 'package:sq_music_alidrive/page/login/login_page.dart';
import 'package:sq_music_alidrive/page/music/play_music_page.dart';
import 'package:sq_music_alidrive/page/playlist/my_play_list_page.dart';
import 'package:sq_music_alidrive/page/playlist/mylike/list_detail_page.dart';
import 'package:sq_music_alidrive/page/set/set_page.dart';


/// 路由管理
class MainRoute {
  List<GetPage> routes = [
    // new GetPage(name: '/login', page: () => ()),
    new GetPage(name: '/', page: () => DefaultPage()),
    new GetPage(name: '/index', page: () => IndexPage()),
    new GetPage(name: '/home', page: () => HomePage()),
    // new GetPage(name: '/drive', page: () => DrivePage()),
    new GetPage(name: '/myplaylist', page: () => MyPlayListPage()),
    new GetPage(name: '/login', page: () => LoginPage()),
    new GetPage(name: '/musicplay', page: () => PlayMusicPage(),),
    new GetPage(name: '/checklogin', page: () => CheckLoginPage()),
    new GetPage(name: '/kuwosearchlist', page: () => KuwoSearchListWidget()),
    new GetPage(name: '/kuwotopmusiclist' ,page: () => KuwoTopListWidget()),
    new GetPage(name: '/listdetailpage' ,page: () => ListDetailPage()),

    new GetPage(name: '/set', page: () => SetPage()),
    // new GetPage(name: '/musicplaylyric', page: () => MusicPlayLyric()),
  ];

  GetMaterialApp getMaterialApp() {
    DateTime lastPopTime; //上次点击时间

    return GetMaterialApp(
        unknownRoute: routes[6],
        initialRoute: '/',
        getPages:routes,
        routingCallback: (routing)
    {
      // if (routing.current == "/index") {
      //   if (lastPopTime == null ||
      //       DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
      //     //两次点击间隔超过1秒则重新计时
      //     lastPopTime = DateTime.now();
      //     Fluttertoast.showToast(
      //         msg: "再次返回退出",
      //         toastLength: Toast.LENGTH_SHORT,
      //         gravity: ToastGravity.BOTTOM,
      //         timeInSecForIosWeb: 1,
      //         backgroundColor: Colors.black,
      //         textColor: Colors.white,
      //         fontSize: 16.0);
      //     // Toast.show("再次返回退出", context);
      //     return new Future.value(false);
      //   } else {
      //     //判断是否需要缓存上一次的歌曲
      //     return new Future.value(true);
      //   }
      // }
    }
  );
}

}