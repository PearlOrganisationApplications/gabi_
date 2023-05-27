
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gabi/app/api/app_api.dart';
import 'package:gabi/app/preferences/app_preferences.dart';
import 'package:gabi/presentation/screens/loginscreen/login.page.dart';
import 'package:gabi/presentation/screens/resetpasswordscreen/reset_password_screen.dart';
import 'package:gabi/presentation/widgets/nospace_formatter.dart';
import 'package:gabi/widgets/circle_avatar_with_title.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_images.dart';
import '../../../utils/downloader/downloader.dart';
import '../../../utils/systemuioverlay/full_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  TextEditingController email_controller = TextEditingController(text: 'Loading');
  TextEditingController phone_controller = TextEditingController(text: 'Loading');
  TextEditingController displayName_controller = TextEditingController(text: 'Loading');
  TextEditingController country_controller = TextEditingController(text: 'Loading');
  TextEditingController gender_controller = TextEditingController(text: 'Loading');
  String userProfile = '';
  //late TextEditingController username_controller = TextEditingController(text: '');

  //late ScrollPhysics scrollViewScrollabe;
  late ScrollPhysics listViewScrollable;
  bool isEnabled = false;
  File? pickedImage;



  void imagePickerOption() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.0), topLeft: Radius.circular(40.0)),
      ),
      context: context,
      builder: (context) => Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(40.0), topLeft: Radius.circular(40.0)),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: 40,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          pickImage(ImageSource.camera);
                        },
                        child:  Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              shape: BoxShape.circle
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0,),
                      Text(
                        "Open Camera",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                          onTap: () {
                            pickImage(ImageSource.gallery);
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                shape: BoxShape.circle
                            ),
                            child: const Icon(
                              Icons.folder,
                              // color: kPrimaryColor,
                              size: 30,
                              color: Colors.orange,
                            ),
                          )
                      ),
                      SizedBox(height: 8.0,),
                      Text(
                        "Open Files",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType, imageQuality: 20);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
      Navigator.pop(context);
    } catch (error) {
      debugPrint(error.toString());
    }
  }



  Future loadProfile() async {
    EasyLoading.show();
    Response? response = await API.getUserProfile();
    EasyLoading.dismiss();

    if(response == null){
      EasyLoading.showToast('Server Unavailable');
    }else if(response.data['status']== true){
      phone_controller.text = response.data['user']['phone']??'Add Phone Number';
      country_controller.text = response.data['user']['country']??'Add country';
      gender_controller.text = response.data['user']['gender']??'Select Gender';
      email_controller.text = response.data['user']['email']??'No Email Found';
      displayName_controller.text = response.data['user']['name']??'Name not available';
      userProfile = response.data['user']['user_profile']??'';
    }else if(response.data['status'] == false){
      phone_controller.text = 'Add Phone Number';
      country_controller.text = 'Add country';
      gender_controller.text = 'Select Gender';
      email_controller.text = 'No Email Found';
      displayName_controller.text = 'Name not available';
      EasyLoading.showToast('Unauthorised access!');
    }else{
      phone_controller.text = 'Add Phone Number';
      country_controller.text = 'Add country';
      gender_controller.text = 'Select Gender';
      email_controller.text = 'No Email Found';
      displayName_controller.text = 'Name not available';

      EasyLoading.showToast(response.toString());
    }
    setState(() {
    });
  }

  Future deleteUserAccount() async {
    EasyLoading.show();
    Response? response = await API.deleteUserAccount();
    EasyLoading.dismiss();

    if(response == null){
      EasyLoading.showToast('Server Unavailable');
    }else if(response.data['status']== 'true'){
      EasyLoading.showToast('Account Deleted Successfully!');
      await GoogleSignIn().signOut();
      AppPreferences.clearCredentials();
      await Download.clearDownloadTasks();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(),), (route) => false);

    }else if(response.data['status'] == 'false'){
      EasyLoading.showToast('Unauthorised access!');
    }else{
      EasyLoading.showToast(response.toString());
    }
  }
  Future<bool> showDeleteAccountPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete my account', style: TextStyle(fontWeight: FontWeight.bold),),
        content: Text('Do you really want to Delete?'),
        actions:[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child:Text('No', style: TextStyle(fontWeight: FontWeight.bold),),
          ),

          ElevatedButton(
            onPressed: () async {
              await deleteUserAccount();
            } ,
            //return true when click on "Yes"
            child:Text('Yes', style: TextStyle(fontWeight: FontWeight.bold),),
          ),

        ],
      ),
    )??false; //if showDialouge had returned null, then return false
  }


  @override
  void initState() {

    loadProfile();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    FullScreen.setColor(navigationBarColor: Colors.white, statusBarColor: Colors.amber);


    return RefreshIndicator(
      onRefresh: () async {
        //loadProfile();
      },
      child: Scaffold(
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
        body:Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      height: 140.0,
                      width: 140.0,
                      child: Stack(
                        children: [
                          (pickedImage == null)?CustomCircleAvatar(
                            image: userProfile,
                            imageHeight: 140.0,
                            imageWidth: 140.0,
                            imageBackgroundColor: Colors.white,
                          ) :
                          CustomCircleAvatarTemp(
                            image: pickedImage!,
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
                                child: IconButton(onPressed: imagePickerOption,
                                    icon: const Icon(
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
                    Container(
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
                                    controller: email_controller,
                                    enabled: false,
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

                                /*ListTile(
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
                                ),*/
                              ],
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if(isEnabled)Container(
                                margin: EdgeInsets.only(right: 20.0),
                                child: MaterialButton(
                                    onPressed: () async {
                                      setState(() {
                                        isEnabled = false;
                                      });

                                    },
                                    color: Colors.orange,
                                    child: Text('Cancel', style: TextStyle(color: Colors.white, letterSpacing: 1, fontWeight: FontWeight.w400, fontSize: 20),)
                                ),
                              ),

                              Container(
                                child: MaterialButton(
                                    onPressed: () async {
                                      if (isEnabled) {
                                        setState(() {
                                          isEnabled = false;
                                        });
                                        EasyLoading.show();
                                        Response? response = await API.updateProfile(name: displayName_controller.text, profileStatus: (pickedImage == null)? 0 : 1, imageFile: pickedImage);
                                        EasyLoading.dismiss();
                                        if(response == null){
                                          EasyLoading.showToast('Unable to communicate to server');
                                        }else if(response.data['status'] == 'true'){
                                          EasyLoading.showToast('Profile updated successfully!');
                                        }else if(response.data['status'] == 'false'){
                                          EasyLoading.showToast('Unauthorised access!');
                                        }else{
                                          EasyLoading.showToast(response.toString());
                                        }
                                      } else {
                                        setState(() {
                                          isEnabled = true;
                                        });
                                      }
                                    },
                                    color: Colors.orange,
                                    child: Text(isEnabled?'Save':'Edit & Update', style: TextStyle(color: Colors.white, letterSpacing: 1, fontWeight: FontWeight.w400, fontSize: 20),)
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: MaterialButton(onPressed: () {

                      },
                      child: Container(height: 40,alignment: Alignment.center,width: double.infinity, child: Text('Change Password')),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          elevation: 8.0,
                          onPressed: (){

                            showDeleteAccountPopup();
                          },
                          child: Text('Delete My Account', style: TextStyle(color: Colors.white),),
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}

