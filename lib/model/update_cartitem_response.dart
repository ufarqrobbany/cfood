class UpdateCartItemResponse {
  int statusCode;
  String status;
  String message;
  UpdateCartItemData data;

  UpdateCartItemResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpdateCartItemResponse.fromJson(Map<String, dynamic> json) {
    return UpdateCartItemResponse(
      statusCode: json['statusCode'],
      status: json['status'],
      message: json['message'],
      data: UpdateCartItemData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class UpdateCartItemData {
  int cartItemId;
  int quantity;

  UpdateCartItemData({
    required this.cartItemId,
    required this.quantity,
  });

  factory UpdateCartItemData.fromJson(Map<String, dynamic> json) {
    return UpdateCartItemData(
      cartItemId: json['cartItemId'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartItemId': cartItemId,
      'quantity': quantity,
    };
  }
}
