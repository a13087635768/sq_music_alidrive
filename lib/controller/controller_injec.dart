import 'package:get/get.dart';
import 'package:sq_music_alidrive/controller/home/tabs/kuwo_controller/kuwo_controller.dart';
import 'package:sq_music_alidrive/controller/music/music_play_controller.dart';


/**
 * 依赖注入
 */
class ControllerInjec extends GetxController{


  injec(){
    Get.put(KuwoController());
    // Get.put(UserController());
    // Get.put(MyMusicListController(),permanent: true);
    Get.put(MusicPlayController(),permanent: true);
    // Get.put(ServiceMusicListController(),permanent: true);
    // Get.put(SearchMusicPageController(),permanent: true);
    // Get.put(SetController(),permanent: true);

  }



}