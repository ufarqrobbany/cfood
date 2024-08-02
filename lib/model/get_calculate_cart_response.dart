class CalculateCartResponse {
  int? statusCode;
  String? status;
  String? message;
  CalculateCartData? data;

  CalculateCartResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
  });

  factory CalculateCartResponse.fromJson(Map<String, dynamic> json) {
    return CalculateCartResponse(
        statusCode: json['statusCode'],
        status: json['status'],
        message: json['message'],
        data: json['data'] != null
            ? new CalculateCartData.fromJson(json['data'])
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class CalculateCartData {
  int cartId;
  int merchantId;
  int totalMenus;
  int totalItems;
  int totalPrices;

  CalculateCartData({
    required this.cartId,
    required this.merchantId,
    required this.totalMenus,
    required this.totalItems,
    required this.totalPrices,
  });

  factory CalculateCartData.fromJson(Map<String, dynamic> json) {
    return CalculateCartData(
      cartId: json['cartId'],
      merchantId: json['merchantId'],
      totalMenus: json['totalMenus'],
      totalItems: json['totalItems'],
      totalPrices: json['totalPrices'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'merchantId': merchantId,
      'totalMenus': totalMenus,
      'totalItems': totalItems,
      'totalPrices': totalPrices,
    };
  }
}
