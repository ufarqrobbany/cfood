import 'dart:convert';

CheckEmailResponse checkEmailResponseFromJson(String str) => CheckEmailResponse.fromJson(json.decode(str));
String checkEmailResponseToJson(CheckEmailResponse data) => json.encode(data.toJson());


class CheckEmailResponse {
  int? statusCode;
  String? status;
  String? message;
  DataCheckEmailItem? data;

  CheckEmailResponse({this.statusCode, this.status, this.message, this.data});

  CheckEmailResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataCheckEmailItem.fromJson(json['data']) : null;
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

class DataCheckEmailItem {
  String? email;
  bool? available;

  DataCheckEmailItem({this.email, this.available});

  DataCheckEmailItem.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['available'] = available;
    return data;
  }
}
