import 'package:cfood/model/get_specific_menu_response.dart' as detailmenu;

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
      data: List<CartData>.from(
          json['data'].map((item) => CartData.fromJson(item))),
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
      items: List<CartItem>.from(
          json['items'].map((item) => CartItem.fromJson(item))),
    );
  }
}

class CartItem {
  final int cartItemId;
  final int stock;
  final int solds;
  final int quantity;
  final int totalPriceItem;
  final detailmenu.DataSpecificMenu detailMenu;
  final List<CartVariant> cartVariants;

  CartItem({
    required this.cartItemId,
    required this.stock,
    required this.solds,
    required this.quantity,
    required this.totalPriceItem,
    required this.detailMenu,
    required this.cartVariants,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId'],
      stock: json['stock'],
      solds: json['solds'],
      quantity: json['quantity'],
      totalPriceItem: json['totalPriceItem'],
      detailMenu: detailmenu.DataSpecificMenu.fromJson(json['detailMenu']),
      cartVariants: List<CartVariant>.from(
          json['cartVariants'].map((item) => CartVariant.fromJson(item))),
    );
  }
}

class CartVariant {
  final int variantId;
  final String variantName;
  final List<CartVariantOption> variantOptions;

  CartVariant({
    required this.variantId,
    required this.variantName,
    required this.variantOptions,
  });

  factory CartVariant.fromJson(Map<String, dynamic> json) {
    return CartVariant(
      variantId: json['variantId'],
      variantName: json['variantName'],
      variantOptions: List<CartVariantOption>.from(json['variantOptions']
          .map((item) => CartVariantOption.fromJson(item))),
    );
  }
}

class CartVariantOption {
  final int cartVariantId;
  final int variantOptionId;
  final String variantOptionName;
  final int variantOptionPrice;

  CartVariantOption({
    required this.cartVariantId,
    required this.variantOptionId,
    required this.variantOptionName,
    required this.variantOptionPrice,
  });

  factory CartVariantOption.fromJson(Map<String, dynamic> json) {
    return CartVariantOption(
      cartVariantId: json['cartVariantId'],
      variantOptionId: json['variantOptionId'],
      variantOptionName: json['variantOptionName'],
      variantOptionPrice: json['variantOptionPrice'],
    );
  }
}
