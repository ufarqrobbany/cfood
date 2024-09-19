import 'dart:convert';

OtpCheckResponse otpCheckResponseFromJson(String str)=> OtpCheckResponse.fromJson(json.decode(str));

class OtpCheckResponse {
  int? statusCode;
  String? status;
  String? message;
  Data? data;

  OtpCheckResponse({this.statusCode, this.status, this.message, this.data});

  OtpCheckResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  int? userId;
  bool? valid;

  Data({this.userId, this.valid});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    valid = json['valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['valid'] = valid;
    return data;
  }
}
