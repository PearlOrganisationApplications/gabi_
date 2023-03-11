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

Widget LiveButton(
    {required String text, required AnimationController controller}) {
  return Container(
    alignment: Alignment.center,
    height: 20.0,
    width: 80.0,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(
        20.0,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
        FadeTransition(
          opacity: controller,
          child: Container(
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
      ],
    ),
  );
}
