import 'dart:convert';
import 'dart:developer';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/error_response.dart';
import 'package:http/http.dart' as http;
import 'package:cfood/utils/constant.dart';
import 'package:flutter/cupertino.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

class LoginResponse {
  int? statusCode;
  String? status;
  String? message;
  DataLogin? data;

  LoginResponse({this.statusCode, this.status, this.message, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataLogin.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataLogin {
  int? userId;
  String? email;
  bool? verified;

  DataLogin({this.userId, this.email, this.verified});

  DataLogin.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    email = json['email'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['email'] = email;
    data['verified'] = verified;
    return data;
  }
}

class LoginRepository {
  Future<LoginResponse> loginUser(
    BuildContext? context, {
    String email = '',
    String password = '',
  }) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}users/login");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: json.encode({
          'email': email,
          'password': password,
        }));

    log('response login: ${response.body}');

    if (response.statusCode <= 499) {
      LoginResponse data = loginResponseFromJson(response.body);
      log(response.body);
      if (data.message != null) {
        showToast(data.message!);
      }
      // log(data.message!);
      return loginResponseFromJson(response.body);
    }
    // else if (response.statusCode <= 499) {
    //   Error400Response data = error400ResponseFromJson(response.body);
    //   log(response.body);
    //   showToast(data.message!);
    //   throw Exception(data.message);
    // }
    else {
      Error400Response data = error400ResponseFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      throw Exception(data.message);
    }
  }
}
