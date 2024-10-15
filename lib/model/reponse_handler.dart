import 'dart:convert';

ResponseHendler responseHendlerFromJson(String str) => ResponseHendler.fromJson(json.decode(str));

class ResponseHendler {
  int? statusCode;
  String? status;
  String? message;
  dynamic data;

  ResponseHendler({this.statusCode, this.status, this.message,});

  ResponseHendler.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}

Map<String, dynamic> removeNullsFromModel(Map<String, dynamic> json) {
  json.removeWhere((key, value) => value == null);
  return json;
}


class ResponseHendlerDataBool {
  int? statusCode;
  String? status;
  String? message;
  bool? data;

  ResponseHendlerDataBool({this.statusCode, this.status, this.message,});

  ResponseHendlerDataBool.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data;
    return data;
  }
}

// Map<String, dynamic> removeNullsFromModel(Map<String, dynamic> json) {
//   json.removeWhere((key, value) => value == null);
//   return json;
// }
