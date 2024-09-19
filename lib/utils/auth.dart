import 'dart:developer';

import 'package:cfood/utils/constant.dart';
import 'package:cfood/utils/prefs.dart';

class AuthHelper {
  SessionManager prefs = SessionManager();

  setUserData({
    String? token,
    String? userId,
    String? studentId,
    String? username,
    String? type,
    String? isDriver,
    String? userPhoto,
    String? merchantId,
  }) {
    prefs.setIsloggedIn('yes');
    prefs.setToken(token ?? '');
    prefs.setUserId(userId ?? '');
    prefs.setUsername(username ?? '');
    prefs.setType(type: type ?? 'reguler');
    prefs.setIsDriver(isDriver ?? 'no');
    prefs.setMerchantId(merchantId ?? '');

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
  }) {
    prefs.setEmail(email ?? '');
    prefs.setPassword(password ?? '');
  }

  setMerchantId({
    String? id,
  }) {
    prefs.setMerchantId(id ?? '0');
  }

  setUserType({
    String type = '',
  }) {
    log('$type type saved');
    prefs.setType(type: type);
  }

  setToDashboard({
    String dashboard = 'no',
  }) {
    prefs.setToDashboard(dashboard);
  }

  Future<Map<String, dynamic>> getToDashboard() async {
    String? dashboard = await SessionManager().getToDashBoard();

    return {
      'dashboard': dashboard,
    };
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
    prefs.setMerchantId('');

    AppConfig.NAME = '';
    AppConfig.EMAIL = '';
    AppConfig.USER_ID = 0;
    AppConfig.STUDENT_ID = 0;
    AppConfig.USER_TYPE = 'reguler';
    AppConfig.IS_DRIVER = false;
    AppConfig.URL_PHOTO_PROFILE = '';
    AppConfig.MERCHANT_ID = 0;
  }

  Future<void> chackUserData() async {
    String? token = await SessionManager().getToken();
    String? userId = await SessionManager().getUserId();
    String? email = await SessionManager().getEmail();
    String? username = await SessionManager().getUsername();
    String? password = await SessionManager().getPassword();
    String? type = await SessionManager().getType();
    String? isDriver = await SessionManager().getIsDriver();
    String? merchantId = await SessionManager().getMerchantId();

    log('''
      token : $token
      userid : $userId
      email : $email
      username : $username
      password : $password
      type : $type 
      isDriver : $isDriver
      merhandId : $merchantId
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
      isDriver : $isDriver
      ''');

    return {
      'token': token,
      'userid': userId,
      'email': email,
      'username': username,
      'password': password,
      'type': type,
      'isDriver': isDriver,
    };
  }

  Future<Map<String, dynamic>> getDataMerchantId() async {
    String? merchantId = await SessionManager().getMerchantId();

    log('merchantId : $merchantId');

    return {
      'merchantId': merchantId ?? '0',
    };
  }

  setAppVersion({
    String? version,
  }) {
    prefs.setAppVersion(version ?? '0.0.0');
  }

  Future<Map<String, dynamic>> getPrefVersionApp() async {
    String? appVersion = await SessionManager().getAppVersion();
    
    appVersion ??= '0.0.0';

    log('Current AppVersion : $appVersion');

    return {
      'version': appVersion, 
    };
  }
}
