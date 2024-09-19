import 'dart:convert';

OpenCloseStoreResponse openCloseStoreResponseFromJson(String str) => OpenCloseStoreResponse.fromJson(json.decode(str));

class OpenCloseStoreResponse {
  int? statusCode;
  String? status;
  String? message;
  DataOpenStore? data;

  OpenCloseStoreResponse(
      {this.statusCode, this.status, this.message, this.data});

  OpenCloseStoreResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataOpenStore.fromJson(json['data']) : null;
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

class DataOpenStore {
  int? merchantId;
  String? merchantName;
  bool? open;

  DataOpenStore({this.merchantId, this.merchantName, this.open});

  DataOpenStore.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    merchantName = json['merchantName'];
    open = json['open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantId'] = merchantId;
    data['merchantName'] = merchantName;
    data['open'] = open;
    return data;
  }
}
