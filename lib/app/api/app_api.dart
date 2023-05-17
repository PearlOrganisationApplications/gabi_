


import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../preferences/app_preferences.dart';

class API {
  static const String _base_url = 'https://test.pearl-developer.com/gabi/public/api/';


  static final _dio = Dio(BaseOptions(
    baseUrl: _base_url,
    //connectTimeout: 5000,
    //receiveTimeout: 3000,
    //headers: {'Authorization': 'Bearer 123456'},
    contentType: 'application/json',
  ));

  static const String _sign_up_url = 'user/signup';
  static const String _login_url = 'user/signin';
  static const String _sigin_with_options_url = 'user/other-login';
  static const String _forget_password_url = 'user/forgot-password';
  static const String _verify_otp_url = 'user/forgot-password';
  static const String _change_password_url = 'user/forgot-password';
  static const String _trendings = '/user/trendings';
  static const String _recentlyPlayed = '/user/songs';


  static Future<Response?> signUp({required String name, required String email, required String password, File? imageFile}) async {
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    String? base64Image;
    if(imageFile != null) {
      final bytes = await File(imageFile.path).readAsBytes();
      base64Image =  base64.encode(bytes);
      /*List<int> imageBytes = await imageFile.readAsBytesSync();
        base64Image = base64Encode(imageBytes);*/
      print(base64Image);
    }
    try {
/*
      //List<int>? compressedImageList;
      if(imageFile != null){
        */
/*Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(
          imageFile.path,
          quality: 50,
        );
        compressedImageList = compressedImage!.cast<int>();*/
      /*


      }

*/



      // Create a FormData object for sending the data and image
      FormData formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'user_profile': base64Image,
      });

      // Send the POST request with the FormData and receive the response

      Response response = await _dio.post(_sign_up_url, data: formData,);
      print(response.data);
      await _saveUserData(response);
      return response;
    } on DioError catch (e) {
      print(e.toString());
      if (e.response?.statusCode == 404) {
        print(e.response?.statusCode);
      } else {
        print(e.message);
        //print(e.request);
      }
      return e.response;
    }
  }

  static Future<Response?> login({required String email, required String password}) async {
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };


    /*dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };*/

    try {
      Response? response = await _dio.post(
          _login_url, data: jsonEncode({'email': email, 'password': password}));
      await _saveUserData(response);

      return response;
    } on DioError catch (e) {
      print(e.response?.statusCode);

      print(e.toString());
      if (e.response?.statusCode == 404) {
        print(e.response?.statusCode);
      } else {
        print(e.message);
        //print(e.request);
      }
      return e.response;
    }
  }

  static Future<Response?> trending() async {
    try {
      Response response = await _dio.get(_trendings);
      return response;
    } on DioError catch (e) {
      print(e.response?.statusCode);

      print(e.toString());
      if (e.response?.statusCode == 404) {
        print(e.response?.statusCode);
      } else {
        print(e.message);
        //print(e.request);
      }
      return e.response;
    }
  }


  static Future<Response?> recentlyPlayed() async {
    try {
      Response response = await _dio.get(_recentlyPlayed);
      return response;
    } on DioError catch (e) {
      print(e.response?.statusCode);

      print(e.toString());
      if (e.response?.statusCode == 404) {
        print(e.response?.statusCode);
      } else {
        print(e.message);
        //print(e.request);
      }
      return e.response;
    }
  }

  static Future<Response?> signInWithOptions({required String email, required String idToken, required String type, required String name}) async {
    try {
      Response response = await _dio.post(_sigin_with_options_url,
          data: jsonEncode({'email': email, 'client_token': idToken, 'type' : type, 'name' : name}));
      return response;
    } on DioError catch (e) {
      print(e.response?.statusCode);

      print(e.toString());
      if (e.response?.statusCode == 404) {
        print(e.response?.statusCode);
      } else {
        print(e.message);
        //print(e.request);
      }
      return e.response;
    }
  }


  static Future<Response?> forgetPassword({required String email}) async {
    try {
      Response response = await _dio.post(_forget_password_url, data: jsonEncode({'email': email}));
      return response;
    } on DioError catch (e) {
      print(e.response?.statusCode);

      print(e.toString());
      if (e.response?.statusCode == 404) {
        print(e.response?.statusCode);
      } else {
        print(e.message);
        //print(e.request);
      }
      return e.response;
    }
  }
  static Future<Response?> verifyOtp({required String otp}) async {
    try {
      Response response = await _dio.post(_verify_otp_url, data: jsonEncode({'otp': int.parse(otp)}));
      return response;
    } on DioError catch (e) {
      print(e.response?.statusCode);

      print(e.toString());
      if (e.response?.statusCode == 404) {
        print(e.response?.statusCode);
      } else {
        print(e.message);
        //print(e.request);
      }
      return e.response;
    }
  }
  static Future<Response?> changePassword({required String newPassword}) async {
    try {
      Response response = await _dio.post(_verify_otp_url, data: jsonEncode({'new_password': newPassword}));
      return response;
    } on DioError catch (e) {
      print(e.response?.statusCode);

      print(e.toString());
      if (e.response?.statusCode == 404) {
        print(e.response?.statusCode);
      } else {
        print(e.message);
        //print(e.request);
      }
      return e.response;
    }
  }

/*  static Future<void> downloadProfileImage({required String url}) async {
    final directory = await getApplicationSupportDirectory();
    final imagePath = '${directory.path}/';
    // Copy the image file to the internal storage
    //await imageFile.copy(imagePath);

    final Dio dio = Dio();
    final response = await dio.download(url, imagePath);
    EasyLoading.showToast(imagePath, duration: Duration(seconds: 2));

  }*/
  static Future<void> _saveUserData(Response response) async {


    AppPreferences.saveCredentials(
      token: response.data['token'],
      email: response.data['user']['email'],
      name: response.data['user']['name'],
      photoUrl: response.data['user']['user_profile'] ?? '',
    );
    /*if(response.data['user']['user_profile'] != null || response.data['user']['user_profile'] != '') {
      downloadProfileImage(url: response.data['user']['user_profile']);
    }*/

  }

}