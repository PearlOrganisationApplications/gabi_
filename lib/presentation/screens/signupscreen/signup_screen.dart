
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gabi/app/api/app_api.dart';
import 'package:gabi/app/constants/app_images.dart';
import 'package:gabi/app/constants/app_strings.dart';
import 'package:gabi/app/constants/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app/constants/app_colors.dart';
import '../../../customwidgets/snackbar.dart';
import '../../widgets/nospace_formatter.dart';
import '../homescreen/home_page.dart';

import 'dart:io';
import 'package:flutter/cupertino.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cpasswordController = TextEditingController();
  File? pickedImage;
  bool _obscuredPassword = true;
  bool _obscuredCPassword = true;


  void _toggleObscured(int field) {
    setState(() {
      if(field == 0){
        _obscuredPassword = !_obscuredPassword;
      }else{
        _obscuredCPassword = !_obscuredCPassword;
      }
    });
  }


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
    await permission();
    try {
      final photo = await ImagePicker().pickImage(source: imageType, imageQuality: 20);
      print('firsterror');
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
      Navigator.pop(context);
    } catch (error) {
      EasyLoading.showToast('Access denied!');
      debugPrint(error.toString());
    }
  }

  Future permission() async {
    if (await Permission.camera.status != PermissionStatus.granted) {
      var status = await Permission.storage.request();
      if (status == PermissionStatus.denied) {
        EasyLoading.showError(
            'Permission required!!', dismissOnTap: true,
            duration: Duration(seconds: 3));
      } else if (status == PermissionStatus.permanentlyDenied) {
        EasyLoading.showError(
            'Allow Camera Permission!', dismissOnTap: true,
            duration: Duration(seconds: 3));
        Future.delayed(Duration(seconds: 3), () {
          openAppSettings();
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    //FullScreen.setColor(statusBarColor: AppColors.themeColor2, navigationBarColor: Colors.white);
    return Scaffold(
      //backgroundColor: AppColors.themeColor2,
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        elevation: 0,
        title: Text('Create Account', style: TextStyle(color: Colors.white),),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.iconsColor,
            size: IconSize.appBarIconSize,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
            child: Container(
              padding: const EdgeInsets.all(1.0),
              decoration: const BoxDecoration(
                  color: AppColors.boxDecorationColor,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))
              ),
              child: Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: const BoxDecoration(
                    color: AppColors.boxDecorationColor2,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: Image.asset(EVERY_WHERE_ICON,)),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Form(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16.0),
                      padding: EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: pickedImage == null? Colors.black : Colors.amber,
                      ),
                      alignment: Alignment.center,
                      height: 141.0,
                      width: 141.0,
                      child: Stack(
                        children: [

                          ClipRRect(
                            borderRadius: BorderRadius.circular(70.0),
                            child: pickedImage != null ?
                            Image.file(
                              pickedImage!,
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover,
                            ) :
                            Image.asset('assets/icons/user.png',),
                          ),

                          Positioned(
                            right: 4,
                            bottom: 10,
                            child: InkWell(

                                onTap: imagePickerOption,
                                child: Container(
                                    padding: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.camera_alt,size: 25,color:Colors.black,))),
                          )

                        ],
                      ),
                    ),


                    TextFormField(
                      /*onTap: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },*/
                      onTapOutside: (event) {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      controller: _nameController,
                      style: TextStyle(color: AppColors.textColor),
                      cursorColor: AppColors.cursorColor,
                      //controller: userEmailController,
                      //autofocus: true,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        prefixIconColor: Colors.orange,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(width: 2, color: AppColors.textFormFieldEnabledBorderColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2, color: AppColors.textFormFieldFocusedBorderColor),
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
                        label: const Text('Name'),
                        labelStyle: const TextStyle(color: AppColors.textLabelColor),
                        hintText: 'Enter User Name',
                        hintStyle: const TextStyle(color: AppColors.textHintColor),
                      ),
                      validator: (val) =>
                      val!.isEmpty ? 'Plase Enter User name' : null,
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    /*TextFormField(
                      controller: _phoneController,
                      style: TextStyle(color: AppColors.textColor),
                      cursorColor: AppColors.cursorColor,
                      maxLines: 1,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(width: 2, color: AppColors.textFormFieldEnabledBorderColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(width: 2, color: AppColors.textFormFieldFocusedBorderColor),
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
                        label: const Text('Phone number'),
                        labelStyle: const TextStyle(color: AppColors.textLabelColor),
                        hintText: 'Enter Phone number',
                        hintStyle: const TextStyle(color: AppColors.textHintColor),
                      ),
                      validator: (val) =>
                      val!.isEmpty ? 'Plase Enter Phone number' : null,
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),*/
                    TextFormField(
                      controller: _emailController,
                      maxLines: 1,
                      inputFormatters: [NoSpaceFormatter()],
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: AppColors.textColor),
                      onTapOutside: (event) {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      cursorColor: AppColors.cursorColor,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        prefixIconColor: Colors.orange,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(width: 2, color: AppColors.textFormFieldEnabledBorderColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(width: 2, color: AppColors.textFormFieldFocusedBorderColor),
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
                        label: const Text('Email'),
                        labelStyle: const TextStyle(color: AppColors.textLabelColor),
                        hintText: 'Email Address',
                        hintStyle: const TextStyle(color: AppColors.textHintColor),
                      ),
                      validator: (val) =>
                      !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                          .hasMatch(val!)
                          ? 'Enter an email'
                          : null,
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      obscureText: _obscuredPassword,
                      inputFormatters: [NoSpaceFormatter()],
                      style: const TextStyle(color: AppColors.textColor),
                      cursorColor: AppColors.cursorColor,
                      onTapOutside: (event) {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_rounded),
                        suffixIconColor: _obscuredCPassword ? Colors.grey : Colors.red,
                        prefixIconColor: Colors.orange,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(width: 2, color: AppColors.textFormFieldEnabledBorderColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2, color: AppColors.textFormFieldFocusedBorderColor),
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
                        suffixIcon: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: GestureDetector(
                            onTap: () => _toggleObscured(0),
                            child: Icon(
                              _obscuredPassword
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              size: 24,
                            ),
                          ),
                        ),
                        label: const Text(PASSWORD),
                        labelStyle: const TextStyle(color: AppColors.textLabelColor),
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: AppColors.textHintColor),
                      ),
                      validator: (val) =>
                      val!.isEmpty ? 'Please Enter password' : null,
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    TextFormField(
                      controller: _cpasswordController,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [NoSpaceFormatter()],
                      style: const TextStyle(color: AppColors.textColor),
                      obscureText: _obscuredCPassword,
                      cursorColor: AppColors.cursorColor,
                      onTapOutside: (event) {
                        FocusScopeNode currentFocus = FocusScope.of(context);

                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_rounded),
                        prefixIconColor: Colors.orange,
                        suffixIconColor: _obscuredCPassword ? Colors.grey : Colors.red,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(width: 2, color: AppColors.textFormFieldEnabledBorderColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2, color: AppColors.textFormFieldFocusedBorderColor),
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
                        suffixIcon: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                          child: GestureDetector(
                            onTap: () => _toggleObscured(1),
                            child: Icon(
                              _obscuredCPassword
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              size: 24,
                            ),
                          ),
                        ),
                        label: const Text(CPASSWORD),
                        labelStyle: const TextStyle(color: AppColors.textLabelColor),
                        hintText: 'Confirm Password',
                        hintStyle: const TextStyle(color: AppColors.textHintColor),
                      ),
                      validator: (val) =>
                      val!.isEmpty ? 'Confirm your Password' : val != _passwordController.text? 'Password doesn\'t match' : null ,
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    MaterialButton(
                      onPressed: () async{
                        if (_formKey.currentState!.validate()) {
                          EasyLoading.show();
                          var response = await API.signUp(
                              name: _nameController.text.toString(),
                              email: _emailController.text.toString(),
                              password: _passwordController.text.toString(),
                              imageFile: pickedImage,
                              //imageFile: pickedImage
                          );
                          EasyLoading.dismiss();
                          if( response != null) {
                            if (response.statusCode == 201) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                                    (route) => false,
                              );
                            } else if (response == null) {
                              print('Response is null');
                              ShowSnackBar().showSnackBar(
                                  context, 'No Response from Server',
                                  duration: Duration(seconds: 5));
                            } else {
                              print(response.toString());
                              ShowSnackBar().showSnackBar(
                                  context, response.toString(),
                                  duration: Duration(seconds: 5));
                            }
                          }else {
                            EasyLoading.showError('Server Error', duration: Duration(seconds: 2));
                          }
                        }
                      },
                      color: AppColors.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            SizedBox(height: 30,),
                            Text(
                              SIGN_UP,
                              style: TextStyle(
                                fontSize: FontSize.buttonFontSize,
                                color: AppColors.textColor2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if(EasyLoading.isShow){
      EasyLoading.dismiss();
    }
    super.dispose();
  }
}
