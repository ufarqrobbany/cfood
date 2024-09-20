import 'dart:convert';

ErrorResponse errorResponseFromJson(String str) =>
    ErrorResponse.fromJson(json.decode(str));

class ErrorResponse {
  String? timestamp;
  int? status;
  String? error;
  String? path;

  ErrorResponse({this.timestamp, this.status, this.error, this.path});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    status = json['status'];
    error = json['error'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['status'] = status;
    data['error'] = error;
    data['path'] = path;
    return data;
  }
}

Error400Response error400ResponseFromJson(String str) =>
    Error400Response.fromJson(json.decode(str));

class Error400Response {
  int? statusCode;
  String? status;
  String? message;
  // Null? data;

  Error400Response({
    this.statusCode,
    this.status,
    this.message,
  });

  Error400Response.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    // data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    // data['data'] = this.data;
    return data;
  }
}
