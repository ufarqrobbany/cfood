import 'dart:convert';

CampusesListResponse campusesListReponseFromJson(String str) => CampusesListResponse.fromJson(json.decode(str));

String campusesListResponseToJson(CampusesListResponse data) => json.encode(data.toJson());

class CampusesListResponse {
  int? statusCode;
  String? status;
  String? message;
  List<DataCampusesItem>? data;

  CampusesListResponse({this.statusCode, this.status, this.message, this.data});

  CampusesListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataCampusesItem>[];
      json['data'].forEach((v) {
        data!.add(DataCampusesItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataCampusesItem {
  int? id;
  String? campusName;

  DataCampusesItem({this.id, this.campusName});

  DataCampusesItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    campusName = json['campusName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['campusName'] = campusName;
    return data;
  }
}
