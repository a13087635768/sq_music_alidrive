import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as convert;

import 'package:sq_music_alidrive/utils/music_cach.dart';
//阿里上传api
class Api {
  static Dio dio = new Dio();
  static String ua =
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_0_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36";
  ///刷新token 获取token
  static Future<Response> refreshToken(String refresh_token) async {
    var jsonEncode = convert.jsonEncode({"refresh_token": refresh_token});
    Response post = await dio.post(
        "https://websv.aliyundrive.com/token/refresh",
        data: jsonEncode,
        options: Options(headers: {"User-Agent": ua}));

    return post;
  }

  ///获取文件列表
  static Future<Response> fileList(
      String authorization, String drive_id, String path_id) async {
    var headers = {
      'User-Agent': ua,
      'Authorization': 'Bearer ' + authorization,
      'Content-Type': 'application/json',
    };
    var parse = Uri.parse('https://api.aliyundrive.com/v2/file/list');
    var body = {
      "drive_id": drive_id,
      "parent_file_id": path_id,
      "limit": 100,
      "all": false,
      "url_expire_sec": 1600,
      "image_thumbnail_process": "image/resize,w_400/format,jpeg",
      "image_url_process": "image/resize,w_1920/format,jpeg",
      "video_thumbnail_process": "video/snapshot,t_0,f_jpg,ar_auto,w_800",
      "fields": "*",
      "order_by": "updated_at",
      "order_direction": "DESC"
    };
    Options options = Options(headers: headers);
    var postUri = await dio.postUri(parse, options: options, data: body);
    print(postUri);
    return postUri;
  }

  //创建文件夹
  static Future<Response> mkdir(String authorization, String drive_id,
      String parent_file_id, String name) async {
    var headers = {
      'Authorization': 'Bearer ' + authorization,
      'User-Agent': ua,
      'Content-Type': 'application/json',
    };
    var parse = Uri.parse(
        'https://api.aliyundrive.com/adrive/v2/file/createWithFolders');
    var body = {
      "drive_id": drive_id,
      "parent_file_id": parent_file_id,
      "name": name,
      "check_name_mode": "refuse",
      "type": "folder"
    };
    Options options = Options(headers: headers);
    var postUri = await dio.postUri(parse, options: options, data: body);
// print(postUri);
    return postUri;
  }

  //上传文件
  static Future<Response> uploadFile(String authorization, String drive_id,
      String file_path, String name,String parent_file_id) async {
    var file = new File(file_path);
    var convert = sha1.convert(file.readAsBytesSync());
    var headers = {
      'Authorization': 'Bearer ' + authorization,
      'User-Agent': ua,
    };
    var parse = Uri.parse('https://api.aliyundrive.com/adrive/v2/file/create');
    var body = {
      "drive_id": drive_id,
      "name": name,
      "type": "file",
      "content_type": "application/json",
      "check_name_mode": "auto_rename",
      "content_hash": convert.toString(),
      "content_hash_name": "sha1",
      "size": MusicCach.checkFileSize(file_path),
      "ignoreError": "false",
      "parent_file_id": parent_file_id,
      "part_info_list ": [
        {"part_number": "1"}
      ]
    };
    Options options = Options(headers: headers);
    var postUri = await dio.postUri(parse, options: options, data: body,
        onReceiveProgress: (int count, int total) {
      // print(count);
      // print(total);
    });
    print(postUri);
    //无法快传  进行手动传
    if (!postUri.data["rapid_upload"]) {
      //获取手动上传链接
      print(postUri.data["part_info_list"][0]["upload_url"]);
      print(postUri.data["upload_id"]);

      var parse2 = Uri.parse(postUri.data["part_info_list"][0]["upload_url"]);

      var uploadheaders = {
        'accept': '*/*',
        'accept-language': 'zh-CN,zh;q=0.9,ja;q=0.8',
        'user-agent':
            'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.3',
        "connection": "keep-alive",
      };
      var putUri = await dio.putUri(parse2,
          data: file.openRead(),
          options: Options(
            headers: uploadheaders,
            contentType: "",
          ), onReceiveProgress: (int count, int total) {
        print(count);
        print(total);
      });
      print(putUri.statusCode);
      print(putUri.data);
      var completefile = await completeUpload(authorization, drive_id,
          postUri.data["file_id"], postUri.data["upload_id"]);
      print(completefile.statusCode);
      print(completefile);
    }
    return postUri;
  }

  //获取下载链接
  static Future<Response> get_download_url(
      String authorization, String drive_id, String file_id) async {
    var headers = {
      'Authorization': 'Bearer ' + authorization,
      'User-Agent': ua,
      'Content-Type': 'application/json',
    };
    var parse =
        Uri.parse('https://api.aliyundrive.com/v2/file/get_download_url');
    var body = {"drive_id": drive_id, "file_id": file_id};
    Options options = Options(headers: headers);
    var postUri = await dio.postUri(parse, options: options, data: body);
    return postUri;
  }

  //下载文件
  static Future<Response> download_file(
      String authorization,
      String download_url,
      String download_size,
      String download_path,
      String download_name) async {
    var parse = Uri.parse(download_url);
    //计算文件大小
    var headers = {
      'Authorization': 'Bearer ' + authorization,
      'User-Agent': ua,
      "Referer": "https://www.aliyundrive.com/",
      "RANGE": "bytes=0-$download_size"
    };
    Options options = Options(headers: headers);
    var downloadUri = await dio
        .downloadUri(parse, download_path + "/$download_name", options: options,
            onReceiveProgress: (count, total) {
      print(count);
      print(total);
    });
    print(downloadUri);
    return downloadUri;
  }

  static Future<Response> del_file(
      String authorization, String drive_id, String file_id) async {
    var parse = Uri.parse('https://api.aliyundrive.com/v2/recyclebin/trash');
    var headers = {
      'Authorization': 'Bearer ' + authorization,
      'User-Agent': ua,
    };
    var body = {"drive_id": drive_id, "file_id": file_id};
    Options options = Options(headers: headers);
    var postUri = await dio.postUri(parse, options: options, data: body);
    print(postUri);
    return postUri;
  }

  static Future<Response> completeUpload(String authorization, String drive_id,
      String file_id, String upload_id) async {
    var parse = Uri.parse('https://api.aliyundrive.com/v2/file/complete');
    var headers = {
      'Authorization': 'Bearer ' + authorization,
      'User-Agent': ua,
    };
    var body = {
      "drive_id": drive_id,
      "file_id": file_id,
      "upload_id": upload_id
    };
    Options options = Options(headers: headers);
    var postUri = await dio.postUri(parse, options: options, data: body);
    print(postUri);
    return postUri;
  }

  // test() {
  //   var totalSizeOfFilesInDir =
  //       MusicCach.getTotalSizeOfFilesInDir(MusicCach.temporaryDirectory);
  //   return totalSizeOfFilesInDir;
  // }
}
