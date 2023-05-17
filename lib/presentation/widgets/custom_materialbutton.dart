

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMaterialButton extends StatefulWidget {
  final color;
  final text;
  final textColor;
  final onPressed;
  const CustomMaterialButton({Key? key, required MaterialColor this.color, required String this.text, required Color this.textColor, required Function() this.onPressed}) : super(key: key);

  @override
  State<CustomMaterialButton> createState() => _CustomMaterialButtonState();
}

class _CustomMaterialButtonState extends State<CustomMaterialButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: widget.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      onPressed: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 20.0,
                color: widget.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class CustomMaterialButtonWithIcon extends StatefulWidget {
  final color;
  final text;
  final icon;
  final textColor;
  final onPressed;
  final Color? iconColor;
  const CustomMaterialButtonWithIcon({Key? key, this.iconColor, required MaterialColor this.color, required String this.text, required Color this.textColor, required String this.icon, required Function() this.onPressed}) : super(key: key);

  @override
  State<CustomMaterialButtonWithIcon> createState() => _CustomMaterialButtonWithIconState();
}

class _CustomMaterialButtonWithIconState extends State<CustomMaterialButtonWithIcon> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: widget.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      onPressed: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.iconColor != null?
            Image.asset(
              widget.icon,
              height: 30,
              color: widget.iconColor,
            ):
        Image.asset(
        widget.icon,
        height: 30,
      ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              widget.text,
              style: TextStyle(
                  color: widget.textColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

