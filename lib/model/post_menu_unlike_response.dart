


class PostMenuUnlikeResponse {
  int? statusCode;
  String? status;
  String? message;
  Data? data;

  PostMenuUnlikeResponse(
      {this.statusCode, this.status, this.message, this.data});

  PostMenuUnlikeResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  int? userId;
  int? merchantId;

  Data({this.userId, this.merchantId});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    merchantId = json['merchantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['merchantId'] = merchantId;
    return data;
  }
}
