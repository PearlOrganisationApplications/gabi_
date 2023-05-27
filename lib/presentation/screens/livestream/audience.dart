

import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gabi/app/models/channel_model.dart';
import 'package:gabi/app/preferences/app_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app/api/app_api.dart';
import '../../../app/models/comment_model.dart';
import '../../../utils/streamconfigs/appId.dart';
import '../../../utils/systemuioverlay/full_screen.dart';
import 'messaging.dart';

class Audience extends StatefulWidget {
  final ChannelDataModel channelData;
  const Audience({Key? key, required this.channelData}) : super(key: key);

  @override
  State<Audience> createState() => _AudienceState();
}

class _AudienceState extends State<Audience> {
  int? _remoteUid;
  String? _channel;
  bool _isInChannel = false;
  bool _localUserJoined = false;
  bool _engineInitialized = false;
  bool muted = false;
  late AgoraRtmClient _rtmClient;
  late AgoraRtmChannel _rtmChannel;

  bool _isLogin = false;
  bool _commentsVisible = false;
  bool _viewersVisible = false;
  final _channelMessageController = TextEditingController();
  List<AgoraRtmMember> _users = [];
  final _infoStrings = <CommentModel>[];



  late RtcEngine _engine;
  late RtcEngineEventHandler _eventHandler;
      bool isConnected = false;



  @override
  void initState() {
    super.initState();
    initAgora();
  }


  Future<void> initAgora() async {
    // retrieve permissions
    //create the engine
    await [Permission.microphone, Permission.camera].request();

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


    setState(() {
      _engineInitialized = true;
    });

    await joinChannel();


    _createRtmClient();
  }


  Future<void> joinChannel() async {
    await _engine.joinChannel(
      uid: 0,
      token: '',
      channelId: widget.channelData.channelName,
      options: const ChannelMediaOptions(),
    );
  }


  Future<void> destroyEngine() async {
    _engine.disableVideo();
    _engine.leaveChannel();
    _engine.unregisterEventHandler(_eventHandler);
  }
  Future<void> onEnd() async {
    EasyLoading.show();
    bool response = await API.disposeChannel(channelId: widget.channelData.channelId, userType: 'audience');
    EasyLoading.dismiss();

    if(response) {
      await destroyEngine();
      Navigator.pop(context);
    }else{
      EasyLoading.showError('Unable to process this request');
    }
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
          await destroyEngine();
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
                  connection: RtcConnection(channelId: widget.channelData.channelName,),
                ),
              ),

              _toolbar(),
              Align(
                alignment: Alignment.topRight,
                child: StreamBuilder(
                  stream: _rtmChannel.getMembers().asStream(),
                  builder: (context, snapshot) {
                    if(snapshot.data != null) {
                      _users = snapshot.data!;
                    }
                    return Container(
                      color: Colors.red,
                      margin: EdgeInsets.only(top: 50.0),
                      child: InkWell(
                        onTap: () async {
                          //_users = await _rtmChannel.getMembers();

                          setState(() {
                            _viewersVisible = true;
                          });
                        },
                        child: Text('Viewers (${snapshot.data?.length??0})'),
                      ),
                    );
                  }
                ),
              ),
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
            Text('Establishing a connection to ${widget.channelData.channelName}...'),
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
            onPressed: () async {

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
        ],
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
    _engine.muteRemoteAudioStream(mute: muted, uid: _remoteUid!);
  }

  void _goToChatPage() {
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RealTimeMessaging(
            channelName: widget.channelData.channelName,
            userName: AppPreferences.getDisplayName(),
            isBroadcaster: false,
          ),)
    );
  }

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

  /*_scrollToEnd() async {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 10), curve: Curves.linear, );
  }*/


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

}
