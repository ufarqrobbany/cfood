import 'package:cfood/model/get_detail_merchant_response.dart'
    as detailmerchant;

class GetSpecificMenuResponse {
  int? statusCode;
  String? status;
  String? message;
  DataSpecificMenu? data;

  GetSpecificMenuResponse(
      {this.statusCode, this.status, this.message, this.data});

  GetSpecificMenuResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DataSpecificMenu.fromJson(json['data']) : null;
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

class DataSpecificMenu {
  int? id;
  String? menuName;
  String? menuPhoto;
  String? menuDesc;
  int? menuPrice;
  int? menuStock;
  int? likes;
  double? rating;
  bool? isDanus;
  bool? isLike;
  String? categoryMenuName;
  int? merchantId;
  List<detailmerchant.Variant>? variants;

  DataSpecificMenu(
      {this.id,
      this.menuName,
      this.menuPhoto,
      this.menuDesc,
      this.menuPrice,
      this.menuStock,
      this.likes,
      this.rating,
      this.isDanus,
      this.isLike,
      this.categoryMenuName,
      this.merchantId,
      this.variants});

  DataSpecificMenu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuName = json['menuName'];
    menuPhoto = json['menuPhoto'];
    menuDesc = json['menuDesc'];
    menuPrice = json['menuPrice'];
    menuStock = json['menuStock'];
    likes = json['likes'];
    rating = json['rating'];
    isDanus = json['isDanus'];
    isLike = json['isLike'];
    categoryMenuName = json['categoryMenuName'];
    merchantId = json['merchantId'];
    if (json['variants'] != null) {
      variants = <detailmerchant.Variant>[];
      json['variants'].forEach((v) {
        variants!.add(new detailmerchant.Variant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['menuName'] = this.menuName;
    data['menuPhoto'] = this.menuPhoto;
    data['menuDesc'] = this.menuDesc;
    data['menuPrice'] = this.menuPrice;
    data['menuStock'] = this.menuStock;
    data['likes'] = this.likes;
    data['rating'] = this.rating;
    data['isDanus'] = this.isDanus;
    data['isLike'] = this.isLike;
    data['categoryMenuName'] = this.categoryMenuName;
    data['merchantId'] = this.merchantId;
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Variants {
//   int? id;
//   String? variantName;
//   bool? isRequired;
//   int? minimal;
//   int? maximal;
//   List<VariantOptions>? variantOptions;

//   Variants(
//       {this.id,
//       this.variantName,
//       this.isRequired,
//       this.minimal,
//       this.maximal,
//       this.variantOptions});

//   Variants.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     variantName = json['variantName'];
//     isRequired = json['isRequired'];
//     minimal = json['minimal'];
//     maximal = json['maximal'];
//     if (json['variantOptions'] != null) {
//       variantOptions = <VariantOptions>[];
//       json['variantOptions'].forEach((v) {
//         variantOptions!.add(new VariantOptions.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['variantName'] = this.variantName;
//     data['isRequired'] = this.isRequired;
//     data['minimal'] = this.minimal;
//     data['maximal'] = this.maximal;
//     if (this.variantOptions != null) {
//       data['variantOptions'] =
//           this.variantOptions!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class VariantOptions {
//   int? id;
//   String? variantOptionName;
//   int? variantOptionPrice;

//   VariantOptions({this.id, this.variantOptionName, this.variantOptionPrice});

//   VariantOptions.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     variantOptionName = json['variantOptionName'];
//     variantOptionPrice = json['variantOptionPrice'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['variantOptionName'] = this.variantOptionName;
//     data['variantOptionPrice'] = this.variantOptionPrice;
//     return data;
//   }
// }
