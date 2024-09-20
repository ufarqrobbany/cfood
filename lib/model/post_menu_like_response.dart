
class PostMenuLikeResponse {
  int? statusCode;
  String? status;
  String? message;
  DataLikeMenu? data;

  PostMenuLikeResponse({this.statusCode, this.status, this.message, this.data});

  PostMenuLikeResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataLikeMenu.fromJson(json['data']) : null;
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

class DataLikeMenu {
  int? id;
  int? userId;
  String? userName;
  int? merchantId;
  String? merchantName;

  DataLikeMenu(
      {this.id,
      this.userId,
      this.userName,
      this.merchantId,
      this.merchantName});

  DataLikeMenu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userName = json['userName'];
    merchantId = json['merchantId'];
    merchantName = json['merchantName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['userName'] = userName;
    data['merchantId'] = merchantId;
    data['merchantName'] = merchantName;
    return data;
  }
}
