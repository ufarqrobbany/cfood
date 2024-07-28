import 'dart:convert';

AddStudentResponse addStudentResponseFromJson(String str) => AddStudentResponse.fromJson(json.decode(str));

class AddStudentResponse {
  int? statusCode;
  String? status;
  String? message;
  DataAddStudent? data;

  AddStudentResponse({this.statusCode, this.status, this.message, this.data});

  AddStudentResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataAddStudent.fromJson(json['data']) : null;
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

class DataAddStudent {
  int? studentId;
  int? userId;
  String? nim; // watever

  DataAddStudent({this.studentId, this.userId, this.nim});

  DataAddStudent.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    userId = json['userId'];
    nim = json['nim'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['studentId'] = studentId;
    data['userId'] = userId;
    data['nim'] = nim;
    return data;
  }
}
