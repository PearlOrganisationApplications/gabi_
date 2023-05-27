

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import 'nospace_formatter.dart';

class CustomTextFormFieldEmail extends StatefulWidget {
  final onValueChanged;
  final Color? textColor;
  const CustomTextFormFieldEmail({Key? key, required Function(String value) this.onValueChanged, this.textColor}) : super(key: key);

  @override
  State<CustomTextFormFieldEmail> createState() => _CustomTextFormFieldEmailState();
}

class _CustomTextFormFieldEmailState extends State<CustomTextFormFieldEmail> {

  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusScopeNode currentFocus =
        FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      ///mainCode
      onChanged: widget.onValueChanged(emailController.text),
      inputFormatters: [NoSpaceFormatter()],
      //autofocus: true,
      controller: emailController,
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: TextStyle(color: widget.textColor??Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        prefixIconColor: Colors.orange,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 2, color: Colors.amber),
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
        label: const Text('Email address'),
        hintText: 'Enter your email address',
        labelStyle:
        const TextStyle(color: Colors.amber),
        hintStyle: const TextStyle(
          color: Colors.amber,
        ),
      ),
      validator: (val) =>
      !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
          .hasMatch(val!)
          ? 'Enter an email'
          : null,
    );
  }
}



class CustomTextFormFieldPassword extends StatefulWidget {
  final onValueChanged;
  final Color? textColor;
  const CustomTextFormFieldPassword({Key? key, required Function(String value) this.onValueChanged, this.textColor}) : super(key: key);

  @override
  State<CustomTextFormFieldPassword> createState() => _CustomTextFormFieldPasswordState();
}

class _CustomTextFormFieldPasswordState extends State<CustomTextFormFieldPassword> {

  TextEditingController passController = TextEditingController();
  bool _obscuredPassword = true;

  void _toggleObscured() {
    setState(() {
      _obscuredPassword = !_obscuredPassword;

    });
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      onTapOutside: (event) {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      controller: passController,
      onChanged: widget.onValueChanged(passController.text),
      obscureText: _obscuredPassword,
      keyboardType: TextInputType.visiblePassword,
      inputFormatters: [NoSpaceFormatter()],
      textInputAction: TextInputAction.done,
      style: TextStyle(color: widget.textColor??Colors.black),
      decoration: InputDecoration(
        suffixIconColor: _obscuredPassword ? Colors.grey : Colors.red,
        prefixIcon: Icon(Icons.lock_rounded),
        prefixIconColor: Colors.orange,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
          child: GestureDetector(
            onTap: _toggleObscured,
            child: Icon(
              _obscuredPassword
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              size: 24,
            ),
          ),
        ),
        label: const Text(
          'Password',
        ),
        labelStyle: const TextStyle(
          color: Colors.amber,
        ),
        hintText: 'Enter your password',
        hintStyle: const TextStyle(
          color: Colors.amber,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 2, color: Colors.amber),
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
      ),
      validator: (val) => val!.isEmpty
          ? 'Please Enter Password'
          : null,
    );
  }
}


class CustomTextFormFieldNewPassword extends StatefulWidget {
  final onValueChanged;
  const CustomTextFormFieldNewPassword({Key? key, required Function(String value) this.onValueChanged}) : super(key: key);

  @override
  State<CustomTextFormFieldNewPassword> createState() => _CustomTextFormFieldNewPassword();
}

class _CustomTextFormFieldNewPassword extends State<CustomTextFormFieldNewPassword> {

  TextEditingController passController = TextEditingController();
  bool _obscuredPassword = true;

  void _toggleObscured() {
    setState(() {
      _obscuredPassword = !_obscuredPassword;

    });
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      onTapOutside: (event) {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      controller: passController,
      onChanged: widget.onValueChanged(passController.text),
      obscureText: _obscuredPassword,
      style: TextStyle(color: AppColors.textColor),
      cursorColor: AppColors.cursorColor,
      keyboardType: TextInputType.visiblePassword,
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
            onTap: () => _toggleObscured(),
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
    );
  }
}


class CustomTextFormFieldCPassword extends StatefulWidget {
  final onValueChanged;
  const CustomTextFormFieldCPassword({Key? key, required Function(String value) this.onValueChanged, required String onTap,}) : super(key: key);

  @override
  State<CustomTextFormFieldCPassword> createState() => _CustomTextFormFieldCPassword();
}

class _CustomTextFormFieldCPassword extends State<CustomTextFormFieldCPassword> {

  TextEditingController passController = TextEditingController();
  bool _obscuredPassword = true;

  void _toggleObscured() {
    setState(() {
      _obscuredPassword = !_obscuredPassword;

    });
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      onTapOutside: (event) {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      controller: passController,
      onChanged: widget.onValueChanged(passController.text),
      obscureText: _obscuredPassword,

      style: TextStyle(color: AppColors.textColor),
      cursorColor: AppColors.cursorColor,
      keyboardType: TextInputType.visiblePassword,
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
        label: const Text('Confirm New Password', style: TextStyle(color: AppColors.textLabelColor),),
        hintText: 'passWord@1',
        prefixIcon: Icon(Icons.lock_rounded, size: 24),
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
          child: GestureDetector(
            onTap: () => _toggleObscured(),
            child: Icon(
              _obscuredPassword
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
      val!.isEmpty ? 'Confirm your New Password' : val != ''? 'Password doesn\'t match' : null ,
    );
  }
}


class CustomTextFormFieldName extends StatefulWidget {
  const CustomTextFormFieldName({Key? key}) : super(key: key);

  @override
  State<CustomTextFormFieldName> createState() => _CustomTextFormFieldNameState();
}

class _CustomTextFormFieldNameState extends State<CustomTextFormFieldName> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


