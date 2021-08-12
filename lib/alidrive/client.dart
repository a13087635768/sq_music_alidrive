
//操作阿里云盘客户端
import 'package:sq_music_alidrive/alidrive/api.dart';
import 'package:sq_music_alidrive/utils/db_utils.dart';
import 'package:sq_music_alidrive/utils/music_cach.dart';

class Client{
  //刷新token
  // static String refresh_token ="763ede0ddaa2442e8d936fdb09befea6";
  // drive_id
  static String drive_id ="178606";
  //请求token
  static String authorization;

  static String MusicFileId;

//刷新authorization token
  static Future<bool> refreshToken() async{
  var refreshToken = await Api.refreshToken(DBUtil.instance.userinfo.get("refresh_token"));
    if(refreshToken.statusCode!=200){
      return false;
    }
   DBUtil.instance.userinfo.put("refresh_token",refreshToken.data["refresh_token"]);
  Client.authorization = refreshToken.data["access_token"];
  Client.drive_id = refreshToken.data["default_drive_id"];
   return true;
  }
    // 04b8fdad646d442b9400c054c1f55067
  //创建文件夹

  static Future<String> mkdir(String parent_file_id, String name) async{
    if(authorization==null){
      await refreshToken();
    }
    var mkdirres = await Api.mkdir(authorization,drive_id,parent_file_id,name);

    //需要刷新token
    if(mkdirres.statusCode==401){
      await refreshToken();
      return mkdir(parent_file_id,name);
    }


    try {
      return mkdirres.data["file_id"];
    } catch (e) {
      return null;
    }
  }


  ///是否存在muisc文件夹不存在则创建
  static Future<String>  existMusicDirectory({String MusicSongSour}) async {
    if(MusicFileId!=null&&MusicSongSour==null){
      return MusicFileId;
    }

    if(authorization==null){
      await refreshToken();
    }
  //找到相对的文件夹
    var fileList = await Api.fileList(authorization,drive_id,"root");
//需要刷新token
    if(fileList.statusCode==401){
      await refreshToken();
      return existMusicDirectory(MusicSongSour:MusicSongSour);
    }
    //默认不存在music文件夹
    bool isExists =false;
    //music文件夹的id
    String musicFileId;
    //继续寻找其他文件夹
    for (var item in fileList.data["items"]) {
        //找到所在文件夹
      if(item["name"]=="music"&& item["type"]=="folder"){
        musicFileId =  item["file_id"];
        isExists=true;
      }
    }
    if(!isExists){
      //不存在则创建
      var mkdirmusicdata = await mkdir("root","music");
      if(mkdirmusicdata!=null){
        musicFileId = mkdirmusicdata;
      }
    }
    if(MusicSongSour==null){
      return musicFileId;
    }else{
      var fileList2 = await Api.fileList(authorization,drive_id,musicFileId);
      bool temp =false;
      for (var item in fileList2.data["items"]) {
        if(item["name"]==MusicSongSour&& item["type"]=="folder"){
          return item["file_id"];
          temp=true;
        }
      }
      if(!temp){
        String MusicSongSourID = await mkdir(musicFileId,MusicSongSour);
        if(MusicSongSourID!=null){
         return MusicSongSourID;
        }
      }

    }

  }



  //是否存在db配置文件
  static Future<dynamic> existConifDB() async {
    var musicFileId = await existMusicDirectory();
    if(musicFileId!=null){
      //打开muisc文件夹查看db文件
      if(authorization==null){
        await refreshToken();
      }
      var fileList = await Api.fileList(authorization,drive_id,musicFileId);

      //需要刷新token
      if(fileList.statusCode==401){
        await refreshToken();
        return existConifDB();
      }

      //查找config.db文件
      for (var item in fileList.data["items"]) {
        //找到所在文件夹
          if(item["name"]=="config.db"&& item["type"]=="file"){
           return item;
        }
      }
      return null;
    }else{
      //无法创建文件夹
      return null;
    }

  }
  ///
  static Future  getDownloadUrl(String file_id) async {
    if(authorization==null){
      await refreshToken();
    }
    var response = await Api.get_download_url(authorization,drive_id, file_id);
    //需要刷新token
    if(response.statusCode==401){
      await refreshToken();
      return getDownloadUrl(file_id);
    }
    return response;
  }

  static Future downloadFile(String download_url,String download_size,String file_id,String download_path,String download_name) async {
    // String download_url,String download_size,
    if(authorization==null){
      await refreshToken();
    }


   // var download_file_response = await Api.get_download_url(authorization,drive_id,file_id);
    //需要刷新token
    // if(download_file_response.statusCode==401){
    //   await refreshToken();
    //   return downloadFile(file_id,download_path,download_name);
    // }
    // if(download_name==null){
    //   download_name = download_file_response
    // }
    var response = await Api.download_file(authorization,download_url, download_size, download_path, download_name);

    //需要刷新token
    if(response.statusCode==401){
      await refreshToken();
      return downloadFile(authorization,download_url, download_size, download_path, download_name);
    }
    return response;
  }

  static Future delFile(String file_id) async{

    if(authorization==null){
      await refreshToken();
    }
    var response = await Api.del_file(authorization, drive_id, file_id);
    //需要刷新token
    if(response.statusCode==401){
      await refreshToken();
      return delFile(file_id);
    }
    if(response.statusCode==204){
      return response;
    }
    return null;
  }


  static Future uploadFile({String file_path,String parent_file_id,String name}) async {
    if(authorization==null){
      await refreshToken();
    }

    var uploadFile = await Api.uploadFile(authorization, drive_id, file_path, name,parent_file_id);
    print(uploadFile);
    return uploadFile;
  }






}