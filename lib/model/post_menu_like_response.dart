import 'dart:convert';

class PostMenuLikeResponse {
  int? statusCode;
  String? status;
  String? message;
  DataLikeMenu? data;

  PostMenuLikeResponse({this.statusCode, this.status, this.message, this.data});

  PostMenuLikeResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
<<<<<<< HEAD
    data =
        json['data'] != null ? new DataLikeMenu.fromJson(json['data']) : null;
=======
    data = json['data'] != null ? new DataLikeMenu.fromJson(json['data']) : null;
>>>>>>> 7a2ecbe89105a2ec9e37de807b5a4d779d376b7d
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

class DataLikeMenu {
  int? id;
  int? userId;
  String? userName;
  int? merchantId;
  String? merchantName;

  DataLikeMenu(
      {this.id,
      this.userId,
      this.userName,
      this.merchantId,
      this.merchantName});

  DataLikeMenu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userName = json['userName'];
    merchantId = json['merchantId'];
    merchantName = json['merchantName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['merchantId'] = this.merchantId;
    data['merchantName'] = this.merchantName;
    return data;
  }
}
