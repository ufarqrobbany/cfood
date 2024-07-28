import 'dart:developer';

import 'package:cfood/utils/constant.dart';
import 'package:cfood/utils/prefs.dart';

class AuthHelper {
  SessionManager prefs = SessionManager();

  setUserData(
    {String? token,
    String? userId,
    String? studentId,
    String? username,
    String? type,
    String? isDriver,
    String? userPhoto,
    }
  ) {
    prefs.setIsloggedIn('yes');
    prefs.setToken(token ?? '');
    prefs.setUserId(userId ?? '');
    prefs.setUsername(username ?? '');
    prefs.setType(type: type ?? 'reguler');
    prefs.setIsDriver(isDriver ?? 'no');
    
    // AppConfig.NAME = username!;
    // AppConfig.USER_ID = int.parse(userId!);
    // AppConfig.STUDENT_ID = int.parse(studentId!);
    // AppConfig.USER_TYPE = type ?? 'reguler';
    // AppConfig.IS_DRIVER = isDriver == 'no' ? false : true;
    // AppConfig.URL_PHOTO_PROFILE = '${AppConfig.URL_PHOTO_PROFILE}$userPhoto';
  }

  setEmailPassword({
    String? email,
    String? password,
  }){
    prefs.setEmail(email ?? '');
    prefs.setPassword(password ?? '');
  }

  clearUserData() {
    prefs.setIsloggedIn('no');
    prefs.setToken('');
    prefs.setUserId('');
    prefs.setEmail('');
    prefs.setUsername('');
    prefs.setPassword('');
    prefs.setType(type: '');
    prefs.setIsDriver('no');

    AppConfig.NAME = '';
    AppConfig.EMAIL = '';
    AppConfig.USER_ID = 0;
    AppConfig.STUDENT_ID = 0;
    AppConfig.USER_TYPE = 'reguler';
    AppConfig.IS_DRIVER = false;
    AppConfig.URL_PHOTO_PROFILE = '';
  }

  Future<void> chackUserData() async {
    String? token = await SessionManager().getToken();
    String? userId = await SessionManager().getUserId();
    String? email = await SessionManager().getEmail();
    String? username = await SessionManager().getUsername();
    String? password = await SessionManager().getPassword();
    String? type = await SessionManager().getType();
    String? isDriver = await SessionManager().getIsDriver();

    log('''
      token : $token
      userid : $userId
      email : $email
      username : $username
      password : $password
      type : $type 
      isDriver : $isDriver
      ''');

  }

  Future<Map<String, dynamic>> getkUserData() async {
    String? token = await SessionManager().getToken();
    String? userId = await SessionManager().getUserId();
    String? email = await SessionManager().getEmail();
    String? username = await SessionManager().getUsername();
    String? password = await SessionManager().getPassword();
    String? type = await SessionManager().getType();
    String? isDriver = await SessionManager().getIsDriver();

    log('''
      token : $token
      userid : $userId
      email : $email
      username : $username
      password : $password
      type : $type
      isDriver: $isDriver
      ''');

    return {
     'token' : token,
      'userid' : userId,
      'email' : email,
      'username' : username,
      'password' : password,
      'type': type,
      'isDriver': isDriver,
    };
  }
}
