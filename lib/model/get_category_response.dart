import 'dart:convert';

GetCategoryResponse getCategoryResponseFromJson(String str) => GetCategoryResponse.fromJson(json.decode(str));

class GetCategoryResponse {
  int? statusCode;
  String? status;
  String? message;
  List<DataCategory>? data;

  GetCategoryResponse({this.statusCode, this.status, this.message, this.data});

  GetCategoryResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null && json['data'] is List) {
      data = <DataCategory>[];
      json['data'].forEach((v) {
        data!.add(DataCategory.fromJson(v));
      });
    } else {
      data = [];
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

class DataCategory {
  int? id;
  String? categoryMenuName;

  DataCategory({this.id, this.categoryMenuName});

  DataCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryMenuName = json['categoryMenuName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['categoryMenuName'] = categoryMenuName;
    return data;
  }
}
