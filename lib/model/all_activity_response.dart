import 'dart:convert';


GetAllActivityResponse getAllActivityResponseFromJson(String str) => GetAllActivityResponse.fromJson(json.decode(str));


class GetAllActivityResponse {
  int? statusCode;
  String? status;
  String? message;
  List<DataGetActivity>? data;

  GetAllActivityResponse(
      {this.statusCode, this.status, this.message, this.data});

  GetAllActivityResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataGetActivity>[];
      json['data'].forEach((v) {
        data!.add(new DataGetActivity.fromJson(v));
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

class DataGetActivity {
  int? id;
  String? activityName;
  int? organizationId;
  int? totalWirausaha;
  int? totalMenu;

  DataGetActivity(
      {this.id,
      this.activityName,
      this.organizationId,
      this.totalWirausaha,
      this.totalMenu});

  DataGetActivity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    activityName = json['activityName'];
    organizationId = json['organizationId'];
    totalWirausaha = json['totalWirausaha'];
    totalMenu = json['totalMenu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['activityName'] = this.activityName;
    data['organizationId'] = this.organizationId;
    data['totalWirausaha'] = this.totalWirausaha;
    data['totalMenu'] = this.totalMenu;
    return data;
  }
}
