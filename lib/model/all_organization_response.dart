import 'dart:convert';

GetAllOrganizationResponse getAllOrganizationResponseFromJson(String str) => GetAllOrganizationResponse.fromJson(json.decode(str));

class GetAllOrganizationResponse {
  int? statusCode;
  String? status;
  String? message;
  List<DataGetOrganization>? organizations;
  int? totalPages;
  int? totalElements;

  GetAllOrganizationResponse(
      {this.statusCode, this.status, this.message, this.organizations, this.totalPages, this.totalElements});

  GetAllOrganizationResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      var dataJson = json['data'];
      if (dataJson['organizations'] != null) {
        organizations = <DataGetOrganization>[];
        dataJson['organizations'].forEach((v) {
          organizations!.add(new DataGetOrganization.fromJson(v));
        });
      }
      totalPages = dataJson['totalPages'];
      totalElements = dataJson['totalElements'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.organizations != null) {
      data['data'] = {
        'organizations': this.organizations!.map((v) => v.toJson()).toList(),
        'totalPages': this.totalPages,
        'totalElements': this.totalElements
      };
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