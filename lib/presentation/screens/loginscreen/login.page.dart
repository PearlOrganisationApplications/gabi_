
import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gabi/app/api/app_api.dart';
import 'package:gabi/customwidgets/snackbar.dart';
import 'package:gabi/presentation/screens/homescreen/home_page.dart';
import 'package:gabi/presentation/screens/signupscreen/signup_screen.dart';
import 'package:gabi/presentation/widgets/custom_materialbutton.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../utils/systemuioverlay/full_screen.dart';
import '../../widgets/custom_textformfield.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../forgotepasswordscreen/forgot_password_screen.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPassController = TextEditingController();
  TextEditingController con = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if(EasyLoading.isShow){
      EasyLoading.dismiss();
    }
    FullScreen.setColor(
        statusBarColor: Colors.black, navigationBarColor: Colors.white);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 8.0),
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.30,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.black, width: 0.0),
              ),
              child: Image(
                image: AssetImage(
                  'assets/icons/everywhere_icon.png',
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
            Expanded(
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: BottomClipper(),
                      child: Container(
                        color: Colors.black,
                        height: 90,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.black, width: 0.0)),
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: 50.0,),
                            BlurryContainer(
                              color: Colors.black.withOpacity(0.5),
                              blur: 0.9,
                              child: Column(
                                children: [
                                  Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 8.0,),
                                          CustomTextFormFieldEmail(
                                              onValueChanged: (value) {
                                                userEmailController.text =
                                                    value;
                                              },
                                            textColor: Colors.white,
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          CustomTextFormFieldPassword(
                                              onValueChanged: (value) {
                                                userPassController.text = value;
                                              },
                                            textColor: Colors.white,
                                          ),
                                        ],
                                      )),
                                  const SizedBox(
                                    height: 25.0,
                                  ),
                                  CustomMaterialButton(
                                    color: Colors.amber,
                                    text: "Login",
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        EasyLoading.show();
                                        var response = await API.login(
                                            email: userEmailController.text
                                                .toString(),
                                            password: userPassController.text
                                                .toString(),
                                            type: 'normal',
                                        );

                                        EasyLoading.dismiss();
                                        loginResponse(response: response);
                                      } else {
                                        ShowSnackBar().showSnackBar(
                                            context, 'Enter your credentials!',
                                            duration: Duration(seconds: 5));
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotPasswordScreen(),
                                            ),
                                          ).then((value) {
                                            FullScreen.setColor(
                                                statusBarColor: Colors.black,
                                                navigationBarColor: Colors
                                                    .white);
                                          });
                                        },
                                        child: const Text(
                                          "Forgot Your password?",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            /*TextField(
                              controller: con,
                            ),*/

                            const SizedBox(
                              height: 15.0,
                            ),

                            Platform.isAndroid?
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomMaterialButtonWithIcon(
                                      color: Colors.blue,
                                      text: 'Sign In with Google',
                                      textColor: Colors.white,

                                      icon: 'assets/images/social/google.png',
                                      onPressed: () async {
                                        try {
                                          await GoogleSignIn().signOut();
                                          final googleUser = await GoogleSignIn(
                                            scopes: ['email', 'profile', 'openid',],
                                            clientId: "807297048318-jt0sl02b33qr502a47lfgqnfhpbd021o.apps.googleusercontent.com",
                                          ).signIn();
                                          print('Email: ${googleUser!.email}');
                                          if (googleUser != null) {
                                            //final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
                                            //print('idToken : ${googleAuth.idToken}');
                                            //EasyLoading.show(status: googleUser.displayName, dismissOnTap: true);
                                            // setState(() {
                                            //   con.text = googleAuth?.idToken ?? '';
                                            // });

                                            print('Email: ${googleUser.id}\nToken: ${googleUser.displayName}');

                                            EasyLoading.show();
                                            final Response? response = await API.login(
                                                email: googleUser.email,
                                                clientToken: googleUser.id.toString(),
                                                type: 'google',
                                                name: googleUser.displayName,
                                            );
                                            EasyLoading.dismiss();
                                            loginResponse(response: response);

                                          } else {
                                            EasyLoading.showError('Canceled by user',
                                                duration: Duration(seconds: 3));
                                          }
                                        } catch (exception) {
                                          EasyLoading.showError(exception.toString(),
                                              duration: Duration(seconds: 3));
                                          print('Error: ' + exception.toString());
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.05,
                                    ),
                                  ],
                                ) :
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomMaterialButtonWithIcon(
                                  color: Colors.grey,
                                  text: 'Sign In with Apple',
                                  textColor: Colors.black,
                                  icon: 'assets/images/social/apple.ico',
                                  iconColor: Colors.white,
                                  onPressed: () async {
                                    try {

                                      final credential = await SignInWithApple.getAppleIDCredential(
                                        scopes: [
                                          AppleIDAuthorizationScopes.email,
                                          AppleIDAuthorizationScopes.fullName,
                                        ],
                                      );
                                      if (credential.userIdentifier != null) {
                                        final result = await SignInWithApple.getCredentialState(credential.userIdentifier!);
                                        if(result == CredentialState.authorized){
                                          EasyLoading.show();
                                          final Response? response = await API.login(
                                              //email: credential.email?? '',
                                              email: '${credential.userIdentifier}@apple.com',
                                              appleId: '${credential.userIdentifier}@apple.com',
                                              name: '${credential.givenName} ${credential.familyName}'?? '',
                                              type: 'apple'
                                          );
                                          EasyLoading.dismiss();
                                          loginResponse(response: response);
                                        } else {
                                          EasyLoading.showError('Unauthorized',
                                              duration: Duration(seconds: 3));
                                        }
                                      } else {
                                        EasyLoading.showError('Canceled by user',
                                            duration: Duration(seconds: 3));
                                      }
                                      //credential.
                                    }catch (exception) {
                                      EasyLoading.showError(exception.toString(),
                                          duration: Duration(seconds: 3));
                                      print(
                                          'Error: ' + exception.toString());
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.05,
                                ),
                              ],
                            ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpScreen()),
                                    ).then((value) {
                                      FullScreen.setColor(
                                          statusBarColor: Colors.black,
                                          navigationBarColor: Colors.white);
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40.0,
                                    child: Text.rich(
                                      TextSpan(
                                          text: 'New User? ', style: TextStyle(color: Colors.black, fontSize: 16.0),
                                          children: [
                                            TextSpan(
                                              text: 'Sign up!', style: TextStyle(/*decoration: TextDecoration.underline,*/ color: Colors.blue, fontSize: 18.0),
                                            ),
                                          ]
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),



                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void loginResponse({Response? response}) {
    print(response.toString());
    if (response == null) {
      ShowSnackBar().showSnackBar(context,
          'No Response from Server',
          duration: Duration(seconds: 5));
    }else if (response.data['status'] == 'true') {
      Fluttertoast.showToast(
          msg: 'Login Successful!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }else if (!response.data['status'] == 'false') {
      ShowSnackBar().showSnackBar(
          context, 'Wrong credentials!',
          duration: Duration(seconds: 5));
    } else {
      print(response.toString());
      ShowSnackBar().showSnackBar(
          context, response.toString(),
          duration: Duration(seconds: 5));
    }
  }

  @override
  void dispose() {
    if(EasyLoading.isShow){
      EasyLoading.dismiss();
    }
    super.dispose();
  }
}



class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 90);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 90);
    path.lineTo(size.width, 0
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}