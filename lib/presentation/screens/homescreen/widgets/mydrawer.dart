import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gabi/app/preferences/app_preferences.dart';
import 'package:gabi/presentation/screens/downloadscreen/download_screen.dart';
import 'package:gabi/presentation/screens/enquiryformscreen/enquiry_form_screen.dart';
import 'package:gabi/presentation/screens/homescreen/widgets/socialicons.dart';
import 'package:gabi/presentation/screens/loginscreen/login.page.dart';
import 'package:gabi/utils/downloader/downloader.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../utils/systemuioverlay/full_screen.dart';
import '../../profilescreen/profile_page.dart';
import 'custom_dialogs.dart';

class MyDradwer extends StatefulWidget {
  const MyDradwer({super.key});

  @override
  State<MyDradwer> createState() => _MyDradwerState();
}

class _MyDradwerState extends State<MyDradwer> {

  ///Logout Fuction in profile page
  Future<bool> showLogoutPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout', style: TextStyle(fontWeight: FontWeight.bold),),
        content: Text('Do you really want to Logout?'),
        actions:[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child:Text('No', style: TextStyle(fontWeight: FontWeight.bold),),
          ),

          ElevatedButton(
            onPressed: () async {
              if(Platform.isAndroid) await GoogleSignIn().signOut();
              AppPreferences.clearCredentials();
              await Download.clearDownloadTasks();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(),), (route) => false);
            } ,
            //return true when click on "Yes"
            child:Text('Yes', style: TextStyle(fontWeight: FontWeight.bold),),
          ),

        ],
      ),
    )??false; //if showDialouge had returned null, then return false
  }



  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: Colors.grey.shade400,
      child: Column(
        children: [
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
            margin: EdgeInsets.all(0.0),
            color: Colors.black,
            child: DrawerHeader(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
              child: Stack(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 100.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(50.0)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(0.4),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),)).then((value) {
                                  FullScreen.setColor(navigationBarColor: Colors.white,statusBarColor: Colors.black);
                                  setState(() {});
                                });
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                  child: AppPreferences.getPhotoUrl() != ''?
                                  Image.network(AppPreferences.getPhotoUrl(),fit: BoxFit.fill,):
                                  Image.asset('assets/icons/user.png',fit: BoxFit.fill,),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0,),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 1.0),
                          //width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            //color: Colors.blueGrey,
                            borderRadius: BorderRadius.all(Radius.circular(4.0))
                          ),
                          child: Text(
                            AppPreferences.getDisplayName(),
                            //textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                      child: Container(
                        padding: const EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4.0))
                        ),
                        child: Container(
                          height: 30.0,
                            width: 40.0,
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            ),
                            child: Image.asset('assets/icons/everywhere_icon.png',)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text("Home"),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: const Divider(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.download_done),
                    title: const Text("Downloads"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DownloadScreen(),)).then((value) => FullScreen.setColor(navigationBarColor: Colors.white,statusBarColor: Colors.black));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: const Divider(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.live_tv),
                    title: const Text("Live"),
                    onTap: () {
                      CustomDialogs.streamOptionsDialog(context: context);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: const Divider(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Profile"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),)).then((value) {
                        FullScreen.setColor(navigationBarColor: Colors.white,statusBarColor: Colors.black);
                        setState(() {});
                      });
                      },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: const Divider(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Raise issue"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EnquiyformScreen(),)).then((value) => FullScreen.setColor(navigationBarColor: Colors.white,statusBarColor: Colors.black));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: const Divider(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Log out"),
                    onTap: () {
                      showLogoutPopup();
                    },
                  ),
                  /*Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        *//*Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: socialIocns(
                      images: 'assets/images/social/facebook.png',
                      ontap: () {}),
                ),*//*
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: socialIocns(
                              images: 'assets/images/social/instagram.png',
                              ontap: () {}),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: socialIocns(
                              images: 'assets/images/social/twitter.png', ontap: () {}),
                        ),
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
