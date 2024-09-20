import 'dart:convert';

AddUserResponse addUserResponseFromJson(String str) => AddUserResponse.fromJson(json.decode(str));


class AddUserResponse {
  int? statusCode;
  String? status;
  String? message;
  DataAddUser? data;

  AddUserResponse({this.statusCode, this.status, this.message, this.data});

  AddUserResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataAddUser.fromJson(json['data']) : null;
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

class DataAddUser {
  int? id;
  String? email;
  String? name;

  DataAddUser({this.id, this.email, this.name});

  DataAddUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    return data;
  }
}
