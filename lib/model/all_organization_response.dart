import 'dart:convert';

GetAllOrganizationResponse getAllOrganizationResponseFromJson(String str) => GetAllOrganizationResponse.fromJson(json.decode(str));

class GetAllOrganizationResponse {
  int? statusCode;
  String? status;
  String? message;
  List<DataGetOrganization>? data;

  GetAllOrganizationResponse(
      {this.statusCode, this.status, this.message, this.data});

  GetAllOrganizationResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataGetOrganization>[];
      json['data'].forEach((v) {
        data!.add(new DataGetOrganization.fromJson(v));
      });
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

class DataGetOrganization {
  int? id;
  String? organizationName;
  String? organizationLogo;
  int? totalActivity;
  int? totalWirausaha;
  int? totalMenu;
  int? campusId;

  DataGetOrganization(
      {this.id,
      this.organizationName,
      this.organizationLogo,
      this.totalActivity,
      this.totalWirausaha,
      this.totalMenu,
      this.campusId});

  DataGetOrganization.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationName = json['organizationName'];
    organizationLogo = json['organizationLogo'];
    totalActivity = json['totalActivity'];
    totalWirausaha = json['totalWirausaha'];
    totalMenu = json['totalMenu'];
    campusId = json['campusId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['organizationName'] = this.organizationName;
    data['organizationLogo'] = this.organizationLogo;
    data['totalActivity'] = this.totalActivity;
    data['totalWirausaha'] = this.totalWirausaha;
    data['totalMenu'] = this.totalMenu;
    data['campusId'] = this.campusId;
    return data;
  }
}
