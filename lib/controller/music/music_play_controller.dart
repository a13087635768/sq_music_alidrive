import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sq_music_alidrive/alidrive/client.dart';
import 'package:sq_music_alidrive/utils/music_cach.dart';
import 'package:sq_music_alidrive/utils/other_utils.dart';

class MusicPlayController extends GetxController {
  //播放工具
  AssetsAudioPlayer _assetsAudioPlayer;

  // //播放列表
  Playlist audios;

  //当前播放状态
  var isPlaying = false.obs;

  DateFormat _dateFormat = DateFormat('mm:ss');

  // @override
  void onInit() {
    //播放列表
    audios = new Playlist();
    assetsAudioPlayer.currentPosition.listen((event) {
      if (event.inMicroseconds >=
          assetsAudioPlayer.current.value.audio.duration.inMicroseconds) {
        if (assetsAudioPlayer.currentLoopMode.index == 0) {
          assetsAudioPlayer.playlistPlayAtIndex(
              new Random().nextInt(assetsAudioPlayer.playlist.audios.length));
        } else if (!assetsAudioPlayer.current.value.hasNext &&
            assetsAudioPlayer.currentLoopMode.index == 2) {
          assetsAudioPlayer.playlistPlayAtIndex(0);
        }
      }
    });
  }

  /// 添加音乐
  ///[isnet] 当它为true时 [playurl]指的是 网络地址 否则为 本地地址路径
  ///[isplay] 是否播放当前添加歌曲 true为播放
  ///[source]为歌曲的来源 酷我 QQ 酷狗 之类的
  Future<bool> addAudio(String playurl, String songname, String artist,
      String album, String imageurl, String source, String id,
      {bool isplay = true,
      // bool,
      String suffix,
      bool isdrive = false,
      int musuic_size}) async {

    var audiosuffix;
    bool isopenover =false;
    if (isdrive) {
      audiosuffix = suffix;
    } else {
      var lastIndexOf = playurl.lastIndexOf(".");
      audiosuffix = playurl.substring(lastIndexOf, playurl.length);
    }
    //计算歌曲唯一性
    String simpleMusicGenerateSha1 = MusicCach.simpleMusicGenerateSha1(
        MusicName: songname,
        MusicAlbum: album,
        MusicArtists: artist,
        MusicSongSour: source);
    Audio audio = null;
    //云盘歌曲也是通过网络获得
    //查看是否是重复音乐（重复音乐不添加，当前播放的音乐不切换）
    try {
      if (assetsAudioPlayer.current.hasValue) {
        if (assetsAudioPlayer.current.value.audio != null) {
          if (simpleMusicGenerateSha1 ==
              assetsAudioPlayer.current.value.audio.audio.metas.id
                  .split(",")[0]) {
            print('同一个音乐不操作');
            return true;
          } else {
            //判断是不是已经播放的歌曲
            for (var element in assetsAudioPlayer.playlist.audios) {
              if (simpleMusicGenerateSha1 == element.metas.id.split(",")[0]) {
                print(
                    simpleMusicGenerateSha1 == element.metas.id.split(",")[0]);
                //不新增直接跳转到已经有的歌曲
                assetsAudioPlayer.playlistPlayAtIndex(
                    assetsAudioPlayer.playlist.audios.indexOf(element));
                return true;
              }
            }
          }
        }
      }
    } catch (e) {}

    //查看是否有缓存
    var searcachfile =
        await MusicCach.searcachfile(simpleMusicGenerateSha1 + suffix);
    //todo 目前插件有问题无法缓存播放 所以稍后用省流量模式
    //没有缓存
    // if(searcachfile==null){
    //   //将歌曲文件进行缓存
    //   String cachfile = await MusicCach.cachfile(playurl,simpleMusicGenerateSha1+suffix);
    //   audio = Audio.file(cachfile,
    //     metas: Metas(
    //       id: OtherUtils.generateMd5(playurl),
    //       title: songname,
    //       artist: artist,
    //       album: album,
    //       image: MetasImage.network(imageurl),
    //     ),
    //   );
    // }

    if (searcachfile == null) {
      // //将歌曲文件进行缓存
      //todo 开启低消耗模式


      if(isopenover){
        await  MusicCach.cachfile(playurl,simpleMusicGenerateSha1+suffix);
        audio = Audio.file(
          searcachfile.path,
          metas: Metas(
            id: simpleMusicGenerateSha1 + "," + source + "," + id,
            title: songname,
            artist: artist,
            album: album,
            image: MetasImage.network(imageurl),
          ),
        );

      }else{
        //根据文件类型选择播放工具
        if (isdrive) {
          //是云盘歌曲

          var downloadUrl = await Client.getDownloadUrl(playurl);
          print(downloadUrl.data);
          audio = Audio.network(
            downloadUrl.data["url"],
            headers: {
              'Authorization': 'Bearer ' + Client.authorization,
              "Referer": "https://www.aliyundrive.com/",
              "RANGE": "bytes=0-${downloadUrl.data["size"]}"
            },
            metas: Metas(
              id: simpleMusicGenerateSha1 + "," + source + "," + id,
              title: songname,
              artist: artist,
              album: album,
              image: MetasImage.network(imageurl),
            ),
            cached: false,
          );
          // print(audio.metas);
        } else {
          //普通歌曲
          audio = Audio.network(
            playurl,
            metas: Metas(
              id: simpleMusicGenerateSha1 + "," + source + "," + id,
              title: songname,
              artist: artist,
              album: album,
              image: MetasImage.network(imageurl),
            ),
            cached: false,
          );
        }

      }





    } else {
      //有缓存则播放缓存文件
      audio = Audio.file(
        searcachfile.path,
        metas: Metas(
          id: simpleMusicGenerateSha1 + "," + source + "," + id,
          title: songname,
          artist: artist,
          album: album,
          image: MetasImage.network(imageurl),
        ),
      );
    }

    //判断是否是已经在歌单中的
    // try {
    //
    //   assetsAudioPlayer.playlist.audios.forEach((element) {
    //     if(element.metas.id.split("，")[0]==){
    //
    //     }
    //
    //
    //
    //   });
    //
    //   if(assetsAudioPlayer.playlist.audios.{
    //           //在则直接跳转到指定歌曲中
    //           assetsAudioPlayer.playlistPlayAtIndex(assetsAudioPlayer.playlist.audios.indexOf(audio));
    //           return true;
    //         }
    // } catch (e) {
    // }

    //播放器为空时创建一个
    if (assetsAudioPlayer.playlist == null) {
      audios = new Playlist();
      audios.add(audio);
      await assetsAudioPlayer.open(audios,
          autoStart: true,
          playInBackground: PlayInBackground.enabled,
          showNotification: true,
          notificationSettings: NotificationSettings(
            stopEnabled: false,
          ),
          loopMode: LoopMode.playlist);
    }

    if (assetsAudioPlayer.playlist.audios.contains(audio)) {
      await assetsAudioPlayer.playlistPlayAtIndex(audios.audios.indexOf(audio));
    } else {
      audios.add(audio);
      if (isplay) {
        assetsAudioPlayer.playlistPlayAtIndex(audios.audios.length - 1);
        // await playAudio();
      } else {
        assetsAudioPlayer.playlistPlayAtIndex(audios.audios.length - 1);
      }
    }
  }

  //从列表中移除音乐
  void removeAudio(Audio audio) {
    audios.audios.remove(audio);
  }

  //通过下标移除
  void removeAudioAtIndex(int index) {
    audios.removeAtIndex(index);
  }

  //暂停音乐
  bool pauseAudio() {
    assetsAudioPlayer.pause();
    isPlaying.value = false;
  }

  //播放音乐
  void playAudio() async {
    await assetsAudioPlayer.play();
  }

  //播放列表
  audioList() {
    return audios;
  }

  //当前播放歌曲
  Audio playingAudio() {
    return assetsAudioPlayer.current.value.audio.audio;
  }

//跳转到指定位置
  seek(Duration duration) {
    assetsAudioPlayer.seek(duration);
  }

  //工具 Duration时间转字符串
  String MuisicDurationtoString(Duration duration) {
    DateTime dateTime =
        new DateTime(0, 0, 0, 0, 0, 0, 0, duration.inMicroseconds);
    return _dateFormat.format(dateTime);
  }

  AssetsAudioPlayer get assetsAudioPlayer {
    if (_assetsAudioPlayer == null) {
      _assetsAudioPlayer = AssetsAudioPlayer.withId("sqmusic");
    }
    return _assetsAudioPlayer;
  }

  bool isCurrentPlayingMusic(String id) {
    try {
      return assetsAudioPlayer.current.value.audio.audio.metas.id
                  .split(",")[0] ==
              id
          ? true
          : false;
    } catch (e) {
      return false;
    }
  }
}
