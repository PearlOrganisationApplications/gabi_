


import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gabi/app/models/channel_model.dart';
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
    headers: {
      'Authorization': 'Bearer ${AppPreferences.getToken()}',
      'Accept': 'application/json',
    },
  ));

  static const String _sign_up_url = 'user/signup';
  static const String _login_url = 'user/signin';
  static const String _send_otp_url = 'user/forgot-password';
  static const String _verify_otp_url = 'user/verify-otp';
  static const String _change_password_url = 'user/change-password';
  static const String _trending_songs_url = '/user/trendings';
  static const String _all_songs_url = '/user/songs';
  static const String _add_recents_songs_url = '/user/recents';
  static const String _get_recents_songs_url = '/user/recent-songslist';
  static const String  _channel_create_url = '/user/channel';
  static const String _channel_end_url = '/user/channelend';
  static const String _channels_list_url = '/user/channel-list';
  static const String _get_profile_url = '/user/getuserprofile';
  static const String _delete_profile_url = '/user/delete-account';
  static const String _update_profile_url = '/user/updateprofile';
  static const String _customer_support_url = '/user/queries';
  static const String _get_banners_url = '/user/banners';

  static Future<Response?> updateProfile({required String name, File? imageFile, required int profileStatus}) async {
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
    }
    try {
      // Create a FormData object for sending the data and image
      FormData formData = FormData.fromMap({
        'name': name,
        'user_profile': base64Image,
        'profile_status': profileStatus
      });

      // Send the POST request with the FormData and receive the response

      Options options = Options(
        headers: {
          'Authorization': 'Bearer ${AppPreferences.getToken()}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      Response response = await _dio.post(_update_profile_url, data: formData, options: options);
      print(response.toString());
      if(response.data['status'] == 'true'){
        print('zzzz');

        Response response2 = await _dio.get(_get_profile_url, options: options);
        print(response2);
        if(response2.data['status'] == 'true'){

          await _saveUserData(response2);
        }
      }
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
  static Future<Response?> login({String? email, String? password, required String type, String? clientToken, String? appleId, String? name}) async {
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };


    /*dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };*/

    try {
      Response response = await _dio.post(
          _login_url, data: jsonEncode(
          {
            'email': email??'',
            'password': password??'',
            'client_token': clientToken??'',
            'apple_id': appleId??'',
            'type': type,
            'name': name??'',
          }));

      if(response.data['status'] == true){
        await _saveUserData(response);
      }

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
  static Future<Response?> sendOtp({required String email}) async {
    try {
      Response response = await _dio.post(_send_otp_url, data: jsonEncode({'email': email}));
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
      if(response.data['success'] == 'Successfully'){
        await _saveUserData(response);
      }
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
  static Future<Response?> changePassword({required oldPassword, required String newPassword}) async {
    try {

      Options options = Options(
        headers: {
          'Authorization': 'Bearer ${AppPreferences.getToken()}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      Response response = await _dio.post(_change_password_url, data: jsonEncode(
          {'old_password' : oldPassword, 'password': newPassword}), options: options);
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
  static Future<Response?> trendingSongs() async {
    try {
      Response response = await _dio.get(_trending_songs_url);
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
  static Future<Response?> getBanners() async {
    try {

      Options options = Options(
        headers: {
          'Authorization': 'Bearer ${AppPreferences.getToken()}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      Response response = await _dio.get(_get_banners_url, options: options);
      return response;
    } on DioError catch (e) {
      print(e.response?.statusCode);

      print(e.toString());
      return e.response;
    }
  }
  static Future<Response?> getRecentsSongs() async {
    try {

      Options options = Options(
        headers: {
          'Authorization': 'Bearer ${AppPreferences.getToken()}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      Response response = await _dio.get(_get_recents_songs_url, options: options);
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
  static Future addRecentSong({required int id}) async {
    try {

      Options options = Options(
        headers: {
          'Authorization': 'Bearer ${AppPreferences.getToken()}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      await _dio.post(_add_recents_songs_url,data: jsonEncode({'song_id': id,}), options: options);
    } on DioError catch (e) {
      print(e.response?.statusCode);

      print(e.toString());
      if (e.response?.statusCode == 404) {
        print(e.response?.statusCode);
      } else {
        print(e.message);
        //print(e.request);
      }
    }
  }
  static Future<Response?> allSongs() async {
    try {
      Response response = await _dio.get(_all_songs_url);
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
  static Future<Response?> getUserProfile() async {
    try {

      Options options = Options(
        headers: {
          'Authorization': 'Bearer ${AppPreferences.getToken()}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      Response response = await _dio.get(_get_profile_url, options: options);
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
  static Future<Response?> deleteUserAccount() async {
    try {

      Options options = Options(
        headers: {
          'Authorization': 'Bearer ${AppPreferences.getToken()}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      Response response = await _dio.post(_delete_profile_url, options: options);
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
  static Future<Response?> customerSupport({required String subject, required String message}) async {


    try {

      Options options = Options(
        headers: {
          'Authorization': 'Bearer ${AppPreferences.getToken()}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      Response response = await _dio.post(_customer_support_url,
        data: jsonEncode({'subject': subject, 'description': message,}),
        options: options
      );
      print(response.data);
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




/*  static Future<void> downloadProfileImage({required String url}) async {
    final directory = await getApplicationSupportDirectory();
    final imagePath = '${directory.path}/';
    // Copy the image file to the internal storage
    //await imageFile.copy(imagePath);

    final Dio dio = Dio();
    final response = await dio.download(url, imagePath);
    EasyLoading.showToast(imagePath, duration: Duration(seconds: 2));

  }*/



  static Future<Response?> connectChannel({required String channelName, required String userType}) async {
    try {

      Options options = Options(
        headers: {
          'Authorization': 'Bearer ${AppPreferences.getToken()}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      Response response = await _dio.post(_channel_create_url,data: jsonEncode({'channel_name': channelName, 'user_type': userType,}), options: options);
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
  static Future<bool> disposeChannel({required int channelId, required String userType}) async {
    try {

      Options options = Options(
        headers: {
          'Authorization': 'Bearer ${AppPreferences.getToken()}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      Response response = await _dio.post(_channel_end_url,data: jsonEncode({'channel_id': channelId,'user_type': userType}), options: options);

      print('>-----');
      print(response.toString());
      if(response.data['status'] == 'true'){
        return true;
      }
    } on DioError catch (e) {
      print(e.response?.statusCode);

      print(e.toString());
      if (e.response?.statusCode == 404) {
        print(e.response?.statusCode);
      } else {
        print(e.message);
        //print(e.request);
      }
    }
    return false;
  }
  static Future<List<ChannelDataModel>> channelsList() async {
    List<ChannelDataModel> channels = [];
    try {

      Options options = Options(
        headers: {
          'Authorization': 'Bearer ${AppPreferences.getToken()}',
        },
      );
      Response response = await _dio.get(_channels_list_url, options: options);
      print(response.toString());
      if(response.data['status'] == 'true'){
        for(var item in response.data['data']) {
          channels.add(ChannelDataModel(
            item['user_id'],
            item['channel_name'],
            item['status'],
            item['created_at'],
            item['id'],
          ));
        }
      }

    } on DioError catch (e) {
      print(e.response?.statusCode);

      print(e.toString());
      if (e.response?.statusCode == 404) {
        print(e.response?.statusCode);
      } else {
        print(e.message);
        //print(e.request);
      }
    }
    return channels;



  }


  static Future<void> _saveUserData(Response response) async {

    print(response.toString());
    AppPreferences.saveCredentials(
      token: response.data['token']??AppPreferences.getToken(),
      email: response.data['user']['email']??AppPreferences.getEmailAddress(),
      name: response.data['user']['name']?? AppPreferences.getDisplayName(),
      photoUrl: response.data['user']['user_profile'] ?? '',
    );
    /*if(response.data['user']['user_profile'] != null || response.data['user']['user_profile'] != '') {
      downloadProfileImage(url: response.data['user']['user_profile']);
    }*/

  }

}