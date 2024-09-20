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
        data!.add(DataGetActivity.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['activityName'] = activityName;
    data['organizationId'] = organizationId;
    data['totalWirausaha'] = totalWirausaha;
    data['totalMenu'] = totalMenu;
    return data;
  }
}
