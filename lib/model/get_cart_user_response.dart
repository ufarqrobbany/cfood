class CartResponse {
  final int statusCode;
  final String status;
  final String message;
  final List<CartData> data;

  CartResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    required this.data,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      statusCode: json['statusCode'],
      status: json['status'],
      message: json['message'],
      data: List<CartData>.from(json['data'].map((item) => CartData.fromJson(item))),
    );
  }
}

class CartData {
  final int cartId;
  final int merchantId;
  final String merchantName;
  final String merchantType;
  final bool isOpen;
  final List<CartItem> items;

  CartData({
    required this.cartId,
    required this.merchantId,
    required this.merchantName,
    required this.merchantType,
    required this.isOpen,
    required this.items,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      cartId: json['cartId'],
      merchantId: json['merchantId'],
      merchantName: json['merchantName'],
      merchantType: json['merchantType'],
      isOpen: json['open'],
      items: List<CartItem>.from(json['items'].map((item) => CartItem.fromJson(item))),
    );
  }
}

class CartItem {
  final int cartItemId;
  final int menuId;
  final String menuName;
  final String menuPhoto;
  final int stock;
  final int quantity;
  final int totalPriceMenu;
  final List<Variant> variants;

  CartItem({
    required this.cartItemId,
    required this.menuId,
    required this.menuName,
    required this.menuPhoto,
    required this.stock,
    required this.quantity,
    required this.totalPriceMenu,
    required this.variants,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId'],
      menuId: json['menuId'],
      menuName: json['menuName'],
      menuPhoto: json['menuPhoto'],
      stock: json['stock'],
      quantity: json['quantity'],
      totalPriceMenu: json['totalPriceMenu'],
      variants: List<Variant>.from(json['variants'].map((item) => Variant.fromJson(item))),
    );
  }
}

class Variant {
  final int variantId;
  final String variantName;
  final List<VariantOption> variantOptions;

  Variant({
    required this.variantId,
    required this.variantName,
    required this.variantOptions,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      variantId: json['variantId'],
      variantName: json['variantName'],
      variantOptions: List<VariantOption>.from(json['variantOptions'].map((item) => VariantOption.fromJson(item))),
    );
  }
}

class VariantOption {
  final int cartVariantId;
  final int variantOptionId;
  final String variantOptionName;
  final int variantOptionPrice;

  VariantOption({
    required this.cartVariantId,
    required this.variantOptionId,
    required this.variantOptionName,
    required this.variantOptionPrice,
  });

  factory VariantOption.fromJson(Map<String, dynamic> json) {
    return VariantOption(
      cartVariantId: json['cartVariantId'],
      variantOptionId: json['variantOptionId'],
      variantOptionName: json['variantOptionName'],
      variantOptionPrice: json['variantOptionPrice'],
    );
  }
}
