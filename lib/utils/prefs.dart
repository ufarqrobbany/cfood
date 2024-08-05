import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  // TOKEN
  Future<void> setToken(String token) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('token', token);
  }

  Future<String?> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    return token ?? '';
  }

  // USER ID
  Future<void> setUserId(String userId) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('user_id', userId);
  }

  Future<String?> getUserId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = pref.getString('user_id');
    return userId ?? '';
  }

  // USERNAME
  Future<void> setUsername(String username) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('username', username);
  }

  Future<String?> getUsername() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? username = pref.getString('username');
    return username ?? '';
  }

  // PASSWORD
  Future<void> setPassword(String password) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('password', password);
  }

  Future<String?> getPassword() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? password = pref.getString('password');
    return password ?? '';
  }

  // EMAIL
  Future<void> setEmail(String email) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('email', email);
  }

  Future<String?> getEmail() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? email = pref.getString('email');
    return email ?? '';
  }

  // Role Type | reguler , kantin, wirausaha, kurir
  Future<void> setType({String type = 'reguler'}) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('type', type);
  }

  Future<String?> getType() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? type = pref.getString(
      'type',
    );
    return type ?? 'reguler';
  }

  // LOGGED IN
  Future<void> setIsloggedIn(String isLoggedIn) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('is_logged_in', isLoggedIn);
  }

  Future<String?> getIsloggedIn() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? isLoggedIn = pref.getString('is_logged_in');
    return isLoggedIn;
  }

  // LOGGED IN
  Future<void> setIsDriver(String isDriver) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('is_driver', isDriver);
  }

  Future<String?> getIsDriver() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? isDriver = pref.getString('is_driver');
    return isDriver ?? 'no';
  }

  // Merchant id
  Future<void> setMerchantId(String merchantId) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('merchant_id', merchantId);
  }

  Future<String?> getMerchantId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? merchantId = pref.getString('merchant_id');
    log('pref merchandId : $merchantId');
    return merchantId;
  }

  Future<void> setAppVersion(String appVersion) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('app_version', appVersion);
  }

  Future<String?> getAppVersion() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? appVersion = pref.getString('app_version');
    log('pref app version : $appVersion');
    return appVersion;
  }

  Future<void> setToDashboard(String toDashboard) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('to_dashboard', toDashboard);
  }

  Future<String?> getToDashBoard() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? toDashboard = pref.getString('to_dashboard');
    log('pref to dahsboard : ${toDashboard ?? 'no'}');
    return toDashboard ?? 'no';
  }
}
