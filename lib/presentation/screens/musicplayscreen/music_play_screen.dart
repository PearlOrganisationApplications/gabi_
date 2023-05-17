import 'package:flutter/material.dart';

import '../../../utils/systemuioverlay/full_screen.dart';

class MusicPlayScreen extends StatefulWidget {
  const MusicPlayScreen({super.key});

  @override
  State<MusicPlayScreen> createState() => _MusicPlayScreenState();
}

class _MusicPlayScreenState extends State<MusicPlayScreen> {
  int _value = 6;

  @override
  Widget build(BuildContext context) {
    /*double boxSize =
    MediaQuery.of(context).size.height > MediaQuery.of(context).size.width
        ? MediaQuery.of(context).size.width / 2
        : MediaQuery.of(context).size.height / 2.5;
    if (boxSize > 250) boxSize = 250;*/
    FullScreen.setColor(navigationBarColor: Colors.white, statusBarColor: Colors.transparent);
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber, Colors.black,],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.height / 24,
                          ),
                        ),
                      ),
                      Spacer(flex: 1,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Icon(
                            Icons.queue_music_sharp,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.height / 24,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Icon(
                            Icons.share,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.height / 24,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.height / 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              SizedBox(height: MediaQuery.of(context).size.height * 0.04,),

              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.height * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset('assets/images/onboarding/7111.jpg', fit: BoxFit.fill,),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.12,
                child: ListTile(
                  title: Text('Just Dummy Song',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height / 30,
                        fontWeight: FontWeight.w900),
                  ),
                  subtitle: Text('Show this text. Show Now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height / 40,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width / 16),
                      Icon(
                        Icons.music_note,
                        color: Colors.yellow,
                        size: MediaQuery.of(context).size.height / 30,
                      ),
                      Expanded(
                          child: Slider(
                              value: _value.toDouble(),
                              min: 1.0,
                              max: 20.0,
                              //divisions: 10,
                              activeColor: Colors.yellow,
                              inactiveColor: Colors.white,
                              label: 'Set volume value',
                              onChanged: (double newValue) {
                                setState(() {
                                  _value = newValue.round();
                                });
                              },
                              semanticFormatterCallback: (double newValue) {
                                return '${newValue.round()} dollars';
                              }
                          )
                      ),
                    ]
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02,),


              SizedBox(
                height: MediaQuery.of(context).size.height * 0.16,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 30,
                        width: 30,
                        child: Icon(
                          Icons.shuffle,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.height / 28,
                        ),
                      ),
                    ),
                    const Spacer(flex: 1,),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 30,
                        width: 30,
                        child: Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.height / 22,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 9,
                        width: MediaQuery.of(context).size.height / 9,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height / 18)
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.black87,
                          size: MediaQuery.of(context).size.height / 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 30,
                        width: 30,
                        child: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.height / 22,
                        ),
                      ),
                    ),

                    const Spacer(flex: 1,),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 30,
                        width: 30,
                        child: Icon(
                          Icons.repeat,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.height / 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              )

              /*SizedBox(
                height: 150,
                child: Container(
                  child: ListView.builder(itemBuilder: (context, index) {

                  },),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
