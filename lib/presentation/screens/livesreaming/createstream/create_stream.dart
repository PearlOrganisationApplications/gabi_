import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:gabi/presentation/screens/homescreen/widgets/custom_dialogs.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:gabi/presentation/screens/livesreaming/createstream/types/params.dart';

import 'constants.dart';
import 'settings_screen.dart';

class CreateStreamPage extends StatefulWidget {
  const CreateStreamPage({super.key});

  @override
  State<CreateStreamPage> createState() => _CreateStreamPageState();
}

class _CreateStreamPageState extends State<CreateStreamPage> {

  Params config = Params();
  late final ApiVideoLiveStreamController _controller = ApiVideoLiveStreamController(
    initialAudioConfig: config.audio,
    initialVideoConfig: config.video,
    onConnectionSuccess: () {
      print('Connection succeeded');
    },
    onConnectionFailed: (error) {
      print('Connection failed: $error');
      _showDialog(context, 'Connection failed', '$error');
      if (mounted) {
        setIsStreaming(false);
      }
    },
    onDisconnection: () {
      showInSnackBar('Disconnected');
      if (mounted) {
        setIsStreaming(false);
      }
    },
  );
  bool _isStreaming = false;
  bool _isMicOff = true;
  bool _isFrontCamOn = false;
  bool isVisible = false;
  bool commentsVisible = true;
  bool viewersVisible = false;
  late List<String> viewersList = ['Vipin', 'Pradeep',];
  List<String> profileUrlListViewers = ['assets/icons/everywhere_icon.png', 'assets/icons/everywhere_icon.png', 'assets/icons/everywhere_icon.png',];
  List<String> userNameListViewers = ['Vipin Negi', 'Pradeep Rawat', 'Gambhir'];
  List<String> profileUrlListComments = ['assets/icons/everywhere_icon.png', 'assets/icons/everywhere_icon.png',];
  List<String> userNameListComments = ['Mike', 'David'];
  List<String> commentsList = ['Fabulous', 'Hello buddy'];
  late CountdownTimerController controller;
  late int endTime;




  initializeApiController() async {
    await _controller.initialize().catchError((e) {
      showInSnackBar(e.toString());
    });
  }
  void initState() {
    endTime = DateTime.now().millisecondsSinceEpoch;
    controller = CountdownTimerController(endTime: endTime, onEnd: () {});
    _controller.initialize().catchError((e) {
      showInSnackBar(e.toString());
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      _controller.startPreview();
    }
  }



  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void enterfullscreen() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    await FullScreen.enterFullScreen(FullScreenMode.EMERSIVE_STICKY);

  }
  void exitfullscreen() async {
    await FullScreen.exitFullScreen();
  }
  void onEnd() {
    if(_isStreaming) {
      //CustomDialogs.liveStreamFinishedDialogBox();
      controller.disposeTimer();
      onStopStreamingButtonPressed();
    }
  }


  Future<bool> handleWillPop(BuildContext context) async {
    controller.dispose();
    exitfullscreen();
    return true;
  }


  @override
  Widget build(BuildContext context) {
    //FullScreen.color(color: Colors.black);
    enterfullscreen();
    return WillPopScope(
      onWillPop: () => handleWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              handleWillPop(context);
              Navigator.pop(context);
              },
            icon: Icon(Icons.arrow_back, color: Colors.white,),
          ),
          title: LiveAnimate(),
          actions: [
            Container(
              height: 60,
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CountdownTimer(
                    controller: controller,
                    onEnd: onEnd,
                    endTime: endTime,
                    textStyle: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              child: Container(
                padding: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4.0))
                ),
                child: Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Image.asset('assets/icons/everywhere_icon.png',)),
              ),
            ),
          ],
        ),

        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ApiVideoCameraPreview(controller: _controller),
                ),
                Container(
                    color: Colors.black,
                    child: _controlRowWidget()),
              ],
            ),
            /*Positioned(
                top: 120,
                left: 1,
                right: 100,
                bottom: 120,
                child: Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: isVisible,
                  child: Expanded(
                    child: Container(
                      color: Colors.red,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            commentsVisible ? ListView.builder(
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return CommentsListTile(profileUrl: 'assets/icons/everywhere_icon.png', userName: 'Mike', comment: 'Hello');
                              },) : ListView.builder(itemBuilder: (context, index) {
                              return ListTile(title: Text('Vipin', style: TextStyle(color: Colors.white),),);
                            },),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
            ),*/
            ///jjh
            /*Positioned(
              top: 50,
                right: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                  child:
                ),
            ),*/
            Positioned(
              bottom: 180,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.5),
                ),
                child: IconButton(onPressed: () {
                  CustomDialogs.viewersDialogBox(context: context, profileUrlList: profileUrlListViewers, userNameList: userNameListViewers);
                  /*setState(() {
                    viewersVisible = !viewersVisible;
                    if(viewersVisible){
                      commentsVisible = false;
                      isVisible = true;
                    }
                  });*/
                }, icon: Icon(Icons.person, color: Colors.white,)),
              ),
            ),
            Positioned(
              bottom: 120,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.5),
                ),
                child: IconButton(onPressed: () {
                  CustomDialogs.commentsDialogBox(context: context, profileUrlList: profileUrlListComments, userNameList: userNameListComments, commentsList: commentsList);
                  /*commentsVisible = !commentsVisible;
                  if(commentsVisible){
                    viewersVisible = false;
                    isVisible = true;
                  }
                  setState(() {

                  });*/
                }, icon: Icon(Icons.comment, color: Colors.white,)),
              ),
            ),
          ]
        ),
      ),
    );
  }







  void _onMenuSelected(String choice, BuildContext context) {
    if (choice == Constants.Settings) {
      _awaitResultFromSettingsFinal(context);
    }
  }

  void _awaitResultFromSettingsFinal(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SettingsScreen(params: config)));
    _controller.setVideoConfig(config.video);
    _controller.setAudioConfig(config.audio);
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _controlRowWidget() {
    final ApiVideoLiveStreamController? liveStreamController = _controller;

    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white, width: 1.0))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
            icon: _isMicOff? const Icon(Icons.mic_off, color: Colors.red,): const Icon(Icons.mic, color: Colors.white,),
            onPressed: liveStreamController != null
                ? onToggleMicrophoneButtonPressed
                : null,
          ),
          Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
              color: Colors.transparent,
              border: Border.all(color: Colors.white, width: 3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                onTap: () {
                  if(liveStreamController != null && !_isStreaming){
                    onStartStreamingButtonPressed();
                  }else {
                    onStopStreamingButtonPressed();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  ),
                  child: _isStreaming? const Icon(Icons.stop, color: Colors.white, size: 40,):const Icon(Icons.fiber_manual_record, color: Colors.red, size: 40,),
                ),

              ),
            ),
          ),
          IconButton(
            icon: _isFrontCamOn?const Icon(Icons.cameraswitch, color: Colors.white,):const Icon(Icons.cameraswitch, color: Colors.red,),
            onPressed:
            liveStreamController != null ? onSwitchCameraButtonPressed : null,
          ),
          /*IconButton(
              icon: const Icon(Icons.stop),
              color: Colors.red,
              onPressed: liveStreamController != null && _isStreaming
                  ? onStopStreamingButtonPressed
                  : null),*/
        ],
      ),
    );
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> switchCamera() async {
    final ApiVideoLiveStreamController? liveStreamController = _controller;

    if (liveStreamController == null) {
      showInSnackBar('Error: create a camera controller first.');
      return;
    }

    try {
      liveStreamController.switchCamera();
    } catch (error) {
      if (error is PlatformException) {
        _showDialog(
            context, "Error", "Failed to switch camera: ${error.message}");
      } else {
        _showDialog(context, "Error", "Failed to switch camera: $error");
      }
    }
  }

  Future<void> toggleMicrophone() async {
    final ApiVideoLiveStreamController? liveStreamController = _controller;

    if (liveStreamController == null) {
      showInSnackBar('Error: create a camera controller first.');
      return;
    }

    try {
      liveStreamController.toggleMute();
    } catch (error) {
      if (error is PlatformException) {
        _showDialog(
            context, "Error", "Failed to toggle mute: ${error.message}");
      } else {
        _showDialog(context, "Error", "Failed to toggle mute: $error");
      }
    }
  }

  Future<void> startStreaming() async {
    final ApiVideoLiveStreamController? liveStreamController = _controller;

    if (liveStreamController == null) {
      showInSnackBar('Error: create a camera controller first.');
      return;
    }
    //showInSnackBar('Starting Stream');

    try {
      await liveStreamController.startStreaming(
          streamKey: config.streamKey, url: config.rtmpUrl);
    } catch (error) {
      setIsStreaming(false);
      if (error is PlatformException) {
        print("Error: failed to start stream: ${error.message}");
      } else {
        print("Error: failed to start stream: $error");
      }
    }
  }

  Future<void> stopStreaming() async {
    final ApiVideoLiveStreamController? liveStreamController = _controller;

    if (liveStreamController == null) {
      showInSnackBar('Error: create a camera controller first.');
      return;
    }

    try {
      liveStreamController.stopStreaming();
    } catch (error) {
      if (error is PlatformException) {
        _showDialog(
            context, "Error", "Failed to stop stream: ${error.message}");
      } else {
        _showDialog(context, "Error", "Failed to stop stream: $error");
      }
    }
  }

  void onSwitchCameraButtonPressed() {
    switchCamera().then((_) {
      if (mounted) {
        setState(() {
          if(_isFrontCamOn){
            _isFrontCamOn = false;
          }else{
            _isFrontCamOn = true;
          }
        });
      }
    });
  }

  void onToggleMicrophoneButtonPressed() {
    toggleMicrophone().then((_) {
      if (mounted) {
        setState(() {
          if(_isMicOff) {
            _isMicOff = false;
          } else {
            _isMicOff = true;
          }
        });
      }
    });
  }

  void onStartStreamingButtonPressed() {
    CustomDialogs.loadingDialogBox.show();
    startStreaming().then((_) {
      if (mounted) {
        setIsStreaming(true);
      }
    });
  }

  void onStopStreamingButtonPressed() {
    stopStreaming().then((_) {
      if (mounted) {
        setIsStreaming(false);
      }
    });
  }

  void setIsStreaming(bool isStreaming) {
    if(isStreaming){
      setState(() {
        CustomDialogs.loadingDialogBox.dismiss();
        _isStreaming = isStreaming;
        controller.disposeTimer();
        endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 10;
        controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
      });
    } else {
      setState(() {
        _isStreaming = isStreaming;
        controller.disposeTimer();
      });
    }
  }
}

Future<void> _showDialog(
    BuildContext context, String title, String description) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(description),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Dismiss'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );

}

class LiveAnimate extends StatefulWidget {
  const LiveAnimate({Key? key}) : super(key: key);

  @override
  State<LiveAnimate> createState() => _LiveAnimateState();
}

class _LiveAnimateState extends State<LiveAnimate> with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
    );
    animationController?.repeat(reverse: true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        width: 66.0,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
            FadeTransition(
              opacity: animationController!,
              child: Container(
                height: 10.0,
                width: 10.0,
                decoration: BoxDecoration(
                  color: /*_isStreaming? Colors.green:*/Colors.white,
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
          ],
        )
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    animationController?.dispose();
    super.dispose();
  }
}
