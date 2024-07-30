import 'dart:convert';


class GetAllMerchantsResponse {
  int? statusCode;
  String? status;
  String? message;
  DataGetMerchant? data;

  GetAllMerchantsResponse(
      {this.statusCode, this.status, this.message, this.data});

  GetAllMerchantsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DataGetMerchant.fromJson(json['data']) : null;
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

class DataGetMerchant {
  List<MerchantItems>? merchants;
  int? totalPages;
  int? totalElements;

  DataGetMerchant({this.merchants, this.totalPages, this.totalElements});

  DataGetMerchant.fromJson(Map<String, dynamic> json) {
    if (json['merchants'] != null) {
      merchants = <MerchantItems>[];
      json['merchants'].forEach((v) {
        merchants!.add(new MerchantItems.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.merchants != null) {
      data['merchants'] = this.merchants!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    return data;
  }
}

class MerchantItems {
  int? merchantId;
  String? merchantName;
  String? merchantPhoto;
  String? merchantType;
  double? rating;
  String? location;
  int? userId;
  bool? open;
  bool? danus;

  MerchantItems(
      {this.merchantId,
      this.merchantName,
      this.merchantPhoto,
      this.merchantType,
      this.rating,
      this.location,
      this.userId,
      this.open,
      this.danus});

  MerchantItems.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    merchantName = json['merchantName'];
    merchantPhoto = json['merchantPhoto'];
    merchantType = json['merchantType'];
    rating = json['rating'];
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
    data['location'] = this.location;
    data['userId'] = this.userId;
    data['open'] = this.open;
    data['danus'] = this.danus;
    return data;
  }
}
