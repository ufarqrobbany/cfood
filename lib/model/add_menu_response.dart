import 'dart:convert';

AddMenuResponse addMenuResponseFromJson(String str) => AddMenuResponse.fromJson(json.decode(str));

class AddMenuResponse {
  int? statusCode;
  String? status;
  String? message;
  DataAddMenu? data;

  AddMenuResponse({this.statusCode, this.status, this.message, this.data});

  AddMenuResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataAddMenu.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataAddMenu {
  int? id;
  String? menuName;
  String? menuPhoto;
  String? menuDesc;
  int? menuPrice;
  int? menuStock;
  bool? isDanus;
  int? merchantId;
  List<Variants>? variants;

  DataAddMenu({
    this.id,
    this.menuName,
    this.menuPhoto,
    this.menuDesc,
    this.menuPrice,
    this.menuStock,
    this.isDanus,
    this.merchantId,
    this.variants
  });

  DataAddMenu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuName = json['menuName'];
    menuPhoto = json['menuPhoto'];
    menuDesc = json['menuDesc'];
    menuPrice = json['menuPrice'];
    menuStock = json['menuStock'];
    isDanus = json['isDanus'];
    merchantId = json['merchantId'];
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(Variants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['menuName'] = this.menuName;
    data['menuPhoto'] = this.menuPhoto;
    data['menuDesc'] = this.menuDesc;
    data['menuPrice'] = this.menuPrice;
    data['menuStock'] = this.menuStock;
    data['isDanus'] = this.isDanus;
    data['merchantId'] = this.merchantId;
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Variants {
  int? id;
  String? variantName;
  bool? isRequired;
  int? minimal;
  int? maximal;
  List<VariantOptions>? variantOptions;

  Variants({
    this.id,
    this.variantName,
    this.isRequired,
    this.minimal,
    this.maximal,
    this.variantOptions
  });

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    variantName = json['variantName'];
    isRequired = json['isRequired'];
    minimal = json['minimal'];
    maximal = json['maximal'];
    if (json['variantOptions'] != null) {
      variantOptions = <VariantOptions>[];
      json['variantOptions'].forEach((v) {
        variantOptions!.add(VariantOptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['variantName'] = this.variantName;
    data['isRequired'] = this.isRequired;
    data['minimal'] = this.minimal;
    data['maximal'] = this.maximal;
    if (this.variantOptions != null) {
      data['variantOptions'] = this.variantOptions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariantOptions {
  int? id;
  String? variantOptionName;
  int? variantOptionPrice;

  VariantOptions({
    this.id,
    this.variantOptionName,
    this.variantOptionPrice
  });

  VariantOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    variantOptionName = json['variantOptionName'];
    variantOptionPrice = json['variantOptionPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['variantOptionName'] = this.variantOptionName;
    data['variantOptionPrice'] = this.variantOptionPrice;
    return data;
  }
}
