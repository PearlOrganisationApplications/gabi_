import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gabi/presentation/screens/homescreen/home_page.dart';
import 'package:gabi/presentation/screens/onboardingscreen/onboarding.page.dart';

import '../../../app/preferences/app_preferences.dart';
import '../loginscreen/login.page.dart';


class Splashscreen  extends StatelessWidget{
  const Splashscreen({super.key});


  @override
  Widget build(BuildContext context) {
    return const SplashWidget();
  }
}

///Splash
class SplashWidget extends StatefulWidget {
  const SplashWidget({Key? key}) : super(key: key);

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {

  final ReceivePort _port = ReceivePort();


  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);

    Future.delayed(Duration(seconds: 3),() {
      proceedToNextActivity();
    });
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
    if(progress >= 10){
      EasyLoading.showSuccess('Hello');
    }
  }


  void proceedToNextActivity() {
    if(AppPreferences.getOnBoardShow()!){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnBoardingScreen()));
    }else if(AppPreferences.getIsUserLogin()!){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: themeFlag ? AppColors.mirage : AppColors.creamColor,
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Colors.black,
                //border: Border.all(color: Colors.white, width: 2),

              ),
              child: LogoAnimate(),
            ),
            const SizedBox(height: 20.0, ),
            /*Text(
              "GABI",
              style: TextStyle(
                color: Colors.black,
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              ),
            ),*/
            const Center(
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Text(
                    "Live Streaming",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




///LOGO Animator
class LogoAnimate extends StatefulWidget {
  const LogoAnimate({Key? key}) : super(key: key);

  @override
  State<LogoAnimate> createState() => _LogoAnimateState();
}

class _LogoAnimateState extends State<LogoAnimate> with SingleTickerProviderStateMixin {

  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController!.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animationController!,
      child: ClipRRect(
        child: Image.asset(
          'assets/icons/everywhere_icon.png',
        ),
      ),
    );
  }


  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

}
