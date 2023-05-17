
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'audience.dart';
import 'broadcaster.dart';

class LiveStreamOptions extends StatefulWidget {
  const LiveStreamOptions({Key? key}) : super(key: key);

  @override
  State<LiveStreamOptions> createState() => _LiveStreamOptionsState();
}

class _LiveStreamOptionsState extends State<LiveStreamOptions> {


  Future<void> initPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }
  @override
  void initState() {
    initPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              MaterialButton(
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => Broadcaster(),));
                },
                minWidth: MediaQuery.of(context).size.width * 0.9,
                color: Colors.green,
                textColor: Colors.white,
                child: Text('Broadcaster'),
              ),
              MaterialButton(
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => Audience(),));
                },
                color: Colors.blue,
                textColor: Colors.white,
                minWidth: MediaQuery.of(context).size.width * 0.9,
                child: Text('Audience'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
