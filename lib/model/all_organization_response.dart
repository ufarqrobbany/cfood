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
          organizations!.add(DataGetOrganization.fromJson(v));
        });
      }
      totalPages = dataJson['totalPages'];
      totalElements = dataJson['totalElements'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    if (organizations != null) {
      data['data'] = {
        'organizations': organizations!.map((v) => v.toJson()).toList(),
        'totalPages': totalPages,
        'totalElements': totalElements
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['organizationName'] = organizationName;
    data['organizationLogo'] = organizationLogo;
    data['totalActivity'] = totalActivity;
    data['totalWirausaha'] = totalWirausaha;
    data['totalMenu'] = totalMenu;
    data['campusId'] = campusId;
    return data;
  }
}