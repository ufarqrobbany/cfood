
class AddMerchantResponse {
  int? statusCode;
  String? status;
  String? message;
  DataMerchant? data;

  AddMerchantResponse({this.statusCode, this.status, this.message, this.data});

  AddMerchantResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataMerchant.fromJson(json['data']) : null;
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

class DataMerchant {
  int? merchantId;
  String? merchantName;
  String? merchantPhoto;
  String? merchantDesc;
  String? merchantType;
  bool? open;

  DataMerchant(
      {this.merchantId,
      this.merchantName,
      this.merchantPhoto,
      this.merchantDesc,
      this.merchantType,
      this.open});

  DataMerchant.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    merchantName = json['merchantName'];
    merchantPhoto = json['merchantPhoto'];
    merchantDesc = json['merchantDesc'];
    merchantType = json['merchantType'];
    open = json['open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantId'] = merchantId;
    data['merchantName'] = merchantName;
    data['merchantPhoto'] = merchantPhoto;
    data['merchantDesc'] = merchantDesc;
    data['merchantType'] = merchantType;
    data['open'] = open;
    return data;
  }
}
