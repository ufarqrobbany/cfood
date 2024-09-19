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
    data = json['data'] != null ? DataAddCategory.fromJson(json['data']) : null;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryMenuId'] = categoryMenuId;
    data['categoryMenuName'] = categoryMenuName;
    data['merchantId'] = merchantId;
    return data;
  }
}
