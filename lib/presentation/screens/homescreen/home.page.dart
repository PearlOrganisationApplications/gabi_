import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gabi/presentation/screens/homescreen/widgets/mydrawer.dart';
import 'package:gabi/presentation/screens/homescreen/widgets/socialicons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  YoutubePlayerController? _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController? animationController;
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );
    animationController?.repeat(reverse: true);

    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId:
          'eNVSijaA7rw', // https://www.youtube.com/watch?v=Tb9k9_Bo-G4
      flags: const YoutubePlayerFlags(
        // autoPlay: false,
        // mute: true,
        // isLive: false,
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.black,
        progressColors: const ProgressBarColors(
          playedColor: Colors.black,
          handleColor: Colors.black,
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.black,
            actions: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 14.0, bottom: 14.0, right: 8.0),
                child:
                    LiveButton(text: 'Live', controller: animationController!),
              )
            ],
          ),
          drawer: const MyDradwer(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: player,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      children: const [
                        Text(
                          "Trending Now",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                    //  color: Colors.red,
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                CustomContainer(
                                  imgVal: 'assets/images/social/music.jpg',
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                const Text(
                                  "Trending Song",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      children: const [
                        Text(
                          "Recently Played",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  SizedBox(
                    //: Colors.red,
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                CustomContainer(
                                  imgVal: 'assets/images/social/music.jpg',
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                const Text(
                                  "Recently Played Song",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomContainer extends StatelessWidget {
  CustomContainer({Key? key, required this.imgVal}) : super(key: key);

  String imgVal;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.48,
          decoration: BoxDecoration(
            color: Colors.yellow,
            image: DecorationImage(
              image: AssetImage(imgVal),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(
              8.0,
            ),
          ),
        ),
        Positioned(
          bottom: 3,
          right: 5,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.download,
              color: Colors.white,
              size: 30.0,
            ),
          ),
        )
      ],
    );
  }
}
