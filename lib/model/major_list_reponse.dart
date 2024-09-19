import 'dart:convert';

MajorListReponse majorListReponseFromJson(String str) => MajorListReponse.fromJson(json.decode(str));

String majorListReponseToJson(MajorListReponse data) => json.encode(data.toJson());


class MajorListReponse {
  int? statusCode;
  String? status;
  String? message;
  List<DataMajorItem>? data;

  MajorListReponse({this.statusCode, this.status, this.message, this.data});

  MajorListReponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataMajorItem>[];
      json['data'].forEach((v) {
        data!.add(DataMajorItem.fromJson(v));
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

class DataMajorItem {
  int? id;
  String? majorName;

  DataMajorItem({this.id, this.majorName});

  DataMajorItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    majorName = json['majorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['majorName'] = majorName;
    return data;
  }
}
