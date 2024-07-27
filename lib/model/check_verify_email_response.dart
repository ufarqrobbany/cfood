import 'dart:convert';

CheckVerifyEmailResponse checkVerifyEmailResponseFromJson(String str) => CheckVerifyEmailResponse.fromJson(json.decode(str));

class CheckVerifyEmailResponse {
  int? statusCode;
  String? status;
  String? message;
  DataVerifyEmail? data;

  CheckVerifyEmailResponse(
      {this.statusCode, this.status, this.message, this.data});

  CheckVerifyEmailResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DataVerifyEmail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataVerifyEmail {
  int? userId;
  String? email;
  bool? verified;

  DataVerifyEmail({this.userId, this.email, this.verified});

  DataVerifyEmail.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    email = json['email'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['email'] = this.email;
    data['verified'] = this.verified;
    return data;
  }
}
