

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_keys.dart';

class AppPreferences {
  static late SharedPreferences _preferences;

  static Future init() async => _preferences = await SharedPreferences.getInstance();


  ///On Boarding
  ///OnBoarding Getter
  static bool? getOnBoardShow() {
    bool? s = _preferences.getBool(AppKeys.onBoardDone) ?? true;
    return s!;
  }

  ///OnBoarding Setter
  static void setOnBoardShow(bool show){
    _preferences.setBool(AppKeys.onBoardDone, show);
  }



  ///User Display Name getter
  static bool? getUser() {
    bool? s = _preferences.getBool(AppKeys.isUserLogin) ?? false;
    return s!;
  }

  ///User Display Name getter
  static String getDisplayName() {
    String s = _preferences.getString(AppKeys.userDisplayName) ?? '';
    return s;
  }

  ///User Display Name Setter
  static void setDisplayName( String displayName){
    _preferences.setString(AppKeys.userDisplayName, displayName);
  }

  ///User Email getter
  static String getEmailAddress() {
    String s = _preferences.getString(AppKeys.userEmail) ?? 'Sorry';
    return s;
  }

  ///User Email Setter
  static void setEmailAddress( String email){
    _preferences.setString(AppKeys.userEmail, email);
  }

  static void saveCredentials({
    required String email,
    required String token,
    required String name,
    required String photoUrl,}) {
    _preferences.setString(AppKeys.userEmail, email);
    _preferences.setString(AppKeys.userToken, token);
    _preferences.setString(AppKeys.userDisplayName, name);
    _preferences.setString(AppKeys.userPhotoUrl, photoUrl);

    //_preferences.setString(AppKeys.userDisplayName, displayName);
    _preferences.setBool(AppKeys.isUserLogin, true);
  }

  static void clearCredentials() {
    _preferences.clear();
    _preferences.setBool(AppKeys.onBoardDone, false);
  }

  static void setToken(String token) {
    _preferences.setString(AppKeys.userToken, '');
  }
  static String getToken() {
    String s = _preferences.getString(AppKeys.userToken) ?? '';
    return s;
  }
  static bool getIsUserLogin() {
    bool s = _preferences.getBool(AppKeys.isUserLogin) ?? false;
    return s;
  }

  static String getPhotoUrl() {
    String s = _preferences.getString(AppKeys.userPhotoUrl) ?? '';
    return s;
  }
}
