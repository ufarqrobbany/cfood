import 'dart:convert';

<<<<<<< HEAD
=======


>>>>>>> 7a2ecbe89105a2ec9e37de807b5a4d779d376b7d
class PostMenuUnlikeResponse {
  int? statusCode;
  String? status;
  String? message;
  Data? data;

  PostMenuUnlikeResponse(
      {this.statusCode, this.status, this.message, this.data});

  PostMenuUnlikeResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? userId;
  int? merchantId;

  Data({this.userId, this.merchantId});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    merchantId = json['merchantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['merchantId'] = this.merchantId;
    return data;
  }
}
