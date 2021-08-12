
import 'package:dio/dio.dart';
import 'package:sq_music_alidrive/utils/music_cach.dart';

class RequestUtils{
  static Dio dio = new Dio();
  // static Options options = null;

  static Future<Response> postUri(Uri uri,Map data) async {
    return await dio.postUri(uri,data: data);
  }

  static Future<Response> get(String uri ,Map<String, dynamic> queryParameters) async {
    return await dio.get(uri,queryParameters: queryParameters);
  }
  ///[filename] 必须带后缀
  static Future<Response> downloadFile(String url,String filename) async {
    return await dio.download(url, MusicCach.directory.path+"/"+filename,onReceiveProgress: (int count, int total){
      print("下载进度：$total 共计$count 百分比 "+(count/total).toString());
    });
  }
  static Future<Response> getMasterColor(String uri) async {
    return await dio.get("http://iecoxe.top:5000/v1/scavengers/getMasterColor",queryParameters: {"imgUrl":uri});
  }


}