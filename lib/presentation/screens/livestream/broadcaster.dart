


import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gabi/app/api/app_api.dart';
import 'package:gabi/app/models/channel_model.dart';
import 'package:gabi/app/preferences/app_preferences.dart';
import 'package:gabi/presentation/widgets/live_button.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app/models/comment_model.dart';
import '../../../utils/streamconfigs/appId.dart';
import '../../../utils/systemuioverlay/full_screen.dart';
import '../homescreen/widgets/custom_dialogs.dart';
import 'messaging.dart';

class Broadcaster extends StatefulWidget {
  final ChannelDataModel channelData;
  const Broadcaster({Key? key, required this.channelData}) : super(key: key);

  @override
  State<Broadcaster> createState() => _BroadcasterState();
}

class _BroadcasterState extends State<Broadcaster> {
  int? _remoteUid;
  int? _localUid;
  String? _channel;
  late AgoraRtmClient _rtmClient;
  late AgoraRtmChannel _rtmChannel;


  bool _isLogin = false;
  bool _isInChannel = false;
  final _channelMessageController = TextEditingController();
  final _infoStrings = <CommentModel>[];
  final ScrollController _scrollController = ScrollController();
  bool _needsScroll = false;
  bool _commentsVisible = false;
  bool _viewersVisible = false;




  bool _localUserJoined = false;
  late RtcEngine _engine;
  late RtcEngineEventHandler _eventHandler;
  bool _engineInitialized = false;
  CountdownTimerController? controller;
  bool _isStreaming = false;

  //bool _engineInitialized = false;

  List<AgoraRtmMember> _users = [];
  bool muted = false;


  @override
  void initState() {
    super.initState();
    initAgora();
  }


  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    _eventHandler = RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        EasyLoading.showSuccess('Local : ${connection.localUid}\nChannel : ${connection.channelId}', duration: Duration(seconds: 1));
        debugPrint("local user ${connection.localUid} joined");
        setState(() {
          _localUid = connection.localUid;
          _channel = connection.channelId;
          _localUserJoined = true;
          _isStreaming = true;
          controller = CountdownTimerController(endTime: DateTime.now()
              .millisecondsSinceEpoch + 20000 * 60, onEnd: onEnd);
        });
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        debugPrint("remote user $remoteUid joined");
        EasyLoading.showSuccess('Remote : ${remoteUid}', duration: Duration(seconds: 1));
        setState(() {
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

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.setCameraCapturerConfiguration(CameraCapturerConfiguration(cameraDirection: CameraDirection.cameraRear));
    await _engine.enableVideo();
    await _engine.startPreview();
    /*if (await _engine.isCameraZoomSupported()) {
      *//*double factor = await _engine.getCameraMaxZoomFactor();
      await _engine.setCameraZoomFactor(0.5);*//*
    }*/

    await createChannel();
    setState(() {
      _engineInitialized = true;
    });

    _createRtmClient();

  }

  Future<void> createChannel() async {
    await _engine.joinChannel(
      uid: 0,
      token: '',
      channelId: widget.channelData.channelName,
      options: ChannelMediaOptions(),
    );
  }

  Future<void> destroyEngine() async {
    _engine.disableVideo();
    _engine.leaveChannel();
    _engine.unregisterEventHandler(_eventHandler);
    controller?.dispose();
  }
  Future<void> onEnd() async {

    EasyLoading.show();
    bool response = await API.disposeChannel(channelId: widget.channelData.channelId, userType: 'broadcast');
    EasyLoading.dismiss();

    if(response) {
      setState(() {
        _isStreaming = false;
      });
      await destroyEngine();
      CustomDialogs.liveStreamFinishedDialogBox(onTap: () {
        Navigator.pop(context);
      });
    }else{
      EasyLoading.showError('Unable to process this request');
    }
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_isStreaming){
          return false;
        }
        await destroyEngine();
        return true;
      },

      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: _localVideo(),
        ),
      ),
    );
  }


  // Display local user's video
  Widget _localVideo() {
    if (_engineInitialized) {
      if (_localUserJoined) {
        FullScreen.setColor(statusBarColor: Colors.black, navigationBarColor: Colors.transparent);
        return Stack(
          children: [
            AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _engine,
                canvas: const VideoCanvas(uid: 0),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(top: 24.0),
                padding: EdgeInsets.only(left: 20.0),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    LiveButtonWidget(dotColor: Colors.green),
                    controller != null? Container(
                      height: 60,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CountdownTimer(
                            controller: controller,
                            onEnd: onEnd,
                            endWidget: Text('00 : 00 : 00', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),),
                            textStyle: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ): Container(),
                  ],
                ),
              ),
            ),
            _toolbar(),
            Visibility(
              visible: _commentsVisible,
                child: _commentsBox(),
            ),
            Visibility(
              visible: _viewersVisible,
              child: _viewersBox(),
            ),
          ],
        );
      } else {
        FullScreen.setColor(statusBarColor: Colors.black, navigationBarColor: Colors.white);
        return Stack(
          children: [
            AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _engine,
                canvas: const VideoCanvas(uid: 0),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: BlurryContainer(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                color: Colors.white.withOpacity(0.6),
                elevation: 0.0,
                blur: 0.3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    Text('Creating your channel'),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    } else {
      FullScreen.setColor(statusBarColor: Colors.black, navigationBarColor: Colors.white);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text('Initializing Stream'),
        ],
      );
    }
  }

  Widget _toolbar() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RawMaterialButton(
            onPressed: () {
              setState(() {
                _commentsVisible = true;
              });
            },
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
          SizedBox(height: 8.0,),
          RawMaterialButton(
            onPressed: () async {
              _users = await _rtmChannel.getMembers();

              setState(() {
                _viewersVisible = true;
              });
            },
            child: Icon(
              Icons.visibility,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          SizedBox(height: 50.0,),
          Row(
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
                onPressed: _onSwitchCamera,
                child: Icon(
                  Icons.switch_camera,
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
        ],
      ),
    );
  }

  /// Helper function to get list of native views

  Widget _viewersBox() {
    return BlurryContainer(
        padding: EdgeInsets.all(0.0),
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Spacer(flex: 1,),
              Container(
                width: 35.0,
                margin: EdgeInsets.only(right: 12.0,),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(onPressed: () {
                  setState(() {
                    _viewersVisible = false;
                  });
                },
                  icon: Icon(Icons.close, size: 20.0),
                  color: Colors.red,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(height: 12.0,),
              Expanded(
                flex: 4,
                  child: Container(
                    child: _users.length > 0?
                    ListView.builder(
                      itemCount: _users.length,
                        itemBuilder: (context, index) {

                          return Row(
                            children: [
                              SizedBox(width: 4,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(4.0))
                                ),
                                child: Text(_users[index].userId.toString()),
                              ),
                            ],
                          );
                        },
                    )
                        : Container(
                      alignment: Alignment.center,
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            color: Colors.white,
                          ),
                          child: Text('Currently No Viewers are here', style: TextStyle(),)),
                    ),
                  ),
              ),
            ],
          ),
        )
    );
  }

  Widget _commentsBox() {
    return BlurryContainer(
      padding: EdgeInsets.all(0.0),
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(0.0)),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Spacer(flex: 1,),
            Container(
              width: 35.0,
              margin: EdgeInsets.only(right: 12.0,),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(onPressed: () {
                setState(() {
                  _commentsVisible = false;
                });
              },
                  icon: Icon(Icons.close, size: 20.0),
                color: Colors.red,
                alignment: Alignment.center,
              ),
            ),
            SizedBox(height: 12.0,),
            Expanded(
              flex: 4,
              child: Container(
                  child: _infoStrings.length > 0
                      ? ListView.builder(
                    reverse: true,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 4.0),
                        child: _infoStrings[i].comment.startsWith('%')?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 2.0,),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                color: Colors.white,

                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _infoStrings[i].peerId,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    _infoStrings[i].comment.substring(1),
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ) :
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                color: Colors.blue,

                              ),
                              child: Column(
                                children: [
                                  Text(
                                    _infoStrings[i].comment,
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  /*Text(
                                    _infoStrings[i].peerId,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  )*/
                                ],
                              ),
                            ),
                            SizedBox(width: 2.0,),
                          ],
                        ),
                        /*ListTile(
                          title: Align(
                            alignment: _infoStrings[i].comment.startsWith('%')
                                ? Alignment.bottomLeft
                                : Alignment.bottomRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                color: _infoStrings[i].comment.startsWith('%')? Colors.white : Colors.blue,

                              ),
                              child: Column(
                                crossAxisAlignment: _infoStrings[i].comment.startsWith('%') ?
                                CrossAxisAlignment.start : CrossAxisAlignment.end,
                                children: [
                                  _infoStrings[i].comment.startsWith('%')
                                      ? Text(
                                    _infoStrings[i].comment.substring(1),
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(color: Colors.black),
                                  )
                                      : Text(
                                    _infoStrings[i].comment,
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    _infoStrings[i].peerId,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),*/
                      );
                    },
                    itemCount: _infoStrings.length,
                  )
                      : Container(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Colors.white,
                      ),
                        child: Text('Start commenting', style: TextStyle(),)),
                  )),
            ),
            Container(
              //color: Colors.white,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly,
                children: <Widget>[
                  Container(
                  width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: TextFormField(
                      showCursor: true,
                      enableSuggestions: true,
                      textCapitalization: TextCapitalization
                          .sentences,
                      controller: _channelMessageController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        hintText: 'Comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius
                              .circular(20),
                          borderSide: BorderSide(
                              color: Colors.grey, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius
                              .circular(20),
                          borderSide: BorderSide(
                              color: Colors.grey, width: 2),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(40)),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                        color: Colors.white
                    ),
                    child: IconButton(
                      icon: Icon(
                          Icons.send, color: Colors.blue),
                      onPressed: _toggleSendChannelMessage,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _onCallEnd(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Stop Streaming', style: TextStyle(fontWeight: FontWeight.bold),),
        content: Text('Do you really want to Stop?'),
        actions:[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child:Text('No', style: TextStyle(fontWeight: FontWeight.bold),),
          ),

          ElevatedButton(
            onPressed: () async {
              onEnd();
              Navigator.pop(context); //close Dialog
            } ,
            //return true when click on "Yes"
            child:Text('Yes', style: TextStyle(fontWeight: FontWeight.bold),),
          ),

        ],
      ),
    );

    //Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _goToChatPage() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RealTimeMessaging(channelName: widget.channelData.channelName, userName: AppPreferences.getDisplayName(),
            isBroadcaster: true,
          ),)
    );
  }



  void _createRtmClient() async {
    _rtmClient = await AgoraRtmClient.createInstance(appId);
    _rtmClient.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _logPeer(message.text, peerId);
    };
    _rtmClient.onConnectionStateChanged = (int state, int reason) {
      print('Connection state changed: ' +
          state.toString() +
          ', reason: ' +
          reason.toString());
      if (state == 5) {
        _rtmClient.logout();
        print('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };

    _toggleLogin();
    _toggleJoinChannel();
  }

  Future<AgoraRtmChannel?> _createChannel(String name) async {
    AgoraRtmChannel? channel = await _rtmClient.createChannel(name);
    channel?.onMemberJoined = (AgoraRtmMember member) async {
      print("Member joined: " + member.userId + ', channel: ' + member.channelId);
    };
    channel?.onMemberLeft = (AgoraRtmMember member) {
      print("Member left: " + member.userId + ', channel: ' + member.channelId);
    };
    channel?.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member) {
      _logPeer(message.text, member.userId);
    };
    return channel;
  }


/*  Widget _buildSendChannelMessage() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return ;
  }*/


  void _toggleLogin() async {
    if (!_isLogin) {
      try {
        await _rtmClient.login(null, AppPreferences.getDisplayName());
        setState(() {
          _isLogin = true;
        });
      } catch (errorCode) {
        print('Login error: ' + errorCode.toString());
      }
    }
  }

  void _toggleJoinChannel() async {
    try {
      _rtmChannel = (await _createChannel(widget.channelData.channelName))!;
      await _rtmChannel.join();
      print('Join channel success.');

      setState(() {
        _isInChannel = true;
      });
    } catch (errorCode) {
      print('Join channel error: ' + errorCode.toString());
    }
  }

  void _toggleSendChannelMessage() async {
    String text = _channelMessageController.text;
    if (text.isEmpty) {
      print('Please input text to send.');
      return;
    }
    try {
      await _rtmChannel.sendMessage(AgoraRtmMessage.fromText(text));
      _log(text, '');
      _channelMessageController.clear();
    } catch (errorCode) {
      print('Send channel message error: ' + errorCode.toString());
    }
  }

  void _logPeer(String msg, String peerId){
    msg = '%'+msg;
    //print(info);
    setState(() {
      _infoStrings.insert(0, CommentModel(msg, peerId));
    });

  }

  void _log(String info, String peerId) {
    //print(info);
    setState(() {
      _infoStrings.insert(0, CommentModel(info, peerId));
    });
  }

  _scrollToEnd() async {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 10), curve: Curves.linear, );
  }

}


/*
class LiveAnimate extends StatefulWidget {
  final bool isStreaming;
  const LiveAnimate({Key? key, required this.isStreaming}) : super(key: key);

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
              child: Visibility(
                visible: widget.isStreaming,
                child: Container(
                  height: 10.0,
                  width: 10.0,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
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
}*/
