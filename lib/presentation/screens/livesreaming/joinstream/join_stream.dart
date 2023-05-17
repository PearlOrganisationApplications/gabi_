
import 'dart:ffi';
import 'package:fullscreen/fullscreen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:gabi/presentation/screens/livesreaming/widgets/custom_comments_listtile.dart';
import 'package:video_player/video_player.dart';

class JoinStreamPage extends StatefulWidget {
  const JoinStreamPage({Key? key}) : super(key: key);

  @override
  State<JoinStreamPage> createState() => _JoinStreamStatePage();
}

class _JoinStreamStatePage extends State<JoinStreamPage> with SingleTickerProviderStateMixin{
  late FlickManager videoManager;
  late TextEditingController _commentsController;
  late List<String> _commentsList;
  late List<String> _namesList;
  late List<String> _viewerProfileUrlList;
  late List<String> _viewerNameList;
  final ScrollController _scrollController = ScrollController();
  final String url = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
  AnimationController? animationController;



  bool _needsScroll = false;

  _scrollToEnd() async {
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 10), curve: Curves.linear, );
  }

  @override
  void initState() {
    super.initState();
    _commentsController = TextEditingController();
    _viewerProfileUrlList = [
      'assets/icons/everywhere_icon.png',
      'assets/icons/everywhere_icon.png',
      'assets/icons/everywhere_icon.png',
      'assets/icons/everywhere_icon.png',
      'assets/icons/everywhere_icon.png',
      'assets/icons/everywhere_icon.png',
      'assets/icons/everywhere_icon.png',
      'assets/icons/everywhere_icon.png',
      'assets/icons/everywhere_icon.png',
      'assets/icons/everywhere_icon.png',
    ];
    _viewerNameList = [
      'Anil Rawat',
      'James Harry',
      'Michel',
      'Yusuf',
      'Valamdir',
      'Chang Lee',
      'Bhushan',
      'Lavanya',
      'Osho',
      'Neel',

    ];
    _commentsList = [
      "Dummy text is text that is used in the publishing industry or by web designers to occupy the space which will later be filled with 'real' content. This is required when, for example, the final text is not yet available. Dummy text is also known as 'fill text'. It is said that song composers of the past used dummy texts as lyrics when writing melodies in order to have a 'ready-made' text to sing with the melody. Dummy texts have been in use by typesetters since the 16th century.",
      "Dummy text is also used to demonstrate the appearance of different typefaces and layouts, and in general the content of dummy text is nonsensical. Due to its widespread use as filler text for layouts, non-readability is of great importance: human perception is tuned to recognize certain patterns and repetitions in texts. If the distribution of letters and 'words' is random, the reader will not be distracted from making a neutral judgement on the visual impact and readability of the typefaces (typography), or the distribution of text on the page (layout or type area). For this reason, dummy text usually consists of a more or less random series of words or syllables. This prevents repetitive patterns from impairing the overall visual impression and facilitates the comparison of different typefaces. Furthermore, it is advantageous when the dummy text is relatively realistic so that the layout impression of the final publication is not compromised.",
      'In the 1960s, the text suddenly became known beyond the professional circle of typesetters and layout designers when it was used for Letraset sheets (adhesive letters on transparent film, popular until the 1980s) Versions of the text were subsequently included in DTP programmes such as PageMaker etc.',
      'Certain internet providers exploit the fact that fill text cannot be recognized by automatic search engines'];
    _namesList = [
      'Mac Hammer',
      'William Jonas',
      'Michel Whitey',
      'James Harry'];
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );
    animationController?.repeat(reverse: true);

    videoManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.network(url),
    );

  }

  void enterfullscreen() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    });
      await FullScreen.enterFullScreen(FullScreenMode.EMERSIVE_STICKY);
  }
  void exitfullscreen() async {
    await FullScreen.exitFullScreen();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    animationController?.dispose();
    exitfullscreen();
    videoManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    enterfullscreen();
    if (_needsScroll) {
      WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToEnd());
      _needsScroll = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white,),
          ),
        title: Text("William Smith", style: TextStyle(color: Colors.white),),
        /*actions: [
          Padding(
            padding:
            const EdgeInsets.only(top: 14.0, bottom: 14.0, right: 8.0),
            child:
            InkWell(
                onTap: () {
                  //CustomDialogs.YYNoticeDialog(context: context);
                  //CustomDialogBox(title_button1: 'START', title_button2: 'JOIN', context: context);
                },
                child: LiveButton(text: 'Live', controller: animationController!, dotColor: Colors.green)),
          ),
        ],*/
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              color: Colors.black,
              height: 56,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    /*decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.white, width: 2.0)
                    ),*/
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Viewer's ", style: TextStyle(color: Colors.white),),
                        Text("(${_viewerNameList.length})", style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(10.0),
                        //border: Border(left: BorderSide(color: Colors.white, width: 2.0,), right: BorderSide(color: Colors.white, width: 2.0,))
                        //Border.all(color: Colors.white, width: 2.0)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Comments ", style: TextStyle(color: Colors.white),),
                        Text("(${_commentsList.length})", style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),

                  Spacer(flex: 1,),
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
            ),
            Container(
              child:  FlickVideoPlayer(
                  flickManager: videoManager,
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: _scrollController,
              child: Column(
                children: [
                  Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                    child: Container(
                      height: 100.0,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: _viewerNameList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 100,
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Image.asset(_viewerProfileUrlList[index], fit: BoxFit.fill,),
                                  ),
                                ),
                                Text(_viewerNameList[index], overflow: TextOverflow.ellipsis,),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Container(
                            color: Colors.black12,
                            width: 0.0,
                          );
                        },
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _commentsList.length,
                      itemBuilder: (context, index) {
                        return CommentsListTile(
                          profileUrl: "assets/icons/everywhere_icon.png",
                          userName: _namesList[index],
                          comment: _commentsList[index],
                        );
                      }
                  ),
                ],
              ),
            )),
            Container(
              //margin: EdgeInsets.only(bottom: 24.0),
              padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 12.0),
              color: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: _commentsController,

                        onTap: () {
                          setState(() {
                            Future.delayed(Duration(milliseconds: 200), () {
                              _needsScroll=true;
                            });
                          });
                        },
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          //labelStyle: const TextStyle(color: Colors.white),
                          hintText: 'Write comment here...',
                          hintStyle: const TextStyle(color: Colors.black26),
                        ),
                        validator: (val) =>
                        val!.isEmpty ? 'Plase Enter password' : null,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.0,),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(onPressed: () {
                      _namesList.add('Mac new');
                      _commentsList.add(_commentsController.text);
                      _commentsController.clear();
                      setState(() {
                        _needsScroll = true;
                      });
                    }, icon: Icon(Icons.send, color: Colors.white, size: 25,)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
