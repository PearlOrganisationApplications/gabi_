
import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gabi/app/api/app_api.dart';
import 'package:gabi/customwidgets/snackbar.dart';
import 'package:gabi/presentation/screens/homescreen/home_page.dart';
import 'package:gabi/presentation/screens/signupscreen/signup_screen.dart';
import 'package:gabi/presentation/widgets/custom_materialbutton.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
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
  TextEditingController con = TextEditingController();
  TextEditingController userPassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                                              }),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          CustomTextFormFieldPassword(
                                              onValueChanged: (value) {
                                                userPassController.text = value;
                                              }),
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
                                                .toString());

                                        EasyLoading.dismiss();
                                        if (response!.statusCode == 200) {
                                          Fluttertoast.showToast(
                                              msg: 'Login Successful!');
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Homepage(),
                                            ),
                                          );
                                        } else if (response == null) {
                                          print('Response is null');
                                          ShowSnackBar().showSnackBar(context,
                                              'No Response from Server',
                                              duration: Duration(seconds: 5));
                                        } else {
                                          print(response.toString());
                                          ShowSnackBar().showSnackBar(
                                              context, response.toString(),
                                              duration: Duration(seconds: 5));
                                        }
                                      } else {
                                        ShowSnackBar().showSnackBar(
                                            context, 'Enter your credentials!',
                                            duration: Duration(seconds: 5));
                                      }
                                    },
                                  ),

                                  TextField(
                                    controller: con,
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

                            const SizedBox(
                              height: 15.0,
                            ),
                            CustomMaterialButtonWithIcon(
                              color: Colors.blue,
                              text: 'Sign In with Google',
                              textColor: Colors.white,
                              icon: 'assets/images/social/google.png',
                              onPressed: () async {
                                try {
                                  final googleUser = await GoogleSignIn(
                                    scopes: ['email', 'profile', 'openid',  'https://www.googleapis.com/auth/contacts.readonly',
                                    ],
                                    clientId: "807297048318-jt0sl02b33qr502a47lfgqnfhpbd021o.apps.googleusercontent.com",

                                    //signInOption: SignInOption.standard
                                  ).signIn();

                                  if (googleUser != null) {
                                    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
                                    EasyLoading.show(status: '${googleUser!.email}\n${googleAuth.idToken}', dismissOnTap: true);

                                    print('idToken : ${googleAuth.idToken}');

                                    final Response? response = await API
                                        .signInWithOptions(
                                        email: googleUser.email,
                                        idToken: googleAuth.idToken?? '',
                                      name: googleUser.displayName?? '',
                                      type: 'google'
                                    );

                                    if (response!.statusCode == 201 || response!.statusCode == 200) {
                                      print(response.data);
                                      EasyLoading.showError('Login Successful.',
                                          duration: Duration(seconds: 3));
                                      Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(
                                          builder: (context) => Homepage(),), (
                                            route) => false,);
                                    } else {
                                      EasyLoading.showToast(response.data,
                                          duration: Duration(seconds: 3));
                                    }
                                  } else {
                                    EasyLoading.showError('Canceled by user',
                                        duration: Duration(seconds: 3));
                                  }
                                } catch (exception) {
                                  EasyLoading.showError(exception.toString(),
                                      duration: Duration(seconds: 3));
                                  print(
                                      'error error - ' + exception.toString());
                                }
                              },
                            ),
                            SizedBox(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.05,
                            ),

                            if(!Platform.isAndroid)
                              Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomMaterialButtonWithIcon(
                                  color: Colors.grey,
                                  text: 'Sign In with Apple',
                                  textColor: Colors.black,
                                  icon: 'assets/images/social/apple.ico',
                                  iconColor: Colors.white,
                                  onPressed: ()
                                  async {
                                    try {

                                      /*final apple_credentials = await TheAppleSignIn.performRequests([const AppleIdRequest(requestedScopes: [
                                            Scope.email,
                                            Scope.fullName,
                                          ])]);*/
                                      final apple_credentials = await SignInWithApple.getAppleIDCredential(
                                        scopes: [
                                          AppleIDAuthorizationScopes.email,
                                          AppleIDAuthorizationScopes.fullName,
                                        ],
                                      );
                                      EasyLoading.show(status: '${apple_credentials!.email}\n${apple_credentials.identityToken}', dismissOnTap: true);



                                      // 2. check the result
                                      /*switch (apple_credentials.status) {
                                        case AuthorizationStatus.authorized:

                                          break;
                                        case AuthorizationStatus.error:
                                          throw PlatformException(
                                            code: 'ERROR_AUTHORIZATION_DENIED',
                                            message: apple_credentials.error.toString(),
                                          );

                                        case AuthorizationStatus.cancelled:
                                          throw PlatformException(
                                            code: 'ERROR_ABORTED_BY_USER',
                                            message: 'Sign in aborted by user',
                                          );
                                        default:
                                          throw UnimplementedError();
                                      };*/




                                      if (apple_credentials.identityToken != null) {
                                        EasyLoading.show();
                                        final Response? response = await API
                                            .signInWithOptions(
                                            email: apple_credentials.email?? '',
                                            idToken: apple_credentials.identityToken.toString()?? '',
                                            name: '${apple_credentials.givenName} ${apple_credentials.familyName}'?? '',
                                            type: 'apple'
                                        );
                                        setState(() {
                                          con.text = apple_credentials.identityToken.toString()??'null';
                                        });
                                        EasyLoading.dismiss();

                                        if (response!.statusCode == 201 || response!.statusCode == 200) {
                                          print(response.data);
                                          EasyLoading.showError('Login Successful.',
                                              duration: Duration(seconds: 3));
                                          Navigator.pushAndRemoveUntil(context,
                                            MaterialPageRoute(
                                              builder: (context) => Homepage(),), (
                                                route) => false,);
                                        } else {
                                          EasyLoading.showToast(response.data,
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
                                          'error error - ' + exception.toString());
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
                            TextButton(
                              onPressed: () {
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
                              child: const Text(
                                "New User? Sign up!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                ),
                              ),
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