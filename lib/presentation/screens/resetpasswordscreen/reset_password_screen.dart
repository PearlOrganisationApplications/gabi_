


import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../app/api/app_api.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_images.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/constants/constant.dart';
import '../../widgets/custom_materialbutton.dart';
import '../../widgets/custom_textformfield.dart';
import '../../widgets/nospace_formatter.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscuredPassword = true;
  bool _obscuredCPassword = true;

  void _toggleObscured(int i) {
    setState(() {
      if(i == 0) {
        _obscuredPassword = !_obscuredPassword;
      }else{
        _obscuredCPassword = !_obscuredCPassword;
      }
    });
  }

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cpasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Text('Set New Password', style: TextStyle(color: Colors.white),),
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
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 15.0,
                  right: 15.0,
                ),
                child: TextFormField(
                  maxLines: 1,
                  onTapOutside: (event) {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  controller: _passwordController,
                  //onChanged: widget.onValueChanged(passController.text),
                  obscureText: _obscuredPassword,
                  style: TextStyle(color: AppColors.textColor),
                  cursorColor: AppColors.cursorColor,
                  keyboardType: TextInputType.visiblePassword,
                  inputFormatters: [NoSpaceFormatter()],
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    prefixIconColor: Colors.orange,
                    suffixIconColor: _obscuredPassword ? Colors.grey : Colors.red,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                    prefixIcon: Icon(Icons.lock_rounded, size: 24),
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
                    label: const Text('New Password', style: TextStyle(color: AppColors.textLabelColor),),
                    hintText: 'passWord@1',
                    labelStyle: const TextStyle(color: AppColors.textHintColor),
                    hintStyle: const TextStyle(
                      color: Colors.black26,
                    ),
                  ),
                  validator: (val) =>
                  val!.isEmpty ? 'Enter your new password' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 15.0,
                  right: 15.0,
                ),
                child: TextFormField(
                  maxLines: 1,
                  onTapOutside: (event) {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  controller: _cpasswordController,
                  //onChanged: widget.onValueChanged(passController.text),
                  obscureText: _obscuredCPassword,

                  style: TextStyle(color: AppColors.textColor),
                  cursorColor: AppColors.cursorColor,
                  keyboardType: TextInputType.visiblePassword,
                  inputFormatters: [NoSpaceFormatter()],
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    prefixIconColor: Colors.orange,
                    suffixIconColor: _obscuredCPassword ? Colors.grey : Colors.red,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                    label: const Text('Confirm New Password', style: TextStyle(color: AppColors.textLabelColor),),
                    hintText: 'passWord@1',
                    prefixIcon: Icon(Icons.lock_rounded, size: 24),
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
                    labelStyle: const TextStyle(color: AppColors.textHintColor),
                    hintStyle: const TextStyle(
                      color: Colors.black26,
                    ),
                  ),
                  validator: (val) =>
                  val!.isEmpty ? 'Confirm your New Password' : val != _passwordController.text? 'Password doesn\'t match' : null ,
                ),

                /*TextFormField(
                  *//*onTap: () {

                        },*//*
                  onTapOutside: (event) {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  autofocus: false,
                  controller: _cpasswordController,

                ),*/
              ),




              /*TextField(
                controller: userpasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _obscured,
                focusNode: textFieldFocusNode,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  //Hides label on focus or if filled
                  labelText: "Password",
                  filled: true,
                  // Needed for adding a fill color
                  //fillColor: Colors.grey.shade800,
                  isDense: true,
                  // Reduces height a bit
                  border: OutlineInputBorder(
                    // borderSide: BorderSide.none,              No border
                    borderRadius:
                    BorderRadius.circular(12), // Apply corner radius
                  ),
                  prefixIcon: Icon(Icons.lock_rounded, size: 24),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: _toggleObscured,
                      child: Icon(
                        _obscured
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),*/
              const SizedBox(
                height: 25.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: CustomMaterialButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      EasyLoading.show();
                      final Response? response = await API.changePassword(newPassword: _passwordController.text);
                      EasyLoading.dismiss();
                      if(response!.statusMessage == 'successful'){
                        EasyLoading.showError('Password changed successfully.', duration: Duration(seconds: 3));
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen(),));
                      }else{
                        EasyLoading.showToast(response.statusMessage.toString(), duration: Duration(seconds: 3));
                      }
                    }
                  },
                  color: Colors.orange,
                  textColor: Colors.white,
                  text: SUBMIT,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
