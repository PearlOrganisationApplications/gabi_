
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gabi/app/preferences/app_preferences.dart';
import 'package:gabi/presentation/screens/loginscreen/login.page.dart';
import 'package:gabi/presentation/widgets/nospace_formatter.dart';
import 'package:gabi/widgets/circle_avatar_with_title.dart';

import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_images.dart';
import '../../../utils/systemuioverlay/full_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  TextEditingController email_controller = TextEditingController(text: AppPreferences.getEmailAddress());
  late TextEditingController phone_controller;
  TextEditingController displayName_controller = TextEditingController(text: AppPreferences.getDisplayName());
  late TextEditingController country_controller;
  late TextEditingController gender_controller;
  late TextEditingController username_controller = TextEditingController(text: '');

  late ScrollPhysics scrollViewScrollabe;
  late ScrollPhysics listViewScrollable;
  bool isEnabled = false;


  @override
  void initState() {
    phone_controller = TextEditingController(text: '+91 999 888 7654');
    country_controller = TextEditingController(text: 'India');
    gender_controller = TextEditingController(text: 'Male');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    FullScreen.setColor(navigationBarColor: Colors.white, statusBarColor: Colors.amber);
    double width = MediaQuery.of(context).size.width;


    return Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
        elevation: 0,
        title: Text("My Profile", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 20, letterSpacing: 2),),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        //title: Text('Profile', style: TextStyle(color: Colors.black),),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
            child: Container(
              padding: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))
              ),
              child: Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: Image.asset('assets/icons/everywhere_icon.png',)),
            ),
          ),
        ],
      ),
      body:SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Column(
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      height: 140.0,
                      width: 140.0,
                      child: Stack(
                        children: [
                          CustomCircleAvatar(
                            image: AppPreferences.getPhotoUrl(),
                            imageHeight: 140.0,
                            imageWidth: 140.0,
                            imageBackgroundColor: Colors.white,
                          ),
                          Visibility(
                            visible: isEnabled,
                            child: Positioned(
                              bottom: 5,
                              right: 5,
                              child: Container(
                                height: 35.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: IconButton(onPressed: () {

                                }, icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: AppColors.iconsColor2,
                                  size: 20.0,
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: 10,),

                    Center(
                      child: Container(
                        height: 360,
                        padding: EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                          color: Colors.white,
                        ),
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                controller: displayName_controller,
                                enabled: isEnabled,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                autofocus: true,
                                decoration: InputDecoration(
                                    disabledBorder: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.amber, width: 2,),
                                    )
                                ),
                                style: TextStyle(color: Colors.black, letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 20),),
                            ),

                            Container(
                              width: MediaQuery.of(context).size.width * 0.86,
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [

                                  ListTile(
                                    leading: Icon(Icons.mail, color: Colors.amber, size: 30,),
                                    title: TextFormField(
                                      controller: username_controller,
                                      enabled: isEnabled,
                                      keyboardType: TextInputType.text,
                                      inputFormatters: [NoSpaceFormatter()],
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          disabledBorder: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amber, width: 2,),
                                          )
                                      ),
                                      style: TextStyle(color: Colors.black54, letterSpacing: 1, fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                  ),

                                  ListTile(
                                    leading: Icon(Icons.mail, color: Colors.amber, size: 30,),
                                    title: TextFormField(
                                      controller: email_controller,
                                      enabled: isEnabled,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          disabledBorder: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amber, width: 2,),
                                          )
                                      ),
                                      style: TextStyle(color: Colors.black54, letterSpacing: 1, fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                  ),

                                  ListTile(
                                    leading: Icon(Icons.phone, color: Colors.amber, size: 30,),
                                    title: TextFormField(
                                      controller: phone_controller,
                                      enabled: isEnabled,
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          disabledBorder: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amber, width: 2,),
                                          )
                                      ),
                                      style: TextStyle(color: Colors.black54, letterSpacing: 1, fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                  ),



                                  ListTile(
                                    leading: Icon(Icons.perm_contact_calendar_rounded, color: Colors.amber, size: 30,),
                                    title: TextFormField(
                                      controller: gender_controller,
                                      enabled: isEnabled,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          disabledBorder: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amber, width: 2,),
                                          )
                                      ),
                                      style: TextStyle(color: Colors.black54, letterSpacing: 1, fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                  ),



                                  ListTile(
                                    leading: Icon(Icons.add_business, color: Colors.amber, size: 30,),
                                    title: TextFormField(
                                      controller: country_controller,
                                      enabled: isEnabled,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          disabledBorder: InputBorder.none,
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.amber, width: 2,),
                                          )
                                      ),
                                      style: TextStyle(color: Colors.black54, letterSpacing: 1, fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: MaterialButton(
                                  onPressed: () {
                                    if (isEnabled) {
                                      setState(() {
                                        isEnabled = false;
                                      });
                                    } else {
                                      setState(() {
                                        isEnabled = true;
                                      });
                                    }
                                  },
                                  color: Colors.orange,
                                  child: Text(isEnabled?'Done':'Edit', style: TextStyle(color: Colors.white, letterSpacing: 1, fontWeight: FontWeight.w400, fontSize: 20),)
                              ),
                            ),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

