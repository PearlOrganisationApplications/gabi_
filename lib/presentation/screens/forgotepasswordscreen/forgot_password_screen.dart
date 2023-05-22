import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gabi/app/constants/app_strings.dart';
import 'package:gabi/app/constants/constant.dart';
import 'package:gabi/presentation/widgets/custom_textformfield.dart';

import '../../../app/api/app_api.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_images.dart';
import '../../../utils/systemuioverlay/full_screen.dart';
import '../../widgets/custom_materialbutton.dart';
import '../../widgets/nospace_formatter.dart';
import '../resetpasswordscreen/reset_password_screen.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool _verifyVisible = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //FullScreen.color(color: AppColors.themeColor2);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Text('Forget Password', style: TextStyle(color: Colors.white),),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
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

      body: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 30.0),
                width: MediaQuery.of(context).size.width * 0.4,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    child: Image.asset(FORGOT_PASSWORD_IMG,)),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 50.0,
                  left: MediaQuery.of(context).size.width * 0.04,
                  right: MediaQuery.of(context).size.width * 0.04,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 1.0,
                        child: Container(color: Colors.black, margin: EdgeInsets.only(left: 16.0),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(_verifyVisible? 'Enter Otp sent to your Email\n${_emailController.text}' : 'Tell us your email',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 2,),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 1.0,
                        child: Container(margin: EdgeInsets.only(right: 16.0),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border(top: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Visibility(
                visible: !_verifyVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                          key: _formKey,
                          child: CustomTextFormFieldEmail(
                            onValueChanged: (value) {
                              _emailController.text = value;
                            },
                          )
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      CustomMaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            EasyLoading.show();
                            final Response? response = await API.forgetPassword(email: _emailController.text);
                            EasyLoading.dismiss();
                            if(response!.data['message'] == 'mail sent'){
                              EasyLoading.showError('OTP Sent to your email.', duration: Duration(seconds: 3));
                              setState(() {
                                _verifyVisible = true;
                              });
                            }else{
                              EasyLoading.showToast(response.statusMessage.toString(), duration: Duration(seconds: 3));
                            }
                          }
                        },
                        color: Colors.orange,
                        text: SUBMIT,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _verifyVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                          key: _formKey2,
                          child: TextFormField(
                            onTapOutside: (event) {
                              FocusScopeNode currentFocus =
                              FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            ///mainCode
                            inputFormatters: [NoSpaceFormatter()],
                            //autofocus: true,
                            controller: _otpController,
                            maxLines: 1,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 30.0,),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Colors.amber),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Colors.grey),
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
                              hintText: 'Enter OTP',
                              hintStyle: TextStyle(color: Colors.amber),
                            ),
                            validator: (val) =>
                            val!.isEmpty
                                ? 'Enter Otp sent to your email'
                                : null,
                          )
                      ),
                      CustomMaterialButton(
                        onPressed: () async {
                          if (_formKey2.currentState!.validate()) {
                            EasyLoading.show();
                            final Response? response = await API.verifyOtp(otp: _otpController.text);
                            EasyLoading.dismiss();
                            if(response!.statusMessage == 'successful'){
                              EasyLoading.showError('Otp Verified successfully.', duration: Duration(seconds: 3));
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen(),));
                            }else{
                              EasyLoading.showToast(response.statusMessage.toString(), duration: Duration(seconds: 3));
                            }
                          }
                        },
                        color: Colors.orange,
                        text: VERIFY_OTP,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

