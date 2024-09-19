import 'dart:convert';


CheckNimResponse checkNimReponseFromJson(String str) => CheckNimResponse.fromJson(json.decode(str));

class CheckNimResponse {
  int? statusCode;
  String? status;
  String? message;
  DataCheckNim? data;

  CheckNimResponse({this.statusCode, this.status, this.message, this.data});

  CheckNimResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataCheckNim.fromJson(json['data']) : null;
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

class DataCheckNim {
  String? nim;
  bool? available;

  DataCheckNim({this.nim, this.available});

  DataCheckNim.fromJson(Map<String, dynamic> json) {
    nim = json['nim'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nim'] = nim;
    data['available'] = available;
    return data;
  }
}