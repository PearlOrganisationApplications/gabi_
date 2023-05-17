

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget CustomCard({required BuildContext context, required VoidCallback onChanged,required Icon icon , required String fileName, required String percentage}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 4.0),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        leading: icon,
        title: Text(fileName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
        subtitle: LinearProgressIndicator(color: Colors.black, backgroundColor: Colors.amber,

          minHeight: 4.0,
        ),
        trailing: Text(percentage),
      ),
    ),
  );
}