

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreen {

  static color({required Color color}) {
    setColor(statusBarColor: color, navigationBarColor: color);
  }

  static void setColor({required Color statusBarColor, required Color navigationBarColor}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom,]);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: navigationBarColor,
        statusBarColor: statusBarColor,
      ));
    });
  }
}