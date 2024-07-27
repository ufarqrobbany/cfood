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
    data = json['data'] != null ? new DataAddDriver.fromJson(json['data']) : null;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['studentId'] = this.studentId;
    return data;
  }
}
