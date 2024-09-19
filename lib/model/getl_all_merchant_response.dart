
class GetAllMerchantsResponse {
  int? statusCode;
  String? status;
  String? message;
  DataGetMerchant? data;

  GetAllMerchantsResponse(
      {this.statusCode, this.status, this.message, this.data});

  GetAllMerchantsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? DataGetMerchant.fromJson(json['data'])
        : null;
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

class DataGetMerchant {
  List<MerchantItems>? merchants;
  int? totalPages;
  int? totalElements;

  DataGetMerchant({this.merchants, this.totalPages, this.totalElements});

  DataGetMerchant.fromJson(Map<String, dynamic> json) {
    if (json['merchants'] != null) {
      merchants = <MerchantItems>[];
      json['merchants'].forEach((v) {
        merchants!.add(MerchantItems.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (merchants != null) {
      data['merchants'] = merchants!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = totalPages;
    data['totalElements'] = totalElements;
    return data;
  }
}

class MerchantItems {
  int? merchantId;
  String? merchantName;
  String? merchantPhoto;
  String? merchantType;
  double? rating;
  int? followers;
  String? location;
  int? userId;
  bool? open;
  bool? danus;

  MerchantItems(
      {this.merchantId,
      this.merchantName,
      this.merchantPhoto,
      this.merchantType,
      this.rating,
      this.followers,
      this.location,
      this.userId,
      this.open,
      this.danus});

  MerchantItems.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    merchantName = json['merchantName'];
    merchantPhoto = json['merchantPhoto'];
    merchantType = json['merchantType'];
    rating = json['rating'];
    followers = json['followers'];
    location = json['location'];
    userId = json['userId'];
    open = json['open'];
    danus = json['danus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantId'] = merchantId;
    data['merchantName'] = merchantName;
    data['merchantPhoto'] = merchantPhoto;
    data['merchantType'] = merchantType;
    data['rating'] = rating;
    data['followers'] = followers;
    data['location'] = location;
    data['userId'] = userId;
    data['open'] = open;
    data['danus'] = danus;
    return data;
  }
}
