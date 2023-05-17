import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

socialIocns({required String images, required VoidCallback ontap}) {
  return Image(
    image: AssetImage(
      images,
    ),
    height: 20.0,
    width: 25.0,
  );
}