
class GetAllOrganizationsResponse {
  int? statusCode;
  String? status;
  String? message;
  DataGetOrganization? data;

  GetAllOrganizationsResponse(
      {this.statusCode, this.status, this.message, this.data});

  GetAllOrganizationsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? DataGetOrganization.fromJson(json['data'])
        : null;
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

class DataGetOrganization {
  List<OrganizationItems>? organizations;
  int? totalPages;
  int? totalElements;

  DataGetOrganization(
      {this.organizations, this.totalPages, this.totalElements});

  DataGetOrganization.fromJson(Map<String, dynamic> json) {
    if (json['organizations'] != null) {
      organizations = <OrganizationItems>[];
      json['organizations'].forEach((v) {
        organizations!.add(OrganizationItems.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (organizations != null) {
      data['organizations'] =
          organizations!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = totalPages;
    data['totalElements'] = totalElements;
    return data;
  }
}

class OrganizationItems {
  int? id;
  String? organizationName;
  String? organizationLogo;
  int? totalActivity;
  int? totalWirausaha;
  int? totalMenu;
  int? campusId;

  OrganizationItems(
      {this.id,
      this.organizationName,
      this.organizationLogo,
      this.totalActivity,
      this.totalWirausaha,
      this.totalMenu,
      this.campusId});

  OrganizationItems.fromJson(Map<String, dynamic> json) {
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
