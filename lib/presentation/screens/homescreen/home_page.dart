
import 'dart:io';

import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:path_provider/path_provider.dart';

import '../../../customwidgets/snackbar.dart';
import '../../../riverpod/connectivity_status_notifier.dart';
import '../../../utils/downloader/downloader.dart';
import '../../../utils/systemuioverlay/full_screen.dart';

class Homepage extends ConsumerWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? backButtonPressTime;
  final List<String> imagesList = [
    'assets/images/social/test.jpg',
    'assets/images/social/test.jpg',
    'assets/images/social/test.jpg',
    'assets/images/social/test.jpg',
  ];
  List<Map<String, dynamic>> trendingList = [];
  List<Map<String, dynamic>> recentsList = [];

  Homepage({super.key});


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
    final response = await API.trending();
    return response;
  });
  final recently_played_Provider = FutureProvider((ref) async {
    final response = await API.recentlyPlayed();
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


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //checkImageExists();
    FullScreen.setColor(navigationBarColor: Colors.white, statusBarColor: Colors.black);
    YYDialog.init(context);
    final indicatorPosition = ref.watch(indicatorPositionProvider);

    var connectivityStatusProvider = ref.watch(connectivityStatusProviders);
    var trendingDataProvider = ref.watch(trendingProvider);
    var recentlyPlayedDataProvider = ref.watch(recently_played_Provider);


    return WillPopScope(
      onWillPop: () => handleWillPop(context),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
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
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16.0,),
                  CarouselSlider(
                    items: imagesList.map((item) => Container(
                      child: Center(
                        child: Image.asset(item, fit: BoxFit.cover),
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
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: connectivityStatusProvider == ConnectivityStatus.isConnected?
                recentlyPlayedDataProvider.when(data: (response) {

                            if(response != null){
                              recentsList.clear();
                              for (var item in response.data) {
                                recentsList.add(item);
                              }
                            }
                            return recentsList.isNotEmpty? showRecentsList() : Center(child: Text('No Internet Connection!'),);

                          }, error: (error, stackTrace) => Text('Error Fetching Data. ${error
                          }'), loading: (){
                            return Center(child: CircularProgressIndicator(color: Colors.black,));
                          }): recentsList.isNotEmpty? showRecentsList() : Center(child: Text('No Internet Connection!'),),
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


                        Container(
                          //color: Colors.red,
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 200,
                          child: trendingDataProvider.when(
                              data: (response) {
                                if(response != null){
                                  for (var item in response!.data) {
                                    trendingList.add(item);
                                    print(item);
                                  }
                                }
                                return trendingList.isNotEmpty? showTrendingList() : Center(child: Text('No Internet Connection!'),);

                              },
                              error: (error, stackTrace) => Text('Error Fetching Data.'),
                              loading: (){
                                return Center(child: CircularProgressIndicator(color: Colors.black,));
                              }
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showTrendingList() {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return _songsCardWidget(
            context: context,
            title: trendingList[index]['title'],
            imageUrl: trendingList[index]['img'],
            songUrl: trendingList[index]['url']??'',
            songDuration: trendingList[index]['duration'] ?? '0:00',
          );
        });
  }

  Widget showRecentsList() {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: recentsList.length,
        itemBuilder: (context, index) {
          return _songsCardWidget(
            context: context,
            title: recentsList[index]['title'],
            imageUrl: recentsList[index]['img'],
            songUrl: recentsList[index]['url'] ?? '',
            songDuration: recentsList[index]['duration'] ?? '0:00',
          );
        });
  }
  Widget _songsCardWidget({required BuildContext context, required String title,required String imageUrl,required String songUrl,required String songDuration}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 30.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)
        ),
        child: InkWell(
          onTap: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) =>
                  MusicPlayerDialog(
                    songUrl: songUrl, title: title, imageUrl: imageUrl),);
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
}


