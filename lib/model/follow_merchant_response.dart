import 'dart:convert';

FollowMerchantResponse followMerchantResponseFromJson(String str) =>
    FollowMerchantResponse.fromJson(json.decode(str));

class FollowMerchantResponse {
  int? statusCode;
  String? status;
  String? message;
  DataFollowMerchant? data;

  FollowMerchantResponse(
      {this.statusCode, this.status, this.message, this.data});

  FollowMerchantResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new DataFollowMerchant.fromJson(json['data'])
        : null;
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

class DataFollowMerchant {
  int? id;
  int? userId;
  String? userName;
  int? merchantId;
  String? merchantName;

  DataFollowMerchant(
      {this.id,
      this.userId,
      this.userName,
      this.merchantId,
      this.merchantName});

  DataFollowMerchant.fromJson(Map<String, dynamic> json) {
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

class UnfollowMerchantResponse {
  int? statusCode;
  String? status;
  String? message;
  DataUnfollowMerchant? data;

  UnfollowMerchantResponse(
      {this.statusCode, this.status, this.message, this.data});

  UnfollowMerchantResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new DataUnfollowMerchant.fromJson(json['data'])
        : null;
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

class DataUnfollowMerchant {
  int? userId;
  int? merchantId;

  DataUnfollowMerchant({this.userId, this.merchantId});

  DataUnfollowMerchant.fromJson(Map<String, dynamic> json) {
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

class IsFollowMerchantResponse {
  int? statusCode;
  String? status;
  String? message;
  bool? data;

  IsFollowMerchantResponse(
      {this.statusCode, this.status, this.message, this.data});

  IsFollowMerchantResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}
