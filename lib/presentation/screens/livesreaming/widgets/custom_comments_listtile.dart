

import 'package:flutter/material.dart';

Widget CommentsListTile ({required String profileUrl, required String userName, required String comment}) {

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
    //height: 50,
    padding: EdgeInsets.all(2.0),
    //color: Colors.green,
    child: Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
              child: Image.asset(profileUrl, height: 30, width: 30, fit: BoxFit.fill,),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(userName, style: TextStyle(fontWeight: FontWeight.bold),),
              Text(comment, style: TextStyle(color: Colors.blue, overflow: TextOverflow.fade),),
            ],
          ),
        )
      ],
    ),
  );
}