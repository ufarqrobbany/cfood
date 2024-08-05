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
        data!.add(DataFollowed.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['message'] = message;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantId'] = merchantId;
    data['merchantName'] = merchantName;
    data['merchantPhoto'] = merchantPhoto;
    data['merchantType'] = merchantType;
    data['rating'] = rating;
    data['followers'] = followers;
    data['location'] = location;
    data['userId'] = userId;
    data['open'] = open;
    data['danus'] = danus;
    return data;
  }
}
