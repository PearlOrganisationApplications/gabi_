
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gabi/presentation/screens/profilescreen/profile_page.dart';


import 'package:gabi/presentation/screens/splashscreen/splashscreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'app/constants/app_strings.dart';
import 'app/preferences/app_preferences.dart';

MaterialColor apiVideoOrange = const MaterialColor(0xFFFA5B30, const {
  50: const Color(0xFFFBDDD4),
  100: const Color(0xFFFFD6CB),
  200: const Color(0xFFFFD1C5),
  300: const Color(0xFFFFB39E),
  400: const Color(0xFFFA5B30),
  500: const Color(0xFFF8572A),
  600: const Color(0xFFF64819),
  700: const Color(0xFFEE4316),
  800: const Color(0xFFEC3809),
  900: const Color(0xFFE53101)
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await FlutterDownloader.initialize(
      debug: true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  configLoading();

  runApp(
      const ProviderScope(
          child: MyApp(),
      )
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
    //..customAnimation = CustomAnimation();
}


class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        applyElevationOverlayColor: false,
      ),
      home: const Splashscreen(),
      //home: ProfilePage(),
      builder: EasyLoading.init(),
    );
  }
}
