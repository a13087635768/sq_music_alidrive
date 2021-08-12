

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sq_music_alidrive/controller/home/tabs/kuwo_controller/kuwo_url.dart';
import 'package:sq_music_alidrive/utils/request_utils.dart';

class KuwoController extends GetxController{

  ///获取推荐排行榜
  Future<dynamic> topCategory() async{
    var future = await RequestUtils.get(KuwoUrl.topCategory, {"from":"web"});
    return future.data;
  }
  //搜索建议
  Future<dynamic> suggestSearch(String key) async{
    var future = await RequestUtils.get(KuwoUrl.suggestSearch, {"key":key});
    return future.data;
  }
  //排行榜歌单详情
  Future<dynamic> top(int topId,int offset,[int limit=30]) async{
    var future = await RequestUtils.get(KuwoUrl.top, {"topId":topId,"from":"web","limit":limit,"offset":offset});
    return future.data;
  }
  //歌词
  Future<dynamic> lyric(String rid) async{
    var future = await RequestUtils.get(KuwoUrl.lyric, {"rid":rid});
    return future.data;
  }
  //搜索歌曲
  Future<dynamic> search(String key,{int limit =30,int offset=1,String from ="web"}) async{
    var future = await RequestUtils.get(KuwoUrl.search, {"key":key,"limit":limit,"offset":offset,"from":from});
    return future.data;
  }
  //歌曲文件
  ///todo 将来增加歌曲码率选项
   Future<dynamic> SongPlayUrl(int rid ,{ int br=320}) async {
     var future = await RequestUtils.get(KuwoUrl.song, {"rid":rid,"br":br});
     return future.data;
  }
}