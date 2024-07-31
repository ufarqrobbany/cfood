import 'dart:convert';

class GetDetailMerchantResponse {
  int? statusCode;
  String? status;
  String? message;
  DataDetailMerchant? data;

  GetDetailMerchantResponse(
      {this.statusCode, this.status, this.message, this.data});

  GetDetailMerchantResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new DataDetailMerchant.fromJson(json['data'])
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

class DataDetailMerchant {
  int? merchantId;
  String? merchantName;
  String? merchantPhoto;
  String? merchantDesc;
  String? merchantType;
  int? followers;
  double? rating;
  String? location;
  StudentInformation? studentInformation;
  DanusInformation? danusInformation;
  bool? open;
  bool? follow;

  DataDetailMerchant(
      {this.merchantId,
      this.merchantName,
      this.merchantPhoto,
      this.merchantDesc,
      this.merchantType,
      this.followers,
      this.rating,
      this.location,
      this.studentInformation,
      this.danusInformation,
      this.open,
      this.follow});

  DataDetailMerchant.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    merchantName = json['merchantName'];
    merchantPhoto = json['merchantPhoto'];
    merchantDesc = json['merchantDesc'];
    merchantType = json['merchantType'];
    followers = json['followers'];
    rating = json['rating'];
    location = json['location'];
    studentInformation = json['studentInformation'] != null
        ? new StudentInformation.fromJson(json['studentInformation'])
        : null;
    danusInformation = json['danusInformation'] != null
        ? new DanusInformation.fromJson(json['danusInformation'])
        : null;
    open = json['open'];
    follow = json['follow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchantId'] = this.merchantId;
    data['merchantName'] = this.merchantName;
    data['merchantPhoto'] = this.merchantPhoto;
    data['merchantDesc'] = this.merchantDesc;
    data['merchantType'] = this.merchantType;
    data['followers'] = this.followers;
    data['rating'] = this.rating;
    data['location'] = this.location;
    if (this.studentInformation != null) {
      data['studentInformation'] = this.studentInformation!.toJson();
    }
    if (this.danusInformation != null) {
      data['danusInformation'] = this.danusInformation!.toJson();
    }
    data['open'] = this.open;
    data['follow'] = this.follow;
    return data;
  }
}

class StudentInformation {
  int? studentId;
  int? userId;
  String? userName;
  String? userPhoto;
  String? campusName;
  String? majorName;
  String? studyProgramName;

  StudentInformation(
      {this.studentId,
      this.userId,
      this.userName,
      this.userPhoto,
      this.campusName,
      this.majorName,
      this.studyProgramName});

  StudentInformation.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    userId = json['userId'];
    userName = json['userName'];
    userPhoto = json['userPhoto'];
    campusName = json['campusName'];
    majorName = json['majorName'];
    studyProgramName = json['studyProgramName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentId'] = this.studentId;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['userPhoto'] = this.userPhoto;
    data['campusName'] = this.campusName;
    data['majorName'] = this.majorName;
    data['studyProgramName'] = this.studyProgramName;
    return data;
  }
}

class DanusInformation {
  int? organizationId;
  String? organizationName;
  String? organizationPhoto;
  int? activityId;
  String? activityName;

  DanusInformation(
      {this.organizationId,
      this.organizationName,
      this.organizationPhoto,
      this.activityId,
      this.activityName});

  DanusInformation.fromJson(Map<String, dynamic> json) {
    organizationId = json['organizationId'];
    organizationName = json['organizationName'];
    organizationPhoto = json['organizationPhoto'];
    activityId = json['activityId'];
    activityName = json['activityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['organizationId'] = this.organizationId;
    data['organizationName'] = this.organizationName;
    data['organizationPhoto'] = this.organizationPhoto;
    data['activityId'] = this.activityId;
    data['activityName'] = this.activityName;
    return data;
  }
}
