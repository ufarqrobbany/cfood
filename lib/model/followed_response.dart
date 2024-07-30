import 'dart:convert';

GetFollowedResponse getFollowedResponseFromJson(String str) =>
    GetFollowedResponse.fromJson(json.decode(str));

class GetFollowedResponse {
  int? statusCode;
  String? status;
  String? message;
  List<DataFollowed>? data;

  GetFollowedResponse({this.statusCode, this.status, this.message, this.data});

  GetFollowedResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataFollowed>[];
      json['data'].forEach((v) {
        data!.add(new DataFollowed.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataFollowed {
  int? merchantId;
  String? merchantName;
  String? merchantPhoto;
  String? merchantType;
  double? rating;
  int? followers;
  String? location;
  int? userId;
  bool? open;
  bool? danus;

  DataFollowed(
      {this.merchantId,
      this.merchantName,
      this.merchantPhoto,
      this.merchantType,
      this.rating,
      this.followers,
      this.location,
      this.userId,
      this.open,
      this.danus});

  DataFollowed.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    merchantName = json['merchantName'];
    merchantPhoto = json['merchantPhoto'];
    merchantType = json['merchantType'];
    rating = json['rating'];
    followers = json['followers'];
    location = json['location'];
    userId = json['userId'];
    open = json['open'];
    danus = json['danus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchantId'] = this.merchantId;
    data['merchantName'] = this.merchantName;
    data['merchantPhoto'] = this.merchantPhoto;
    data['merchantType'] = this.merchantType;
    data['rating'] = this.rating;
    data['followers'] = this.followers;
    data['location'] = this.location;
    data['userId'] = this.userId;
    data['open'] = this.open;
    data['danus'] = this.danus;
    return data;
  }
}
