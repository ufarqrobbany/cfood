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
        data!.add(new DataCategory.fromJson(v));
      });
    } else {
      data = [];
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

class DataCategory {
  int? id;
  String? categoryMenuName;

  DataCategory({this.id, this.categoryMenuName});

  DataCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryMenuName = json['categoryMenuName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryMenuName'] = this.categoryMenuName;
    return data;
  }
}
