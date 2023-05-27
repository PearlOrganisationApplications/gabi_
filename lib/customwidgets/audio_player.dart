import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';

class MusicPlayerDialog extends StatefulWidget {
  final String songUrl;
  final String title;
  final String imageUrl;
  final onKeyDown;
  final onPlayStart;

  const MusicPlayerDialog({Key? key, required this.songUrl, required this.title, required this.imageUrl, required Function(bool value) this.onKeyDown, required Function(bool value) this.onPlayStart}) : super(key: key);

  @override
  _MusicPlayerDialogState createState() => _MusicPlayerDialogState();
}

class _MusicPlayerDialogState extends State<MusicPlayerDialog> {
  AudioPlayer _audioPlayer = AudioPlayer();
  late StreamBuilder<DurationState> _ProgressBar;
  late StreamBuilder<bool> _isPlaying;

  bool _isLoading = true;

  setAudio() async {
    await _audioPlayer.setUrl(widget.songUrl);
    _ProgressBar = StreamBuilder<DurationState>(
      stream: _durationState(),
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return ProgressBar(
          progress: progress,
          buffered: buffered,
          total: total,
          onSeek: (duration) {
            _audioPlayer.seek(duration);
          },
        );
      },
    );
    _isPlaying = StreamBuilder(
      stream: _playingState(),
      builder: (context, snapshot) {

        return IconButton(
          icon: Icon(snapshot.data ?? true ? Icons.pause : Icons.play_arrow),
          onPressed: () {

            if(snapshot.data ?? false){
              _audioPlayer.pause();
            } else {
              _audioPlayer.play();
            }

          },
        );

      },
    );

    if(_isLoading) {
      _audioPlayer.play();
      widget.onPlayStart(true);
      setState(() {
        _isLoading = false;
      });
    }

  }

  Stream<DurationState> _durationState() async* {
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

  Stream<bool> _playingState() async* {
    while (true) {

      if(_audioPlayer.position == _audioPlayer.duration){
        await _audioPlayer.setUrl(widget.songUrl);
        _audioPlayer.pause();
        setState(() {
          _ProgressBar = StreamBuilder<DurationState>(
            stream: _durationState(),
            builder: (context, snapshot) {
              final durationState = snapshot.data;
              final progress = durationState?.progress ?? Duration.zero;
              final buffered = durationState?.buffered ?? Duration.zero;
              final total = durationState?.total ?? Duration.zero;
              return ProgressBar(
                progress: progress,
                buffered: buffered,
                total: total,
                onSeek: (duration) {
                  _audioPlayer.seek(duration);
                },
              );
            },
          );
        });
      }
      yield _audioPlayer.playing;

      await Future.delayed(Duration(microseconds: 100));
    }
  }
  Stream<bool> _isBuffering() async* {
    while (true) {

      if(_audioPlayer.bufferedPosition > _audioPlayer.position){
        yield false;
      } else {
        yield true;
      }

      await Future.delayed(Duration(microseconds: 100));
    }
  }


  @override
  void initState() {
    setAudio();
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return _isLoading ?
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    ) :
    Container(
      //margin: EdgeInsets.only(top: ),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      //height: MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top+MediaQuery.of(context).padding.bottom),
      child: WillPopScope(
        onWillPop: () async {
          widget.onKeyDown(true);
          Navigator.pop(context);
          return true;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 8.0),
                  width: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black
                  ),
                  child: IconButton(onPressed: () {
                    //EasyLoading.show(status:'clicked', dismissOnTap: true);
                    widget.onKeyDown(true);
                    Navigator.pop(context);
                  }, icon: Icon(Icons.keyboard_arrow_down_sharp), color: Colors.white,),
                ),
                Container(
                  height: 50.0,
                  width: 50.0,
                  margin: EdgeInsets.only(right: 8.0),
                  child: StreamBuilder(
                      stream: _isBuffering(),
                      builder: (context, snapshot) => snapshot.data ?? true ? Card(
                        elevation: 20.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(color: Colors.black,),
                        ),
                      ) : Container()
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(widget.imageUrl)),
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 40.0,
                  child: Marquee(
                    text: widget.title,
                    //textScaleFactor: 1.0,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    blankSpace: 20.0,
                    //velocity: 100.0,
                    //pauseAfterRound: Duration(seconds: 1),
                    startPadding: 10.0,
                    //accelerationDuration: Duration(seconds: 1),
                    //accelerationCurve: Curves.linear,
                    //decelerationDuration: Duration(milliseconds: 500),
                    //decelerationCurve: Curves.easeOut,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: _ProgressBar,
                ),
                Container(
                  height: 80.0,
                  width: 80.0,
                  child: Card(
                      elevation: 20.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)
                      ),
                      child: _isPlaying
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DurationState {
  const DurationState({required this.progress, required this.buffered, required this.total});
  final Duration progress;
  final Duration buffered;
  final Duration total;
}