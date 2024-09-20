
class Merchant {
  final int? merchantId;
  final String? merchantType;
  final String? merchantName;

  Merchant({
    this.merchantId,
    this.merchantType,
    this.merchantName,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      merchantId: json['merchantId'] as int?,
      merchantType: json['merchantType'] as String?,
      merchantName: json['merchantName'] as String?,
    );
  }
}

class MenuItems {
  final int? menuId;
  final String? menuName;
  final String? menuPhoto;
  final int? menuPrice;
  final double? menuRating;
  final int? menuLikes;
  final bool? menuIsDanus;
  final Merchant? merchants;

  MenuItems({
    this.menuId,
    this.menuName,
    this.menuPhoto,
    this.menuPrice,
    this.menuRating,
    this.menuLikes,
    this.menuIsDanus,
    this.merchants,
  });

  factory MenuItems.fromJson(Map<String, dynamic> json) {
    return MenuItems(
      menuId: json['menuId'] as int?,
      menuName: json['menuName'] as String?,
      menuPhoto: json['menuPhoto'] as String?,
      menuPrice: json['menuPrice'] as int?,
      menuRating: (json['menuRating'] as num?)?.toDouble(),
      menuLikes: json['menuLikes'] as int?,
      menuIsDanus: json['menuIsDanus'] as bool?,
      merchants: json['merchants'] != null
          ? Merchant.fromJson(json['merchants'])
          : null,
    );
  }
}

class MenusResponse {
  final int? statusCode;
  final String? status;
  final String? message;
  final DataGetMenu? data;

  MenusResponse({
    this.statusCode,
    this.status,
    this.message,
    this.data,
  });

  factory MenusResponse.fromJson(Map<String, dynamic> json) {
    return MenusResponse(
      statusCode: json['statusCode'] as int?,
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null ? DataGetMenu.fromJson(json['data']) : null,
    );
  }
}

class DataGetMenu {
  final List<MenuItems>? content;
  final int? page;
  final int? size;
  final int? totalElements;
  final int? totalPages;
  final bool? last;

  DataGetMenu({
    this.content,
    this.page,
    this.size,
    this.totalElements,
    this.totalPages,
    this.last,
  });

  factory DataGetMenu.fromJson(Map<String, dynamic> json) {
    var contentList = json['content'] as List? ?? [];
    List<MenuItems> contentData =
        contentList.map((i) => MenuItems.fromJson(i)).toList();

    return DataGetMenu(
      content: contentData,
      page: json['page'] as int?,
      size: json['size'] as int?,
      totalElements: json['totalElements'] as int?,
      totalPages: json['totalPages'] as int?,
      last: json['last'] as bool?,
    );
  }
}
