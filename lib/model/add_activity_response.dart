import 'dart:convert';

AddActivityResponse addActivityResponseFromJson(String str)=> AddActivityResponse.fromJson(json.decode(str));


class AddActivityResponse {
  int? statusCode;
  String? status;
  String? message;
  DataAddActivity? data;

  AddActivityResponse({this.statusCode, this.status, this.message, this.data});

  AddActivityResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataAddActivity.fromJson(json['data']) : null;
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

class DataAddActivity {
  int? id;
  String? activityName;
  int? organizationId;
  int? campusId;

  DataAddActivity({this.id, this.activityName, this.organizationId, this.campusId});

  DataAddActivity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    activityName = json['activityName'];
    organizationId = json['organizationId'];
    campusId = json['campusId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['activityName'] = activityName;
    data['organizationId'] = organizationId;
    data['campusId'] = campusId;
    return data;
  }
}
