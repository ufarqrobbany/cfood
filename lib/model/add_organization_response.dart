import 'dart:convert';

AddOrganizationResponse addOrganizationResponseFromJson(String str) => AddOrganizationResponse.fromJson(json.decode(str));

class AddOrganizationResponse {
  int? statusCode;
  String? status;
  String? message;
  Data? data;

  AddOrganizationResponse(
      {this.statusCode, this.status, this.message, this.data});

  AddOrganizationResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? id;
  String? organizationName;
  String? organizationLogo;
  int? campusId;

  Data({this.id, this.organizationName, this.organizationLogo, this.campusId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationName = json['organizationName'];
    organizationLogo = json['organizationLogo'];
    campusId = json['campusId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['organizationName'] = this.organizationName;
    data['organizationLogo'] = this.organizationLogo;
    data['campusId'] = this.campusId;
    return data;
  }
}
