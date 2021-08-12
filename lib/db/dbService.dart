import 'dart:async';
import 'dart:io';

import 'package:sq_music_alidrive/alidrive/client.dart';
import 'package:sq_music_alidrive/utils/music_cach.dart';
import 'package:sq_music_alidrive/utils/other_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DbServices {
  //打开数据库
  static String dbPath;

  static Database configdb;

  static Future<bool> openDB() async {
    //查看存在不存在db文件
    var existsSync = new File(dbPath + "/config.db").existsSync();
    if (existsSync) {
      //存在则使用
      configdb = await openDatabase(dbPath + "/config.db", version: 1);
      if (configdb.isOpen) {
        //检查 是否有系统的表
        var ischeckDB = await checkDB();
        if (ischeckDB) {
          return true;
        } else {
          //不存在数据库重新下载
          var existConifDBvalue = await Client.existConifDB();
          if (existConifDBvalue != null) {
            await Client.downloadFile(
                existConifDBvalue['download_url'],
                existConifDBvalue["file_id"],
                existConifDBvalue["size"].toString(),
                dbPath,
                "config.db");
          }
          var isopen = await openDB();
          return isopen;
        }
      } else {
        //受到损坏
        OtherUtils.showToast("config.db文件损坏了请重新上传");
        return false;
      }
    } else {
      //从服务器进行下载
      var existConifDBvalue = await Client.existConifDB();
      if (existConifDBvalue != null) {
        await Client.downloadFile(
            existConifDBvalue['download_url'],
            existConifDBvalue["file_id"],
            existConifDBvalue["size"].toString(),
            dbPath,
            "config.db");
      }
      var isopen = await openDB();
      if (!isopen) {
        OtherUtils.showToast("config.db文件损坏了请重新上传");
      }
      return isopen;
    }
  }

  ///检查数据库正常性
  static Future<bool> checkDB() async {
    int tabcount = 0;
    var tablelist = await configdb.rawQuery(
        "select name from sqlite_master where type='table' order by name");
    for (var table in tablelist) {
      if (table["name"] == "SQ_Music" ||
          table["name"] == "SQ_Play" ||
          table["name"] == "SQ_Set" ||
          table["name"] == "SQ_Play_Music") {
        tabcount++;
      }
    }
    return tabcount == 4 ? true : false;
  }

  ///上传文件
  static uploadDB() {
    Client.existMusicDirectory().then((value) => {
          Client.uploadFile(
              file_path: dbPath + "/config.db",
              parent_file_id: value,
              name: "config.db")
        });
  }

  //数据库中上传到阿里云的文件夹id
  static Future<String> driveMuiscFileId({String MusicSongSour}) async {
    var setName = "system_dive_music_" + MusicSongSour + "_file_id";
    var list = await configdb
        .rawQuery("select * from SQ_Set where setName= '$setName'");
    if (list != null && list.length > 0) {
      return list[0]["setValue"];
    } else {
      String system_dive_music_file_id =
          await Client.existMusicDirectory(MusicSongSour: MusicSongSour);
      var generateSha1 = MusicCach.generateSha1(Uuid().v4().toString());
      await configdb.rawInsert(
          "INSERT INTO SQ_Set VALUES ('$generateSha1', '$setName', '$system_dive_music_file_id', '阿里云上传文件夹ID', 'drive', NULL)");
      return system_dive_music_file_id;
    }
  }

  //上传到阿里云中
  static Future<String> UploadToDrive(
      {String MusicSongSour, String MusicPath, String name}) async {
    //开始上传
    var uploadid = await driveMuiscFileId(MusicSongSour: MusicSongSour);
    var uploadFile = await Client.uploadFile(
        file_path: MusicPath, parent_file_id: uploadid, name: name);

    if (uploadFile.statusCode == 201) {
      //创建成功
      return uploadFile.data["file_id"];
    } else {
      //创建失败
      return null;
    }
  }

  static Future<int> insretSql(String sql) async {
    try {
      return await configdb.rawInsert(sql);
    } catch (e) {
      if (e.toString().contains("UNIQUE constraint failed")) {
        return -1;
      }
    }
  }

  static Future<int> updateSql(String sql) async {
    try {
      return await configdb.rawUpdate(sql);
    } catch (e) {
      return -1;
    }
  }

  ///创建数据库
  // static Future<bool> createDB([bool update=false]) async{
  //   var file = new File(dbPath + "/config.db");
  //   var existsSync = file.existsSync();
  //   print(existsSync?"开始创建数据库---文件--存在":"开始创建数据库---文件--不存在");
  //   if(existsSync){
  //     file.deleteSync();
  //   }
  //
  //   configdb = await openDatabase(dbPath + "/config.db",version: 1,onCreate:(Database db, int version){
  //     db.execute(SQL.SQ_Music_sql);
  //     db.execute(SQL.SQ_Play_sql);
  //     db.execute(SQL.SQ_Set_sql);
  //     db.execute(SQL.SQ_Play_Music_sql);
  //     db.execute(SQL.insert_sql);
  //   });
  //   if(update){
  //     //上传
  //     uploadDB();
  //
  //   }else{
  //     //不上传(暂时不做本地模式)
  //   }
  //
  // }
  ///-----------------数据库表操作------------------------
  ///添加歌曲
  ///[forceadd] 是否强制添加歌曲（有重复歌曲）
  ///[MusicPath] 手机文件路径
  ///
  ///
  /// EERROR CODE
  /// 0 ：成功
  /// 1 ：上传失败
  /// 2 : 已存在该数据
  /// 3 ：数据库添加失败
  /// 4 ：数据库添加成功上传失败
  /// 4 ：数据库添加成功上传失败
  static Future<int> addMusic(
      {bool forceadd = false,
      String MusicName,
      String MusicArtists,
      String MusicAlbum,
      String MusicLyricPath,
      String MusicPath,
      String MusicImagePath,
      String MusicCodeType,
      String MusicLyricTrans,
      String MusicSourImageUrl,
      String MusicSongSour,
      String MusicLyricvalue,
      String MusicSongId,
      int MusicBr,
      bool UploadDrive = true,
      bool isdrive = false}) async {
    String convert;
    String file_id = 'NULL';
    if (forceadd) {
      convert = MusicCach.generateSha1(Uuid().v4().toString());
    } else {
      convert = MusicCach.simpleMusicGenerateSha1(
          MusicName: MusicName,
          MusicArtists: MusicArtists,
          MusicAlbum: MusicAlbum,
          MusicSongSour: MusicSongSour);
    }
    //检查歌曲唯一性
    var info = await musicInfo(musicId: convert);
    //有则不下载 无则下载歌曲
    var suffix;
    if (isdrive) {
      suffix = MusicCodeType;
    } else {
      var lastIndexOf = MusicPath.lastIndexOf(".");
      suffix = MusicPath.substring(lastIndexOf, MusicPath.length);
    }

    var searcachfile = await MusicCach.searcachfile(convert + suffix);
    if (searcachfile != null) {
      MusicPath = searcachfile.path;
    } else {
      if (isdrive) {
        var downloadUrl = await Client.getDownloadUrl(MusicPath);
        var temp = await Client.downloadFile(
            downloadUrl.data["url"],
            downloadUrl.data["size"].toString(),
            MusicPath,
            MusicCach.directory.path,
            convert + MusicCodeType);
        print(temp);
      } else {
        MusicPath = await MusicCach.cachfile(MusicPath, convert + suffix);
      }
    }

    //存在歌曲
    if (info != null) {
      //发现歌曲  查看歌曲是否符合标准
      if (info["UploadDrive"] == 0 && UploadDrive) {
        //需要上传 并且修改数据库上传状态
        var uploadToDrive = await UploadToDrive(
            MusicSongSour: MusicSongSour,
            MusicPath: MusicPath,
            name: "$MusicName-$MusicArtists$MusicCodeType");
        if (uploadToDrive == null) {
          return 1;
        } else {
          //修改数据库上传状
          var i = await updateSql('''
          UPDATE SQ_Music SET UploadDrive=1,MusicPath =$uploadToDrive WHERE UUID ='$convert'
          ''');
          if (i > 0) {
            return 0;
          } else {
            return 3;
          }
        }
      } else {
        //不需要上传
        //直接返回成功
        return 0;
      }
    } else {
      //不存在
      int upload = 1;
      if (UploadDrive) {
        //上传
        var uploadToDrive = await UploadToDrive(
            MusicSongSour: MusicSongSour,
            MusicPath: MusicPath,
            name: "$MusicName-$MusicArtists$MusicCodeType");
        file_id = uploadToDrive;
        //上传失败
        if (uploadToDrive == null) {
          upload = 0;
        }
      }
      int checkFileSize = MusicCach.checkFileSize(MusicPath);
      var millisecondsSinceEpoch = new DateTime.now().millisecondsSinceEpoch;
      String execSql = '''
              INSERT INTO "SQ_Music" VALUES ('$convert', '$MusicName', '$MusicArtists', '$MusicAlbum', '$MusicLyricPath', '$file_id', '$MusicImagePath', $millisecondsSinceEpoch, NULL, '手机上传', '$MusicCodeType', '$MusicLyricTrans', '$MusicSourImageUrl', '$MusicSongSour', '$MusicLyricvalue', $MusicBr , $upload, 0, '$MusicSongId',$checkFileSize)
          ''';
      int isexecsql = await insretSql(execSql);
      if (isexecsql != -1) {
        if (UploadDrive && upload == 0) {
          return 4;
        }
        return 0;
      } else {
        return 3;
      }
    }
  }

  ///删除歌曲
  static Future<String> delMusic(bool deldrive, String uuid) async {
//删除云端的
    var rawQuery =
        await configdb.rawQuery("select * from SQ_Music where UUID='$uuid'");
    // print(i);
    if (deldrive) {
      String fileid = rawQuery[0]["MusicPath"];
      Client.delFile(fileid);
    }
    await configdb.rawDelete("delete FROM  SQ_Music where UUID='$uuid'");
    return "OK";
  }

  ///歌曲列表
  static Musiclist({int size, int number, String orderby = "MusicTime"}) async {
    String imit = size.toString();
    String offset = (size * (number - 1)).toString();
    var list = await configdb.rawQuery(
        "select * from SQ_Music order by $orderby limit  $imit  offset $offset");
    print(list);
  }

  //歌曲信息
  static Future<Map<String, Object>> musicInfo({String musicId}) async {
    var list =
        await configdb.rawQuery("select * from SQ_Music where UUID='$musicId'");
    if (list.length > 0) {
      return list[0];
    }
    return null;
  }

  //删除喜欢
  static Future<bool> updateMuiscLyric(String musicid, String Lyric) async {
    var i = await updateSql('''
          UPDATE SQ_Music SET MusicLyricvalue='$Lyric',MusicLyricPath='$Lyric' WHERE UUID ='$musicid'
          ''');
    if (i > 0) {
      return true;
    } else {
      return false;
    }
  }

  //删除喜欢
  static Future<bool> dellikeMuisc(String musicid) async {
    var i = await updateSql('''
          UPDATE SQ_Music SET IsLike=0 WHERE UUID ='$musicid'
          ''');
    if (i > 0) {
      return true;
    } else {
      return false;
    }
  }

  //添加歌曲为喜欢
  static Future<bool> addlikeMuisc({
    String MusicName,
    String MusicArtists,
    String MusicAlbum,
    String MusicLyricPath,
    String MusicPath,
    String MusicImagePath,
    String MusicCodeType,
    String MusicLyricTrans,
    String MusicSourImageUrl,
    String MusicSongSour,
    String MusicLyricvalue,
    String MusicSongId,
    int MusicBr,
    bool UploadDrive = true,
    bool isdrive = false,
  }) async {
    print(isdrive);
    var i = await addMusic(
        MusicName: MusicName,
        MusicArtists: MusicArtists,
        MusicAlbum: MusicAlbum,
        MusicLyricPath: MusicLyricPath,
        MusicPath: MusicPath,
        MusicImagePath: MusicImagePath,
        MusicCodeType: MusicCodeType,
        MusicLyricTrans: MusicLyricTrans,
        MusicSourImageUrl: MusicSourImageUrl,
        MusicSongSour: MusicSongSour,
        MusicLyricvalue: MusicLyricvalue,
        MusicSongId: MusicSongId,
        MusicBr: MusicBr,
        UploadDrive: true,
        isdrive: isdrive,
        forceadd: false);
    if (i == 0) {
      String convert = MusicCach.simpleMusicGenerateSha1(
          MusicName: MusicName,
          MusicArtists: MusicArtists,
          MusicAlbum: MusicAlbum,
          MusicSongSour: MusicSongSour);
      var i = await updateSql('''
          UPDATE SQ_Music SET IsLike=1 WHERE UUID ='$convert'
          ''');
      if (i > 0) {
        return true;
      } else {
        return false;
      }
    }
  }

  //我喜欢的歌曲列表
  static Future<List<Map<String, Object>>> myLikeMusic() async {
    return await configdb.rawQuery("select * from SQ_Music where IsLike = 1");
  }

  ///歌单操作

//我的全部歌单
  static Future<List<Map<String, Object>>> myAllPlayList() async {
    return await configdb
        .rawQuery("SELECT * FROM SQ_Play ORDER BY PlayCreateTime desc");
  }

  //修改歌单名称
  static Future<bool> updatePlayListName(String uuid, String name) async {
    var i = await updateSql('''
          UPDATE SQ_Play SET playName='$name' WHERE UUID ='$uuid'
          ''');
    if (i > 0) {
      return true;
    } else {
      return false;
    }
  }

//增加歌单
  static Future<bool> addPlayList(String name) async {
    String uuid = MusicCach.generateSha1(Uuid().v4().toString());
    var millisecondsSinceEpoch = new DateTime.now().millisecondsSinceEpoch;

    int num = await configdb.rawInsert(
        "insert into SQ_Play VALUES ('$uuid','$name',NULL,NULL,NULL,NULL,$millisecondsSinceEpoch)");
    if (num > 0) {
      return true;
    }
    return false;
  }

//删除歌单
  static Future<bool> delPlayList(String uuid) async {
    int num =
        await configdb.rawDelete("delete FROM  SQ_Play where UUID='$uuid'");
    if (num > 0) {
      return true;
    }
    return false;
  }

  //歌单增加歌曲
  static Future<bool> addMusicToPlayList(
      String musicid, String playlistid) async {
    //不管有没有删除之前的
    await configdb.rawInsert(
        "delete FROM SQ_Play_Music WHERE MusicUUID='$musicid' and PlayUIUID ='$playlistid' ");
    String uuid = MusicCach.generateSha1(Uuid().v4().toString());
    var millisecondsSinceEpoch = new DateTime.now().millisecondsSinceEpoch;

    int num = await configdb.rawInsert(
        "insert into SQ_Play_Music VALUES ('$uuid','$musicid','$playlistid',$millisecondsSinceEpoch)  ");
    if (num > 0) {
      return true;
    }
    return false;
  }

  //歌单删除歌曲
  static Future<bool> delMusicToPlayList(
      String musicid, String playlistid) async {
    int num = await configdb.rawInsert(
        "delete FROM SQ_Play_Music WHERE MusicUUID='$musicid' and PlayUIUID ='$playlistid' ");
    if (num > 0) {
      return true;
    }
    return false;
  }

  //歌单下全部歌曲
  static Future<List<Map<String, Object>>> playListMusic(
      String playlistid) async {
    return await configdb.rawQuery('''
      SELECT
	SQ_Music.*, 
	SQ_Play_Music.CteateTime, 
	SQ_Play_Music.PlayUIUID
FROM
	SQ_Music
	INNER JOIN
	SQ_Play_Music
	ON 
		SQ_Music.UUID = SQ_Play_Music.MusicUUID  
	WHERE PlayUIUID = '$playlistid'	
	ORDER BY CteateTime DESC
      ''');
  }
}
