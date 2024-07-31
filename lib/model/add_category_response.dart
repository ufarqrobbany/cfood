import 'dart:convert';

AddCategoryResponse addCategoryResponseFromJson(String str) => AddCategoryResponse.fromJson(json.decode(str));

class AddCategoryResponse {
  int? statusCode;
  String? status;
  String? message;
  DataAddCategory? data;

  AddCategoryResponse({this.statusCode, this.status, this.message, this.data});

  AddCategoryResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DataAddCategory.fromJson(json['data']) : null;
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

class DataAddCategory {
  int? categoryMenuId;
  String? categoryMenuName;
  int? merchantId;

  DataAddCategory({this.categoryMenuId, this.categoryMenuName, this.merchantId});

  DataAddCategory.fromJson(Map<String, dynamic> json) {
    categoryMenuId = json['categoryMenuId'];
    categoryMenuName = json['categoryMenuName'];
    merchantId = json['merchantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryMenuId'] = this.categoryMenuId;
    data['categoryMenuName'] = this.categoryMenuName;
    data['merchantId'] = this.merchantId;
    return data;
  }
}
