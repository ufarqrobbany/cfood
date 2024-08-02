class AddCartResponse {
  int? statusCode;
  String? status;
  String? message;
  DataAddCart? data;

  AddCartResponse({this.statusCode, this.status, this.message, this.data});

  AddCartResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DataAddCart.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataAddCart {
  int? cartId;
  int? merchantId;
  int? totalMenus;
  int? totalItems;
  int? totalPrices;

  DataAddCart(
      {this.cartId,
      this.merchantId,
      this.totalMenus,
      this.totalItems,
      this.totalPrices});

  DataAddCart.fromJson(Map<String, dynamic> json) {
    cartId = json['cartId'];
    merchantId = json['merchantId'];
    totalMenus = json['totalMenus'];
    totalItems = json['totalItems'];
    totalPrices = json['totalPrices'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartId'] = this.cartId;
    data['merchantId'] = this.merchantId;
    data['totalMenus'] = this.totalMenus;
    data['totalItems'] = this.totalItems;
    data['totalPrices'] = this.totalPrices;
    return data;
  }
}
