
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gabi/presentation/screens/homescreen/widgets/socialicons.dart';

class LiveButtonWidget extends StatefulWidget {
  final Color? dotColor;
  const LiveButtonWidget({Key? key, this.dotColor}) : super(key: key);

  @override
  State<LiveButtonWidget> createState() => _LiveButtonWidgetState();
}

class _LiveButtonWidgetState extends State<LiveButtonWidget> with SingleTickerProviderStateMixin {
  AnimationController? animationController;


  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
    );
    animationController?.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    return LiveButton(text: 'Live', controller: animationController!, dotColor: widget.dotColor ?? Colors.red);
  }


  Widget LiveButton({required String text, required AnimationController controller, required Color dotColor}) {
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
                color: dotColor,
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
