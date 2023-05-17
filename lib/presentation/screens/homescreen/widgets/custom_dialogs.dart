
 import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:gabi/main.dart';
import 'package:gabi/presentation/screens/livesreaming/widgets/custom_comments_listtile.dart';
import 'package:gabi/presentation/screens/livesreaming/widgets/custom_viewers_listtile.dart';
import 'package:gabi/presentation/screens/livestream/audience.dart';
import 'package:gabi/utils/systemuioverlay/full_screen.dart';
import 'package:lottie/lottie.dart';

import '../../../widgets/nospace_formatter.dart';
import '../../livesreaming/joinstream/join_stream.dart';
import '../../livesreaming/createstream/create_stream.dart';
import '../../livestream/broadcaster.dart';

class CustomDialogs {
  static YYDialog loadingDialogBox = loadingDialog();


  static YYDialog streamOptionsDialog({required BuildContext context}) {

    final _formKey = GlobalKey<FormState>();
    TextEditingController channelIdController = TextEditingController();
    YYDialog dialog = YYDialog().build();
    dialog.width = 330;
    dialog.height = 330;
    dialog.backgroundColor = Colors.white;
    dialog.borderRadius = 10.0;
    dialog.gravity = Gravity.center;
    //..gravity = Gravity.rightTop
    dialog.showCallBack = () {
      print("showCallBack invoke");
    };
    dialog.dismissCallBack = () {
      print("dismissCallBack invoke");
    };
    dialog.widget(
        Expanded(
          flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/lottie/happy_emoji.json', width: 80, height: 80),
              ],
            )
        )
    );
    dialog.widget(Container(
      // margin: EdgeInsets.only(left: 2.0, right: 2.0, top: 2.0),
      padding: EdgeInsets.only(top: 10.0, left: 10, right: 10),
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        //color: Colors.blue,
        //borderRadius: BorderRadius.only(topLeft: Radius.circular(59.0), topRight: Radius.circular(59.0))

      ),
      child: Form(
        key: _formKey,
        child: TextFormField(
          maxLines: 1,
          onTapOutside: (event) {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          controller: channelIdController,
          keyboardType: TextInputType.text,
          inputFormatters: [NoSpaceFormatter()],
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            hintText: 'Enter channel name',
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 2, color: Colors.amber),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 2, color: Colors.orange),
              borderRadius: BorderRadius.circular(15),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 2, color: Colors.red),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  width: 2, color: Colors.redAccent),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          validator: (val) => val!.isEmpty
              ? ''
              : null,
        ),
      ),
    ));

    dialog.widget(Container(
      // margin: EdgeInsets.only(left: 2.0, right: 2.0, top: 2.0),
      padding: EdgeInsets.only(top: 10.0),
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        //color: Colors.blue,
        //borderRadius: BorderRadius.only(topLeft: Radius.circular(59.0), topRight: Radius.circular(59.0))

      ),
      child: MaterialButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              dialog.dismiss();
              Navigator.push(context, MaterialPageRoute(builder: (context) => Broadcaster(channelName : channelIdController.text.toString()),)).then((value) => FullScreen.setColor(navigationBarColor: Colors.white,statusBarColor: Colors.black));
            }
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Create My Live!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),),
          )
      ),
    ));
    dialog.widget(SizedBox(width: MediaQuery.of(context).size.width * 0.3,child: Divider()));
    dialog.widget(Container(
      // margin: EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
      padding: EdgeInsets.only(bottom: 10.0),
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.only(bottomRight: Radius.circular(59.0), bottomLeft: Radius.circular(59.0)),
        //color: Colors.blue,
      ),
      child: MaterialButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              dialog.dismiss();
              Navigator.push(context, MaterialPageRoute(builder: (context) => Audience(channelName : channelIdController.text.toString()),)).then((value) => FullScreen.setColor(navigationBarColor: Colors.white,statusBarColor: Colors.black));
            }
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.orange,
          child: Text("Join Friend's Live", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),)
      ),
    ));
    dialog.widget(
      Expanded(
        flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Click & Go Live!', style: TextStyle(color: Colors.red),),
            ],
          )
      )
    );

    dialog.animatedFunc = (child, animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    };
    dialog.show();
    return dialog;
  }


  static YYDialog viewersDialogBox({required BuildContext context, required List<String> profileUrlList, required List<String> userNameList}) {
    YYDialog dialog = YYDialog().build();
    dialog.width = MediaQuery.of(context).size.width * 0.7;
    dialog.height = MediaQuery.of(context).size.height * 0.66;
    dialog.backgroundColor = Colors.white;
    dialog.borderRadius = 4.0;
    dialog.gravity = Gravity.left;
    //..gravity = Gravity.rightTop
    dialog.showCallBack = () {
      print("showCallBack invoke");
    };
    dialog.dismissCallBack = () {
      print("dismissCallBack invoke");
    };
    dialog.widget(
        Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: userNameList.length,
                  itemBuilder: (context, index) {
                    return ViewersListTile(profileUrl: profileUrlList[index], userName: userNameList[index]);
                  },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(thickness: 1.0,);
                },
              ),
            )
        )
    );
    dialog.gravityAnimationEnable = true;


    dialog.animatedFunc = (child, animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    };
    dialog.show();
    return dialog;
  }


  static YYDialog commentsDialogBox({required BuildContext context, required List<String> profileUrlList, required List<String> userNameList, required List<String> commentsList}) {
    YYDialog dialog = YYDialog().build();
    dialog.width = MediaQuery.of(context).size.width * 0.7;
    dialog.height = MediaQuery.of(context).size.height * 0.66;
    dialog.backgroundColor = Colors.white;
    dialog.borderRadius = 4.0;
    dialog.gravity = Gravity.left;
    //..gravity = Gravity.rightTop
    dialog.showCallBack = () {
      print("showCallBack invoke");
    };
    dialog.dismissCallBack = () {
      print("dismissCallBack invoke");
    };
    dialog.widget(
        Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: userNameList.length,
                      itemBuilder: (context, index) {
                        return CommentsListTile(profileUrl: profileUrlList[index], userName: userNameList[index], comment: commentsList[index]);
                      },
                    ),
                  ),
                ],
              ),
            )
        )
    );

    dialog.animatedFunc = (child, animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    };
    dialog.show();
    return dialog;
  }


  static YYDialog liveStreamFinishedDialogBox({required Function() onTap}) {
    YYDialog dialog = YYDialog().build();
    dialog.width = 150;
    dialog.height = 180;
    dialog.backgroundColor = Colors.white;
    dialog.borderRadius = 10.0;
    dialog.gravity = Gravity.center;
    dialog.barrierDismissible = false;
    //..gravity = Gravity.rightTop
    dialog.showCallBack = () {
      print("showCallBack invoke stream finished");
    };
    dialog.dismissCallBack = () {
      print("dismissCallBack invoke stream finished");
    };
    dialog.widget(
        WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Expanded(
              flex: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset('assets/lottie/happy_emoji.json', width: 80, height: 80),
                      Text('Completed',overflow: TextOverflow.fade, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: () {
                          dialog.dismiss();
                          onTap();
                          }, child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Ok'),
                        )),
                      )
                    ],
                  ),
                ),
              )
          ),
        )
    );


    dialog.animatedFunc = (child, animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    };
    dialog.show();
    return dialog;
  }


  static YYDialog loadingDialog() {
    return YYDialog().build()
    ..width = 100
    ..height = 100
    ..backgroundColor = Colors.white
    ..borderRadius = 4.0
    ..gravity = Gravity.center
    //..gravity = Gravity.rightTop
    ..showCallBack = () {
      print("showCallBack invoke loading");
    }
    ..dismissCallBack = () {
      print("dismissCallBack invoke loading");
    }
    ..widget(
        Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                      child: Center(
                          child: CircularProgressIndicator(color: Colors.amber,),
                      )
                  ),
                ],
              ),
            )
        )
    )

    ..animatedFunc = (child, animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    };
  }



}