import 'dart:convert';

class GetDetailOrganizationResponse {
  int? statusCode;
  String? status;
  String? message;
  DataDetailOrganization? data;

  GetDetailOrganizationResponse(
      {this.statusCode, this.status, this.message, this.data});

  GetDetailOrganizationResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new DataDetailOrganization.fromJson(json['data'])
        : null;
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

class DataDetailOrganization {
  int? organizationId;
  String? organizationName;
  String? organizationLogo;
  int? totalActivity;
  int? totalWirausaha;
  int? totalMenu;
  int? campusId;
  List<Activity>? activities;

  DataDetailOrganization(
      {this.organizationId,
      this.organizationName,
      this.organizationLogo,
      this.totalActivity,
      this.totalWirausaha,
      this.totalMenu,
      this.campusId,
      this.activities});

  DataDetailOrganization.fromJson(Map<String, dynamic> json) {
    organizationId = json['organizationId'];
    organizationName = json['organizationName'];
    organizationLogo = json['organizationLogo'];
    totalActivity = json['totalActivity'];
    totalWirausaha = json['totalWirausaha'];
    totalMenu = json['totalMenu'];
    campusId = json['campusId'];
    if (json['activities'] != null) {
      activities = [];
      json['activities'].forEach((v) {
        activities!.add(new Activity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['organizationId'] = this.organizationId;
    data['organizationName'] = this.organizationName;
    data['organizationLogo'] = this.organizationLogo;
    data['totalActivity'] = this.totalActivity;
    data['totalWirausaha'] = this.totalWirausaha;
    data['totalMenu'] = this.totalMenu;
    data['campusId'] = this.campusId;
    if (this.activities != null) {
      data['activities'] = this.activities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Activity {
  String? activityName;
  List<Merchant>? merchants;

  Activity({this.activityName, this.merchants});

  Activity.fromJson(Map<String, dynamic> json) {
    activityName = json['activityName'];
    if (json['merchants'] != null) {
      merchants = [];
      json['merchants'].forEach((v) {
        merchants!.add(new Merchant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activityName'] = this.activityName;
    if (this.merchants != null) {
      data['merchants'] = this.merchants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Merchant {
  int? merchantId;
  String? merchantName;
  String? merchantPhoto;
  String? merchantType;
  double? rating;
  int? followers;
  String? location;
  int? userId;
  bool? open;
  bool? danus;

  Merchant(
      {this.merchantId,
      this.merchantName,
      this.merchantPhoto,
      this.merchantType,
      this.rating,
      this.followers,
      this.location,
      this.userId,
      this.open,
      this.danus});

  Merchant.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    merchantName = json['merchantName'];
    merchantPhoto = json['merchantPhoto'];
    merchantType = json['merchantType'];
    rating = json['rating'];
    followers = json['followers'];
    location = json['location'];
    userId = json['userId'];
    open = json['open'];
    danus = json['danus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchantId'] = this.merchantId;
    data['merchantName'] = this.merchantName;
    data['merchantPhoto'] = this.merchantPhoto;
    data['merchantType'] = this.merchantType;
    data['rating'] = this.rating;
    data['followers'] = this.followers;
    data['location'] = this.location;
    data['userId'] = this.userId;
    data['open'] = this.open;
    data['danus'] = this.danus;
    return data;
  }
}
