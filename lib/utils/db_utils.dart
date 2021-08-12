import 'dart:io';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class DBUtil {


///稍后做为全局的缓存，缓存部分数据库减少APP打开速度
  /// 实例
  static DBUtil instance;

  /// 用户信息
  Box userinfo;
  // //baseinfo
  // Box baseinfo;
  //
  // Box baseurl;
  //播放列表
  Box playList;
  // //全局设置
  // Box setinfo;
  //播放列表
  Box cache;

  /// 初始化，需要在 main.dart 调用
  /// <https://docs.hivedb.dev/>
  static Future<void> install() async {
    /// 初始化保存地址
    Directory document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);

    /// 注册自定义对象（实体）
    /// <https://docs.hivedb.dev/#/custom-objects/type_adapters>
    /// Hive.registerAdapter(SettingsAdapter());
  }

  /// 初始化 Box
  static Future<DBUtil> getInstance() async {
    if (instance == null) {
      instance = DBUtil();
      await Hive.initFlutter();
      /// 标签
      instance.userinfo = await Hive.openBox('userinfo');
      // instance.baseinfo = await Hive.openBox('baseinfo');
      // instance.baseurl = await Hive.openBox('baseurl');
      instance.playList = await Hive.openBox('playList');
      // //全局设置
      // instance.setinfo = await Hive.openBox('setinfo');
      // //缓存
      instance.cache = await Hive.openBox('cache');

      // instance.baseurl.put("LoginURL", "/user/login");
      // instance.baseurl.put("PlayListURL", "/playlist/list_by_page");
      // instance.baseurl.put("MuiscListURL", "/playlist/muiscByPlayid");
      // instance.baseurl.put("MuiscPlayerURL", "/music/playMusic");
      // instance.baseurl.put("VerifyToken", "/user/verifyToken");
      // instance.baseurl.put("AllMusic", "/music/get_list_by_page");
      // instance.baseurl.put("Checkingserver", "/set/checkingServer");
      // instance.baseurl.put("DownloadMusic", "/music/downloadMusic");
      // instance.baseurl.put("NetMusicSearch", "/music/musicsearch");
      // instance.baseurl.put("NetDownloadLocal", "/music/downloadLocal");
      // //我的歌单
      // instance.baseurl.put("PlaylistSave", "/playlist/save");
      // // instance.baseurl.put("PlaylistSave", "/playlist/save");
      // //设置
      // instance.baseurl.put("setListURL", "/set/list_by_page");



    }
    return instance;
  }
}