import 'dart:convert';

RegisterDanusResponse registerDanusResponseFromJson(String str)=> RegisterDanusResponse.fromJson(json.decode(str));

class RegisterDanusResponse {
  int? statusCode;
  String? status;
  String? message;
  DataRegisterDanus? data;

  RegisterDanusResponse(
      {this.statusCode, this.status, this.message, this.data});

  RegisterDanusResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DataRegisterDanus.fromJson(json['data']) : null;
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

class DataRegisterDanus {
  int? id;
  int? merchantId;
  String? merchantName;
  int? organizationId;
  String? organizationName;
  int? activityId;
  String? activityName;

  DataRegisterDanus(
      {this.id,
      this.merchantId,
      this.merchantName,
      this.organizationId,
      this.organizationName,
      this.activityId,
      this.activityName});

  DataRegisterDanus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchantId'];
    merchantName = json['merchantName'];
    organizationId = json['organizationId'];
    organizationName = json['organizationName'];
    activityId = json['activityId'];
    activityName = json['activityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchantId'] = this.merchantId;
    data['merchantName'] = this.merchantName;
    data['organizationId'] = this.organizationId;
    data['organizationName'] = this.organizationName;
    data['activityId'] = this.activityId;
    data['activityName'] = this.activityName;
    return data;
  }
}
