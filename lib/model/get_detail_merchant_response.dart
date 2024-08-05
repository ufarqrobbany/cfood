
import 'package:cfood/model/reponse_handler.dart';

class GetDetailMerchantResponse {
  int? statusCode;
  String? status;
  String? message;
  DataDetailMerchant? data;

  GetDetailMerchantResponse(
      {this.statusCode, this.status, this.message, this.data});

  GetDetailMerchantResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? DataDetailMerchant.fromJson(json['data'])
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

class DataDetailMerchant {
  int? merchantId;
  String? merchantName;
  String? merchantPhoto;
  String? merchantDesc;
  String? merchantType;
  int? followers;
  double? rating;
  String? location;
  StudentInformation? studentInformation;
  DanusInformation? danusInformation;
  List<MenusMerchant>? menusMerchant;
  bool? open;
  bool? follow;

  DataDetailMerchant(
      {this.merchantId,
      this.merchantName,
      this.merchantPhoto,
      this.merchantDesc,
      this.merchantType,
      this.followers,
      this.rating,
      this.location,
      this.studentInformation,
      this.danusInformation,
      this.menusMerchant,
      this.open,
      this.follow});

  DataDetailMerchant.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    merchantName = json['merchantName'];
    merchantPhoto = json['merchantPhoto'];
    merchantDesc = json['merchantDesc'];
    merchantType = json['merchantType'];
    followers = json['followers'];
    rating = json['rating'];
    location = json['location'];
    studentInformation = json['studentInformation'] != null
        ? StudentInformation.fromJson(json['studentInformation'])
        : null;
    danusInformation = json['danusInformation'] != null
        ? DanusInformation.fromJson(json['danusInformation'])
        : null;
    if (json['menusMerchant'] != null) {
      menusMerchant = <MenusMerchant>[];
      json['menusMerchant'].forEach((v) {
        menusMerchant!.add(MenusMerchant.fromJson(v));
      });
    }
    open = json['open'];
    follow = json['follow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantId'] = merchantId;
    data['merchantName'] = merchantName;
    data['merchantPhoto'] = merchantPhoto;
    data['merchantDesc'] = merchantDesc;
    data['merchantType'] = merchantType;
    data['followers'] = followers;
    data['rating'] = rating;
    data['location'] = location;
    if (studentInformation != null) {
      data['studentInformation'] = studentInformation!.toJson();
    }
    if (danusInformation != null) {
      data['danusInformation'] = danusInformation!.toJson();
    }
    if (menusMerchant != null) {
      data['menusMerchant'] = menusMerchant!.map((v) => v.toJson()).toList();
    }
    data['open'] = open;
    data['follow'] = follow;
    return data;
  }
}

class StudentInformation {
  int? studentId;
  int? userId;
  String? userName;
  String? userPhoto;
  int? campusId;
  String? campusName;
  String? majorName;
  String? studyProgramName;

  StudentInformation(
      {this.studentId,
      this.userId,
      this.userName,
      this.userPhoto,
      this.campusId,
      this.campusName,
      this.majorName,
      this.studyProgramName});

  StudentInformation.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    userId = json['userId'];
    userName = json['userName'];
    userPhoto = json['userPhoto'];
    campusId = json['campusId'];
    campusName = json['campusName'];
    majorName = json['majorName'];
    studyProgramName = json['studyProgramName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['studentId'] = studentId;
    data['userId'] = userId;
    data['userName'] = userName;
    data['userPhoto'] = userPhoto;
    data['campusId'] = campusId;
    data['campusName'] = campusName;
    data['majorName'] = majorName;
    data['studyProgramName'] = studyProgramName;
    return data;
  }
}

class DanusInformation {
  int? organizationId;
  String? organizationName;
  String? organizationPhoto;
  int? activityId;
  String? activityName;

  DanusInformation(
      {this.organizationId,
      this.organizationName,
      this.organizationPhoto,
      this.activityId,
      this.activityName});

  DanusInformation.fromJson(Map<String, dynamic> json) {
    organizationId = json['organizationId'];
    organizationName = json['organizationName'];
    organizationPhoto = json['organizationPhoto'];
    activityId = json['activityId'];
    activityName = json['activityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['organizationId'] = organizationId;
    data['organizationName'] = organizationName;
    data['organizationPhoto'] = organizationPhoto;
    data['activityId'] = activityId;
    data['activityName'] = activityName;
    return data;
  }
}

class MenusMerchant {
  String? categoryMenuName;
  List<Menu>? menus;

  MenusMerchant({this.categoryMenuName, this.menus});

  MenusMerchant.fromJson(Map<String, dynamic> json) {
    categoryMenuName = json['categoryMenuName'];
    if (json['menus'] != null) {
      menus = <Menu>[];
      json['menus'].forEach((v) {
        menus!.add(Menu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryMenuName'] = categoryMenuName;
    if (menus != null) {
      data['menus'] = menus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Menu {
  int? id;
  String? menuName;
  String? menuPhoto;
  String? menuDesc;
  int? menuPrice;
  int? menuStock;
  int? menuLikes;
  int? menuSolds;
  int? quantity;
  double? menuRate;
  bool? isDanus;
  bool? isLike;
  String? categoryMenuName;
  int? merchantId;
  List<Variant>? variants;
  int? selectedCount;
  int? subTotal;

  Menu({
    this.id,
    this.menuName,
    this.menuPhoto,
    this.menuDesc,
    this.menuPrice,
    this.menuStock,
    this.menuLikes,
    this.menuSolds,
    this.quantity,
    this.menuRate,
    this.isDanus,
    this.isLike,
    this.categoryMenuName,
    this.merchantId,
    this.variants,
    this.selectedCount,
    this.subTotal,
  });

  Menu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuName = json['menuName'];
    menuPhoto = json['menuPhoto'];
    menuDesc = json['menuDesc'];
    menuPrice = json['menuPrice'];
    menuStock = json['menuStock'];
    menuLikes = json['menuLikes'];
    menuSolds = json['menuSolds'];
    quantity = json['quantity'];
    menuRate = json['menuRate'];
    isDanus = json['isDanus'];
    isLike = json['isLike'];
    categoryMenuName = json['categoryMenuName'];
    selectedCount = 0;
    subTotal = 0;
    merchantId = json['merchantId'];
    if (json['variants'] != null) {
      variants = <Variant>[];
      json['variants'].forEach((v) {
        variants!.add(Variant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['menuName'] = menuName;
    data['menuPhoto'] = menuPhoto;
    data['menuDesc'] = menuDesc;
    data['menuPrice'] = menuPrice;
    data['menuStock'] = menuStock;
    data['menuLikes'] = menuLikes;
    data['menuSolds'] = menuSolds;
    data['quantity'] = quantity;
    data['menuRate'] = menuRate;
    data['isDanus'] = isDanus;
    data['isLike'] = isLike;
    data['categoryMenuName'] = categoryMenuName;
    data['merchantId'] = merchantId;
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Variant {
  int? id;
  String? variantName;
  bool? isRequired;
  int? minimal;
  int? maximal;
  bool? selected;
  bool? valid;
  List<VariantOption>? variantOptions;

  Variant({
    this.id,
    this.variantName,
    this.isRequired,
    this.minimal,
    this.maximal,
    this.selected,
    this.valid,
    this.variantOptions,
  });

  Variant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    variantName = json['variantName'];
    isRequired = json['isRequired'];
    minimal = json['minimal'];
    maximal = json['maximal'];
    selected = false;
    valid = false;
    if (json['variantOptions'] != null) {
      variantOptions = <VariantOption>[];
      json['variantOptions'].forEach((v) {
        variantOptions!.add(VariantOption.fromJson(v));
      });
    }
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (variantName != null) data['variantName'] = variantName;
    if (isRequired != null) data['isRequired'] = isRequired;
    if (minimal != null) data['minimal'] = minimal;
    if (maximal != null) data['maximal'] = maximal;
    if (variantOptions != null) {
      data['variantOption'] = variantOptions!.map((v) => v.toJson()).toList();
    }
    return removeNullsFromModel(data);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['variantName'] = variantName;
  //   data['isRequired'] = isRequired;
  //   data['minimal'] = minimal;
  //   data['maximal'] = maximal;
  //   if (variantOptions != null) {
  //     data['variantOptions'] = variantOptions!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class VariantOption {
  int? id;
  String? variantOptionName;
  int? variantOptionPrice;
  bool? selected;

  VariantOption(
      {this.id,
      this.variantOptionName,
      this.variantOptionPrice,
      this.selected});

  VariantOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    variantOptionName = json['variantOptionName'];
    variantOptionPrice = json['variantOptionPrice'];
    selected = false;
  }

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (variantOptionName != null) data['variantOptionName'] = variantOptionName;
    if (variantOptionPrice != null) data['variantOptionPrice'] = variantOptionPrice;
    return removeNullsFromModel(data);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['variantOptionName'] = variantOptionName;
  //   data['variantOptionPrice'] = variantOptionPrice;
  //   return data;
  // }
}
