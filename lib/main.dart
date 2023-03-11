import 'package:flutter/material.dart';
import 'package:gabi/presentation/screens/onboardingscreen/onboarding.page.dart';
import 'package:gabi/presentation/screens/loginscreen/login.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: OnBoardingScreen(),
    );
  }
}
