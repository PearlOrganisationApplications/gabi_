

import 'package:flutter/material.dart';

Widget ViewersListTile ({required String profileUrl, required String userName}) {

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
    //height: 50,
    padding: EdgeInsets.all(2.0),
    //color: Colors.green,
    child: Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(profileUrl, height: 30, width: 30, fit: BoxFit.fill,),
          ),
        ),
        Text(userName, style: TextStyle(fontWeight: FontWeight.bold),),
      ],
    ),
  );
}