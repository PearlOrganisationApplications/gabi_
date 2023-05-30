


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../customwidgets/audio_player.dart';

class AudioPlayerService {

  static String _url = '';
  static AudioPlayer _audioPlayer = AudioPlayer();


  static Future<bool> setAudio({required String url}) async {
    try {
      await _audioPlayer.setUrl(url);
      _url = url;
      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  static playAudio() {
    _audioPlayer.play();
  }

  static pauseAudio() {
    _audioPlayer.pause();
  }

  static stopAudio() {
    _audioPlayer.stop();
  }



  static Stream<DurationState> durationState() async* {
    while (true) {
      DurationState durationState = DurationState(
        progress: _audioPlayer.position,
        total: _audioPlayer.duration!,
        buffered: _audioPlayer.bufferedPosition,
      );
      yield durationState;
      await Future.delayed(Duration(microseconds: 100));
    }
  }

  static Stream<bool> playingState() async* {
    while (true) {

      if(_audioPlayer.position == _audioPlayer.duration){
        await _audioPlayer.setUrl(_url);
        _audioPlayer.pause();
      }
      yield _audioPlayer.playing;

      await Future.delayed(Duration(microseconds: 100));
    }
  }
  static Stream<bool> isBuffering() async* {
    while (true) {

      if(_audioPlayer.bufferedPosition > _audioPlayer.position){
        yield false;
      } else {
        yield true;
      }

      await Future.delayed(Duration(microseconds: 100));
    }
  }

}

/*
class AudioPlayerStateNotifier extends StateNotifier<bool> {
  AudioPlayerStateNotifier() : super(false) {

    StreamBuilder(
      stream: AudioPlayerService._audioPlayer.playingStream,
      builder: (context, snapshot) {

      },)
  }

}
*/
