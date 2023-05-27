


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Widget CustomCircleAvatar({
      required String image,
      required double imageHeight,
      required double imageWidth,
      required Color imageBackgroundColor,}) {
  return Container(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Center(
        child: Container(
          height: imageHeight + 3,
          width: imageWidth + 3,
          child: CircleAvatar(
            backgroundColor: imageBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: image != '' ? Image.network(
                    image,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.fill
                ) : Image.asset(
                    'assets/icons/user.png',
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.fill
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget CustomCircleAvatarTemp({
  required File image,
  required double imageHeight,
  required double imageWidth,
  required Color imageBackgroundColor,}) {
  return Container(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Center(
        child: Container(
          height: imageHeight + 3,
          width: imageWidth + 3,
          child: CircleAvatar(
            backgroundColor: imageBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: image != '' ? Image.file(
                    image,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.fill
                ) : Image.asset(
                    'assets/icons/user.png',
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.fill
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
