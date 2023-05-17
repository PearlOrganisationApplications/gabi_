

import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gabi/app/preferences/app_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/streamconfigs/appId.dart';
import '../../../utils/systemuioverlay/full_screen.dart';
import 'messaging.dart';

class Audience extends StatefulWidget {
  final String channelName;
  const Audience({Key? key, required this.channelName}) : super(key: key);

  @override
  State<Audience> createState() => _AudienceState();
}

class _AudienceState extends State<Audience> {
  int? _remoteUid;
  String? _channel;
  bool _localUserJoined = false;
  bool _engineInitialized = false;
  bool muted = false;

  late RtcEngine _engine;
  late RtcEngineEventHandler _eventHandler;
      bool isConnected = false;


  @override
  void dispose() {
    _engine.disableVideo();
    _engine.leaveChannel();
    _engine.unregisterEventHandler(_eventHandler);
    super.dispose();
  }
  void onEnd() {
    _engine.disableVideo();
    _engine.leaveChannel();
    _engine.unregisterEventHandler(_eventHandler);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    initAgora();
  }


  Future<void> initAgora() async {
    // retrieve permissions
    //create the engine
    _engine = createAgoraRtcEngine();
    _eventHandler =  RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        debugPrint("local user ${connection.localUid} joined");
        EasyLoading.showSuccess('Local : ${connection.localUid}\nChannel : ${connection.channelId}', duration: Duration(seconds: 1));
        setState(() {
          _localUserJoined = true;
        });
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        debugPrint("remote user $remoteUid joined");
        EasyLoading.showSuccess('Remote : ${remoteUid}', duration: Duration(seconds: 1));
        setState(() {
          _channel = connection.channelId;
          _remoteUid = remoteUid;
        });
      },
      onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
        debugPrint("remote user $remoteUid left channel");
        setState(() {
          _remoteUid = null;
        });
      },
      onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
        debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
      },
    );
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(_eventHandler);

    await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);

    await _engine.enableVideo();
    await _engine.startPreview();


    await joinChannel();

    setState(() {
      _engineInitialized = true;
    });
  }

  Future<void> joinChannel() async {
    await _engine.joinChannel(
      uid: 0,
      token: '',
      channelId: widget.channelName,
      options: const ChannelMediaOptions(),
    );
  }


  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    FullScreen.setColor(statusBarColor: Colors.black, navigationBarColor: Colors.transparent);
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('Agora Audience'),
      ),*/
      body: WillPopScope(
        onWillPop: () async {
          if(_engineInitialized && _localUserJoined && _remoteUid != null){
            return false;
          }
          return true;
        },
        child: SafeArea(
          child: Container(
              height: double.infinity,
              width: double.infinity,
              child: _remoteVideo()
          ),
        ),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {

    if(_engineInitialized) {
      if(_localUserJoined) {
        if (_remoteUid != null) {
          return Stack(
            children: [
              AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: _engine,
                  canvas: VideoCanvas(uid: _remoteUid),
                  connection: RtcConnection(channelId: widget.channelName),
                ),
              ),
              _toolbar(),
            ],
          );
        }else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text('Waiting for the Host to come online!'),
            ],
          );
        }
      }else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text('Establishing a connection to ${widget.channelName}...'),
          ],
        );
      }
    }else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text('Initializing Stream...'),
        ],
      );
    }
  }

  Widget _toolbar() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _goToChatPage,
            child: Icon(
              Icons.message_rounded,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }


  void _onCallEnd(BuildContext context) {
    onEnd();
    //Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteRemoteAudioStream(mute: muted, uid: _remoteUid!);
  }

  void _goToChatPage() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RealTimeMessaging(
            channelName: widget.channelName,
            userName: AppPreferences.getDisplayName(),
            isBroadcaster: false,
          ),)
    );
  }


  /*Future<void> _getToken() async {
    final dio = Dio();
    final response = await dio.get('https://development.pearl-developer.com/webapps/api/get/rtc/' + widget.channelName);
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        token = jsonDecode(response.body)['rtc_token'];
        //uid = jsonDecode(response.body)['uid'];
      });
    } else {
      print(response.toString());
      print('Failed to generate the token : ${response.statusCode}');
    }
  }*/


}
