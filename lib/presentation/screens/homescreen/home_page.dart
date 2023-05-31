
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gabi/app/api/app_api.dart';
import 'package:gabi/app/preferences/app_preferences.dart';
import 'package:gabi/customwidgets/audio_player.dart';
import 'package:gabi/presentation/screens/homescreen/widgets/custom_dialogs.dart';
import 'package:gabi/presentation/widgets/live_button.dart';
import 'package:gabi/presentation/screens/homescreen/widgets/mydrawer.dart';
import 'package:gabi/presentation/screens/livestream/livestream_options.dart';
import 'package:gabi/utils/audioplayer/audioplayer_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_session/audio_session.dart';

import '../../../customwidgets/snackbar.dart';
import '../../../riverpod/connectivity_status_notifier.dart';
import '../../../utils/downloader/downloader.dart';
import '../../../utils/systemuioverlay/full_screen.dart';
import 'package:rxdart/rxdart.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {


  AudioPlayer _audioPlayer = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: [
    AudioSource.uri(
      Uri.parse(
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"),
      tag: MediaItem(
        id: '1',
        album: "Science Friday",
        title: "A Salute To Head-Scratching Science",
        artUri: Uri.parse(
            "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
      ),
    ),
  ]);

  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? backButtonPressTime;
  List<String> imagesList = [
    'assets/images/social/test.jpg',
    'assets/images/social/test.jpg',
    'assets/images/social/test.jpg',
  ];
  bool _networkBanner = false;
  List<Map<String, dynamic>> trendingList = [];
  List<Map<String, dynamic>> recentsList = [];
  List<Map<String, dynamic>> allSongsList = [];
  SongModel? currentSong;
  bool _isMiniPlayerVisible = false;




  Future<bool> handleWillPop(BuildContext context) async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            now.difference(backButtonPressTime!) > const Duration(seconds: 3);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = now;
      ShowSnackBar().showSnackBar(
        context,
        //AppLocalizations.of(context)!.exitConfirm,
        'Press Back Again to Exit App',
        duration: const Duration(seconds: 2),
        noAction: true,
      );
      return false;
    }
    return true;
  }

  final trendingProvider = FutureProvider((ref) async {
    final response = await API.trendingSongs();
    return response;
  });
  final recently_played_Provider = FutureProvider((ref) async {
    final response = await API.getRecentsSongs();
    return response;
  });
  final all_songs_Provider = FutureProvider((ref) async {
    final response = await API.allSongs();
    print(response.toString());
    return response;


  });
  final indicatorPositionProvider = StateProvider<int>((ref) => 0);


  /*Future<void> checkImageExists() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/profile_image.png';

    final file = File(imagePath);
    bool exists = await file.exists();
    if(!exists && AppPreferences.getPhotoUrl() != ''){
      EasyLoading.showToast('downloading', duration: Duration(seconds: 2));
      API.downloadProfileImage(url: AppPreferences.getPhotoUrl());
    }else {
      EasyLoading.showToast('File present', duration: Duration(seconds: 2));
    }
  }*/

  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _audioPlayer.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
  }

  Future<void> _startMusic() async {
    try {
      await _audioPlayer.setAudioSource(_playlist);
      setState(() {
        _isMiniPlayerVisible = true;
      });
      _audioPlayer.play();
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }
  }

  @override
  void initState() {
    loadBanners();
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //checkImageExists();
    YYDialog.init(context);

    FullScreen.setColor(navigationBarColor: Colors.white, statusBarColor: Colors.black);

    return WillPopScope(
      onWillPop: () => handleWillPop(context),
      child: Consumer(
        builder: (context, ref, child) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.black,
              title: Text('GABI', style: TextStyle(color: Colors.white),),
              actions: [
                Padding(
                  padding:
                  const EdgeInsets.only(top: 14.0, bottom: 14.0, right: 8.0),
                  child:
                  InkWell(
                    onTap: () {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => LiveStreamOptions(),));
                      CustomDialogs.streamOptionsDialog(context: context);
                      //CustomDialogBox(title_button1: 'START', title_button2: 'JOIN', context: context);
                    },
                    child: LiveButtonWidget(),
                  ),
                )
              ],
            ),
            drawer: const MyDradwer(),
            body: SafeArea(
              child: Stack(
                children: [
                  NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowIndicator();
                      return true;
                    },
                    child: RefreshIndicator(
                      onRefresh: ()async{
                        await ref.refresh(recently_played_Provider);
                        await ref.refresh(trendingProvider);
                        await ref.refresh(all_songs_Provider);
                        loadBanners();
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 16.0,),
                            Consumer(
                              builder: (context, ref, child) {
                                final indicatorPosition = ref.watch(indicatorPositionProvider);

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CarouselSlider(
                                      items: imagesList.map((item) => Container(
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.9,
                                              height: MediaQuery.of(context).size.width * 0.9,
                                              child: _networkBanner
                                                  ? Image.network(item, fit: BoxFit.fill)
                                                  : Image.asset(item, fit: BoxFit.fill),
                                            ),
                                          ],
                                        ),
                                      )).toList(),


                                      //Slider Container properties
                                      options: CarouselOptions(
                                        height: 300.0,
                                        enlargeCenterPage: true,
                                        autoPlay: true,
                                        aspectRatio: 16 / 9,
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        onPageChanged: (index, reason) {
                                          ref.read(indicatorPositionProvider.notifier).state = index;

                                        },
                                        enableInfiniteScroll: true,
                                        autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                        viewportFraction: .9,
                                      ),
                                    ),
                                    Center(
                                      child: CarouselIndicator(
                                        activeColor: Colors.green,
                                        color: Colors.black,
                                        count: imagesList.length,
                                        index: indicatorPosition,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 32.0,),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Card(
                              margin: EdgeInsets.all(0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                                    child: Row(
                                      children: const [
                                        Text(
                                          "Recently Played",
                                          style: TextStyle(
                                            //color: Colors.amber,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Consumer(

                                      builder: (context, ref, child) {
                                        var recentlyPlayedDataProvider = ref.watch(recently_played_Provider);
                                        var connectivityStatusProvider = ref.watch(connectivityStatusProviders);

                                        return Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context).size.width,
                                          height: 200,
                                          child: connectivityStatusProvider == ConnectivityStatus.isConnected?
                                          recentlyPlayedDataProvider.when(data: (response) {

                                            if(response == null){

                                            }else if(response.data['status'] == 'true'){
                                              recentsList.clear();
                                              for (var item in response.data['data']) {
                                                recentsList.insert(0, item);
                                              }
                                            }
                                            return recentsList.isNotEmpty? showRecentsList() : Center(child: Text('No Data Available!'),);

                                          }, error: (error, stackTrace) => Text('Error Fetching Data. ${error
                                          }'), loading: (){
                                            return Center(child: CircularProgressIndicator(color: Colors.green,));
                                          }): recentsList.isNotEmpty? showRecentsList() : Center(child: Text('No Internet Connection!'),),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 20.0,
                            ),
                            Card(
                              margin: EdgeInsets.all(0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                                    child: Row(
                                      children: const [
                                        Text(
                                          "Trending Now",
                                          style: TextStyle(
                                            //color: Colors.amber,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Consumer(
                                      builder: (context, ref, child) {
                                        var trendingDataProvider = ref.watch(trendingProvider);
                                        return Container(
                                          //color: Colors.red,
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          height: 200,
                                          child: trendingDataProvider.when(
                                              data: (response) {
                                                if(response == null){

                                                }else if(response.data['status'] == 'true'){
                                                  trendingList.clear();
                                                  for (var item in response.data['user']) {
                                                    trendingList.add(item);
                                                  }
                                                }

                                                return trendingList.isNotEmpty? showTrendingList() : Center(child: Text('No Internet Connection!'),);

                                              },
                                              error: (error, stackTrace) => Text('Error Fetching Data.'),
                                              loading: (){
                                                return Center(child: CircularProgressIndicator(color: Colors.red,));
                                              }
                                          ),
                                        );
                                      },),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 20.0,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                                  child: Row(
                                    children: const [
                                      Text(
                                        "All Songs",
                                        style: TextStyle(
                                          //color: Colors.amber,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Consumer(
                                  builder: (context, ref, child) {
                                    var allSongsDataProvider = ref.watch(all_songs_Provider);
                                    var connectivityStatusProvider = ref.watch(connectivityStatusProviders);
                                    print('Hii3');
                                    return Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width,
                                      //height: 400,
                                      child: connectivityStatusProvider == ConnectivityStatus.isConnected?
                                      allSongsDataProvider.when(data: (response) {

                                        if(response == null){

                                        }else if(response.data['status'] == 'true'){
                                          allSongsList.clear();
                                          for (var item in response.data['user']) {
                                            allSongsList.add(item);
                                          }
                                        }

                                        return allSongsList.isNotEmpty? showAllSongsList() : Center(child: Text('No Internet Connection!'),);

                                      }, error: (error, stackTrace) => Text('Error Fetching Data. ${error
                                      }'), loading: (){
                                        return Center(child: CircularProgressIndicator(color: Colors.blue,));
                                      }): allSongsList.isNotEmpty? showAllSongsList() : Center(child: Text('No Internet Connection!'),),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  /*StreamBuilder<PlayerState>(
                    stream: _audioPlayer.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing;

                      if(processingState == ProcessingState.loading){
                        return Center(child: CircularProgressIndicator(),);
                      }else if (processingState == ProcessingState.buffering) {
                        return Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60.0,
                            color: Colors.white.withOpacity(0.99),
                            child: Row(
                              children: [
                                Expanded(
                                    child: StreamBuilder<SequenceState?>(
                                      stream: _audioPlayer.sequenceStateStream,
                                      builder: (context, snapshot) {
                                        final state = snapshot.data;
                                        if (state?.sequence.isEmpty ?? true) {
                                          return const SizedBox();
                                        }
                                        final metadata = state!.currentSource!.tag as MediaItem;
                                        return Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child:
                                                  Image.network(metadata.artUri.toString())),
                                            ),
                                            Column(
                                              children: [
                                                Text(metadata.album!,
                                                    style: Theme.of(context).textTheme.titleLarge),
                                                Text(metadata.title),
                                              ],
                                            )

                                          ],
                                        );
                                      },
                                    ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: AssetImage('assets/icons/music.png')),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      height: 40.0,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(currentSong?.title?? 'This is the Song title', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis,),
                                          Text(currentSong?.publishedBy?? 'Singer Name'),
                                        ],
                                      ),
                                    )
                                ),
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: 40.0,
                                  height: 40.0,
                                  child: const CircularProgressIndicator(),
                                ),
                                IconButton(onPressed: () {
                                  setState(() {
                                    currentSong = null;
                                    _isMiniPlayerVisible = false;
                                  });
                                }, icon: Icon(Icons.close)),
                              ],
                            ),
                          ),
                        );
                      } else if (playing != true) {
                        return IconButton(
                          icon: const Icon(Icons.play_arrow),
                          iconSize: 64.0,
                          onPressed: _audioPlayer.play,
                        );
                      } else if (processingState != ProcessingState.completed) {
                        return IconButton(
                          icon: const Icon(Icons.pause),
                          iconSize: 64.0,
                          onPressed: _audioPlayer.pause,
                        );
                      } else {
                        return IconButton(
                          icon: const Icon(Icons.replay),
                          iconSize: 64.0,
                          onPressed: () => _audioPlayer.seek(Duration.zero,
                              index: _audioPlayer.effectiveIndices!.first),
                        );
                      }
                    },
                  ),*/

                  if(_isMiniPlayerVisible)Align(
                    alignment: Alignment.bottomLeft,
                    child: StreamBuilder<PlayerState>(
                        stream: _audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;
                          final playing = playerState?.playing;

                          return InkWell(
                            onTap: (){
                              showBottomSheet();
                            },
                            child: Container(
                              child: (processingState == ProcessingState.loading)?Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60.0,
                                  color: Colors.white.withOpacity(0.94),
                                  child: Center(child: CircularProgressIndicator(),)
                              ):Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60.0,
                                color: Colors.white.withOpacity(0.94),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: StreamBuilder<SequenceState?>(
                                        stream: _audioPlayer.sequenceStateStream,
                                        builder: (context, snapshot) {
                                          final state = snapshot.data;
                                          if (state?.sequence.isEmpty ?? true) {
                                            return const SizedBox();
                                          }
                                          final metadata = state!.currentSource!.tag as MediaItem;
                                          addSongToRecents(ref, int.parse(metadata.id));

                                          return Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                                width: 40.0,
                                                  height: 40.0,
                                                  child: (metadata.artUri.toString() != '')
                                                      ? Image.network(metadata.artUri.toString(), fit: BoxFit.fitHeight,)
                                                      : Image.asset('assets/icons/music.png'),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(metadata.title, style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis,),
                                                    Text(metadata.album!, overflow: TextOverflow.ellipsis,),
                                                  ],
                                                ),
                                              )

                                            ],
                                          );
                                        },
                                      ),
                                    ),


                                    LayoutBuilder(builder: (context, constraints) {
                                      if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                                        return Container(
                                          margin: const EdgeInsets.all(8.0),
                                          width: 40.0,
                                          height: 40.0,
                                          child: const CircularProgressIndicator(),
                                        );
                                      } else if (playing != true) {
                                        return IconButton(
                                          icon: const Icon(Icons.play_arrow),
                                          iconSize: 36.0,
                                          onPressed: _audioPlayer.play,
                                        );
                                      } else if (processingState != ProcessingState.completed) {
                                        return IconButton(
                                          icon: const Icon(Icons.pause),
                                          iconSize: 36.0,
                                          onPressed: _audioPlayer.pause,
                                        );
                                      } else {
                                        return IconButton(
                                          icon: const Icon(Icons.replay),
                                          iconSize: 36.0,
                                          onPressed: () => _audioPlayer.seek(Duration.zero,
                                              index: _audioPlayer.effectiveIndices!.first),
                                        );
                                      }
                                    },),
                                    IconButton(onPressed: () {
                                      setState(() {
                                        _audioPlayer.stop();
                                        setState(() {
                                          _isMiniPlayerVisible = false;
                                        });
                                      });
                                    }, icon: Icon(Icons.close)),
                                  ],
                                ),
                              ),
                            ),
                          );

                        /*return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60.0,
                          color: Colors.white.withOpacity(0.99),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 5.0),
                                height: 40.0,
                                width: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage('assets/icons/music.png')),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    height: 40.0,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(currentSong?.title?? 'This is the Song title', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis,),
                                        Text(currentSong?.publishedBy?? 'Singer Name'),
                                      ],
                                    ),
                                  )
                              ),
                              IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
                              IconButton(onPressed: () {
                                setState(() {
                                  currentSong = null;
                                  _isMiniPlayerVisible = false;
                                });
                              }, icon: Icon(Icons.close)),
                            ],
                          ),
                        );*/
                      }
                    ),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget showRecentsList() {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: recentsList.length,
        itemBuilder: (context, index) {
          return _recentSongsCardWidget(
            context: context,
            title: recentsList[index]['title'],
            imageUrl: recentsList[index]['img'],
            songUrl: recentsList[index]['url'] ?? '',
            songDuration: recentsList[index]['duration'] ?? '0:00',
            publishedBy: recentsList[index]['published_by'],
            songId: recentsList[index]['id'],
          );
        });
  }
  Widget showTrendingList() {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return _trendingSongsCardWidget(
            context: context,
            listIndex: index,
            title: trendingList[index]['title'],
            imageUrl: trendingList[index]['img'],
            songUrl: trendingList[index]['url']??'',
            songDuration: trendingList[index]['duration'] ?? '0:00',
            publishedBy: trendingList[index]['published_by'],
            songId: trendingList[index]['id'],
          );
        });
  }
  Widget showAllSongsList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: allSongsList.length,
        itemBuilder: (context, index) {
          return _allSongsCardWidget(
            context: context,
            listIndex: index,
            title: allSongsList[index]['title'],
            imageUrl: allSongsList[index]['img'],
            songUrl: allSongsList[index]['url'] ?? '',
            songDuration: allSongsList[index]['duration'] ?? '0:00',
            publishedBy: allSongsList[index]['published_by'],
            songId: allSongsList[index]['id'],

          );
        });
  }

  Widget _recentSongsCardWidget({required BuildContext context, required String title,required String imageUrl,required String songUrl,required String songDuration, required publishedBy, required int songId}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 30.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)
        ),
        child: InkWell(
          onTap: () {
            if (_playlist.children.isNotEmpty) {
              _playlist.children.clear();
            }
            final source = AudioSource.uri(
              Uri.parse(songUrl),
              tag: MediaItem(
                id: songId.toString(),
                album: publishedBy,
                title: title,
                artUri: Uri.parse(imageUrl),
              ),
            );
            _playlist.children.add(source);
            _startMusic();
            showBottomSheet();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 8/6,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4.0))
                        ),
                        child: Text(songDuration, style: TextStyle(fontWeight: FontWeight.w500),),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 8,
                      child: Container(
                        alignment: Alignment.center,
                        width: 32.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: IconButton(
                          onPressed: () async {
                            EasyLoading.show(status: 'Preparing file to download');
                            await Download.requestDownload(songUrl, '${title}.mp3');
                            EasyLoading.dismiss();
                          },
                          icon: const Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 16.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              LimitedBox(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _trendingSongsCardWidget({required BuildContext context, required int listIndex, required String title,required String imageUrl,required String songUrl,required String songDuration, required publishedBy, required int songId}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 30.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)
        ),
        child: InkWell(
          onTap: () {
            if (_playlist.children.isNotEmpty) {
              _playlist.children.clear();
            }
            int _count = 0;
            for (var songData in trendingList) {
              final source = AudioSource.uri(
                Uri.parse(songData['url']),
                tag: MediaItem(
                  id: songData['id'].toString(),
                  album: songData['published_by'],
                  title: songData['title'],
                  artUri: Uri.parse(songData['img']),
                ),
              );
              if(_count == listIndex){
                _playlist.children.insert(0, source);
                //_playlist.children.add(source);

              }else {
                _playlist.children.add(source);
              }
              _count += 1;
            }
            _startMusic();
            showBottomSheet();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 8/6,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4.0))
                        ),
                        child: Text(songDuration, style: TextStyle(fontWeight: FontWeight.w500),),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 8,
                      child: Container(
                        alignment: Alignment.center,
                        width: 32.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: IconButton(
                          onPressed: () async {
                            EasyLoading.show(status: 'Preparing file to download');
                            await Download.requestDownload(songUrl, '${title}.mp3');
                            EasyLoading.dismiss();
                          },
                          icon: const Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 16.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              LimitedBox(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _allSongsCardWidget({required BuildContext context, required int listIndex, required String title,required String imageUrl,required String songUrl,required String songDuration, required publishedBy, required int songId}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: AspectRatio(
        aspectRatio: 8/6,
        child: Container(
          child: Card(
            elevation: 30.0,
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)
            ),
            child: InkWell(
              onTap: () {
                if (_playlist.children.isNotEmpty) {
                  _playlist.children.clear();
                }
                int _count = 0;
                for (var songData in allSongsList) {
                  final source = AudioSource.uri(
                    Uri.parse(songData['url']),
                    tag: MediaItem(
                      id: songData['id'].toString(),
                      album: songData['published_by'],
                      title: songData['title'],
                      artUri: Uri.parse(songData['img']),
                    ),
                  );
                  if(_count == listIndex){
                    _playlist.children.insert(0, source);
                  }else {
                    _playlist.children.add(source);
                  }
                  _count += 1;
                }
                _startMusic();
                showBottomSheet();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 8/6,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 32,
                          left: 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(4.0))
                            ),
                            child: Text(songDuration, style: TextStyle(fontWeight: FontWeight.w500),),
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          right: 8,
                          child: Container(
                            alignment: Alignment.center,
                            width: 32.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: IconButton(
                              onPressed: () async {
                                EasyLoading.show(status: 'Preparing file to download');
                                await Download.requestDownload(songUrl, '${title}.mp3');
                                EasyLoading.dismiss();
                              },
                              icon: const Icon(
                                Icons.download,
                                color: Colors.white,
                                size: 16.0,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  LimitedBox(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isDismissible: false,
      isScrollControlled: false,
      //enableDrag: false,
      builder: (context) {

        return Container(
          width: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: Colors.grey.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 4.0,),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            //color: Colors.black.withOpacity(0.6),
                          ),
                          child: IconButton(
                            onPressed: (){Navigator.pop(context);},
                            icon: Icon(Icons.keyboard_arrow_down, size: 40.0,),
                            color: Colors.black,)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                        child: Container(
                          padding: const EdgeInsets.all(1.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(4.0))
                          ),
                          child: Container(
                            height: 34,
                              width: 40,
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
                  color: Colors.grey.shade100,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<SequenceState?>(
                      stream: _audioPlayer.sequenceStateStream,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        if (state?.sequence.isEmpty ?? true) {
                          return const SizedBox();
                        }
                        final metadata = state!.currentSource!.tag as MediaItem;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.width * 0.7,
                              child: (metadata.artUri.toString() != '')
                                  ? Image.network(metadata.artUri.toString(), fit: BoxFit.fitHeight)
                                  : Image.asset('assets/icons/music.png'),
                            ),
                            Text(metadata.album!,
                                style: Theme.of(context).textTheme.titleLarge),
                            Text(metadata.title),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                ControlButtons(_audioPlayer),
                StreamBuilder<PositionData>(
                  stream: _positionDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.0),
                      child: ProgressBar(
                        total: positionData?.duration ?? Duration.zero,
                        progress: positionData?.position ?? Duration.zero,
                        buffered: positionData?.bufferedPosition ?? Duration.zero,
                        onSeek: (newPosition) {
                          _audioPlayer.seek(newPosition);
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Playlist",
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 180.0,
                  child: StreamBuilder<SequenceState?>(
                    stream: _audioPlayer.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      final sequence = state?.sequence ?? [];
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: ReorderableListView(
                          onReorder: (int oldIndex, int newIndex) {
                            if (oldIndex < newIndex) newIndex--;
                            _playlist.move(oldIndex, newIndex);
                          },
                          children: [
                            for (var i = 0; i < sequence.length; i++)
                              Dismissible(
                                key: ValueKey(sequence[i]),
                                background: Container(
                                  color: Colors.redAccent,
                                  alignment: Alignment.centerRight,
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(Icons.delete, color: Colors.white),
                                  ),
                                ),
                                onDismissed: (dismissDirection) {
                                  _playlist.removeAt(i);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: (i == sequence.length -1)
                                        ? null
                                        : Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.0)),
                                  ),
                                  child: Material(
                                    /*color: i == state!.currentIndex
                                        ? Colors.grey.shade300
                                        : null,*/
                                    child: ListTile(
                                      title: Text(sequence[i].tag.title as String),
                                      trailing: i == state!.currentIndex?Icon(Icons.music_note) : null,
                                      onTap: () {
                                        _audioPlayer.seek(Duration.zero, index: i);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> addSongToRecents(WidgetRef ref, int id) async {
    await API.addRecentSong(id: id);
    ref.refresh(recently_played_Provider);
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Future<void> loadBanners() async {
    Response? response = await API.getBanners();
    if(response == null){

    }else if(response.data['status'] == 'true'){
      List<String> banners = [];
      for(var item in response.data['user']){
        banners.add(item['img']);
      }
      if(banners.isNotEmpty){
        setState(() {
          imagesList.clear();
          imagesList = banners;
          _networkBanner = true;
        });
      }
    }
  }

}


class SongModel {
  String _title;
  String _imageUrl;
  String _songUrl;
  String _songDuration;
  String _publishedBy;
  int _id;

  SongModel(this._title, this._imageUrl, this._songUrl, this._songDuration,
      this._publishedBy, this._id);

  int get id => _id;

  String get publishedBy => _publishedBy;

  String get songDuration => _songDuration;

  String get songUrl => _songUrl;

  String get imageUrl => _imageUrl;

  String get title => _title;
}

class PositionData {
  Duration _position;
  Duration _bufferedPosition;
  Duration _duration;

  PositionData(this._position, this._bufferedPosition, this._duration);

  Duration get duration => _duration;

  Duration get bufferedPosition => _bufferedPosition;

  Duration get position => _position;
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /*IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),*/
        Spacer(flex: 2,),
        StreamBuilder<LoopMode>(
          stream: player.loopModeStream,
          builder: (context, snapshot) {
            final loopMode = snapshot.data ?? LoopMode.off;
            const icons = [
              Icon(Icons.repeat, color: Colors.grey),
              Icon(Icons.repeat, color: Colors.orange),
              Icon(Icons.repeat_one, color: Colors.orange),
            ];
            const cycleModes = [
              LoopMode.off,
              LoopMode.all,
              LoopMode.one,
            ];
            final index = cycleModes.indexOf(loopMode);
            return IconButton(
              icon: icons[index],
              onPressed: () {
                player.setLoopMode(cycleModes[
                (cycleModes.indexOf(loopMode) + 1) %
                    cycleModes.length]);
              },
            );
          },
        ),
        Spacer(flex: 1,),

        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          ),
          child: StreamBuilder<PlayerState>(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;

              if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 48.0,
                    height: 48.0,
                    child: const CircularProgressIndicator(),
                  ),
                );
              } else if (playing != true) {
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 40.0,
                  onPressed: player.play,
                );
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 40.0,
                  onPressed: player.pause,
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.replay),
                  iconSize: 40.0,
                  onPressed: () => player.seek(Duration.zero,
                      index: player.effectiveIndices!.first),
                );
              }
            },
          ),
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        Spacer(flex: 1,),
        StreamBuilder<bool>(
          stream: player.shuffleModeEnabledStream,
          builder: (context, snapshot) {
            final shuffleModeEnabled = snapshot.data ?? false;
            return IconButton(
              icon: shuffleModeEnabled
                  ? const Icon(Icons.shuffle, color: Colors.orange)
                  : const Icon(Icons.shuffle, color: Colors.grey),
              onPressed: () async {
                final enable = !shuffleModeEnabled;
                if (enable) {
                  await player.shuffle();
                }
                await player.setShuffleModeEnabled(enable);
              },
            );
          },
        ),
        Spacer(flex: 2,),
      ],
    );
  }
}

