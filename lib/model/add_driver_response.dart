import 'dart:convert';

AddDriverResponse addDriverResponseFromJson(String str) => AddDriverResponse.fromJson(json.decode(str));

class AddDriverResponse {
  int? statusCode;
  String? status;
  String? message;
  DataAddDriver? data;

  AddDriverResponse({this.statusCode, this.status, this.message, this.data});

  AddDriverResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataAddDriver.fromJson(json['data']) : null;
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

class DataAddDriver {
  int? id;
  double? rating;
  int? studentId;

  DataAddDriver({this.id, this.rating, this.studentId});

  DataAddDriver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    studentId = json['studentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rating'] = rating;
    data['studentId'] = studentId;
    return data;
  }
}
