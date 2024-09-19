import 'dart:convert';

GetLikedResponse getLikedResponseFromJson(String str) =>
    GetLikedResponse.fromJson(json.decode(str));

class GetLikedResponse {
  int? statusCode;
  String? status;
  String? message;
  List<DataLiked>? data;

  GetLikedResponse({this.statusCode, this.status, this.message, this.data});

  GetLikedResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataLiked>[];
      json['data'].forEach((v) {
        data!.add(DataLiked.fromJson(v));
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

class DataLiked {
  int? menuId;
  String? menuName;
  String? menuPhoto;
  int? menuPrice;
  double? menuRating;
  int? menuLikes;
  bool? menuIsDanus;
  MerchantLiked? merchants;

  DataLiked({
    this.menuId,
    this.menuName,
    this.menuPhoto,
    this.menuPrice,
    this.menuRating,
    this.menuLikes,
    this.menuIsDanus,
    this.merchants,
  });

  factory DataLiked.fromJson(Map<String, dynamic> json) {
    return DataLiked(
      menuId: json['menuId'] as int?,
      menuName: json['menuName'] as String?,
      menuPhoto: json['menuPhoto'] as String?,
      menuPrice: json['menuPrice'] as int?,
      menuRating: (json['menuRating'] as num?)?.toDouble(),
      menuLikes: json['menuLikes'] as int?,
      menuIsDanus: json['menuIsDanus'] as bool?,
      merchants: json['merchants'] != null
          ? MerchantLiked.fromJson(json['merchants'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['menuId'] = menuId;
    data['menuName'] = menuName;
    data['menuPhoto'] = menuPhoto;
    data['menuPrice'] = menuPrice;
    data['menuRating'] = menuRating;
    data['menuLikes'] = menuLikes;
    data['menuIsDanus'] = menuIsDanus;
    if (merchants != null) {
      data['merchants'] = merchants!.toJson();
    }
    return data;
  }
}

class MerchantLiked {
  int? merchantId;
  String? merchantType;
  String? merchantName;

  MerchantLiked({this.merchantId, this.merchantType, this.merchantName});

  factory MerchantLiked.fromJson(Map<String, dynamic> json) {
    return MerchantLiked(
      merchantId: json['merchantId'] as int?,
      merchantType: json['merchantType'] as String?,
      merchantName: json['merchantName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantId'] = merchantId;
    data['merchantType'] = merchantType;
    data['merchantName'] = merchantName;
    return data;
  }
}
