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
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['organizationName'] = organizationName;
    data['organizationLogo'] = organizationLogo;
    data['campusId'] = campusId;
    return data;
  }
}
