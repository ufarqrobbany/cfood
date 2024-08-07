class ConfirmCartResponse {
  int statusCode;
  String status;
  String message;
  DataConfirmCart? data;

  ConfirmCartResponse({
    required this.statusCode,
    required this.status,
    required this.message,
    this.data,
  });

  factory ConfirmCartResponse.fromJson(Map<String, dynamic> json) {
    return ConfirmCartResponse(
      statusCode: json['statusCode'],
      status: json['status'],
      message: json['message'],
      data:
          json['data'] != null ? DataConfirmCart.fromJson(json['data']) : null,
    );
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

class DataConfirmCart {
  UserInformation userInformation;
  CartInformation cartInformation;
  int serviceCost;
  int totalPrice;

  DataConfirmCart({
    required this.userInformation,
    required this.cartInformation,
    required this.serviceCost,
    required this.totalPrice,
  });

  factory DataConfirmCart.fromJson(Map<String, dynamic> json) {
    return DataConfirmCart(
      userInformation: UserInformation.fromJson(json['userInformation']),
      cartInformation: CartInformation.fromJson(json['cartInformation']),
      serviceCost: json['serviceCost'],
      totalPrice: json['totalPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userInformation': userInformation.toJson(),
      'cartInformation': cartInformation.toJson(),
      'serviceCost': serviceCost,
      'totalPrice': totalPrice,
    };
  }
}

class UserInformation {
  int userId;
  String userName;
  String? userPhoto;
  CampusInformation? campusInformation;
  StudentInformation? studentInformation;

  UserInformation({
    required this.userId,
    required this.userName,
    required this.userPhoto,
    required this.campusInformation,
    required this.studentInformation,
  });

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    return UserInformation(
      userId: json['userId'],
      userName: json['userName'],
      userPhoto: json['userPhoto'],
      campusInformation: json['campusInformation'] != null ? CampusInformation.fromJson(json['campusInformation']) : null,
      studentInformation: json['studentInformation'] != null ? StudentInformation.fromJson(json['studentInformation']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhoto': userPhoto,
      'campusInformation': campusInformation!.toJson(),
      'studentInformation': studentInformation!.toJson(),
    };
  }
}

class CampusInformation {
  int campusId;
  String campusName;

  CampusInformation({
    required this.campusId,
    required this.campusName,
  });

  factory CampusInformation.fromJson(Map<String, dynamic> json) {
    return CampusInformation(
      campusId: json['campusId'],
      campusName: json['campusName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campusId': campusId,
      'campusName': campusName,
    };
  }
}

class StudentInformation {
  int studentId;
  int? admissionYear;
  String nim;
  StudyProgramInformation studyProgramInformation;
  MajorInformation majorInformation;

  StudentInformation({
    required this.studentId,
    this.admissionYear,
    required this.nim,
    required this.studyProgramInformation,
    required this.majorInformation,
  });

  factory StudentInformation.fromJson(Map<String, dynamic> json) {
    return StudentInformation(
      studentId: json['studentId'],
      admissionYear: json['admissionYear'],
      nim: json['nim'],
      studyProgramInformation:
          StudyProgramInformation.fromJson(json['studyProgramInformation']),
      majorInformation: MajorInformation.fromJson(json['majorInformation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'admissionYear': admissionYear,
      'nim': nim,
      'studyProgramInformation': studyProgramInformation.toJson(),
      'majorInformation': majorInformation.toJson(),
    };
  }
}

class StudyProgramInformation {
  int studyProgramId;
  String studyProgramName;

  StudyProgramInformation({
    required this.studyProgramId,
    required this.studyProgramName,
  });

  factory StudyProgramInformation.fromJson(Map<String, dynamic> json) {
    return StudyProgramInformation(
      studyProgramId: json['studyProgramId'],
      studyProgramName: json['studyProgramName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studyProgramId': studyProgramId,
      'studyProgramName': studyProgramName,
    };
  }
}

class MajorInformation {
  int majorId;
  String majorName;

  MajorInformation({
    required this.majorId,
    required this.majorName,
  });

  factory MajorInformation.fromJson(Map<String, dynamic> json) {
    return MajorInformation(
      majorId: json['majorId'],
      majorName: json['majorName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'majorId': majorId,
      'majorName': majorName,
    };
  }
}

class CartInformation {
  int cartId;
  MerchantInformation merchantInformation;
  List<CartItemInformation> cartItemInformations;
  int totalMenu;
  int totalItem;
  int subTotalPrice;

  CartInformation({
    required this.cartId,
    required this.merchantInformation,
    required this.cartItemInformations,
    required this.totalMenu,
    required this.totalItem,
    required this.subTotalPrice,
  });

  factory CartInformation.fromJson(Map<String, dynamic> json) {
    var cartItemInformationsFromJson = json['cartItemInformations'] as List;
    List<CartItemInformation> cartItemInformationsList =
        cartItemInformationsFromJson
            .map((item) => CartItemInformation.fromJson(item))
            .toList();

    return CartInformation(
      cartId: json['cartId'],
      merchantInformation:
          MerchantInformation.fromJson(json['merchantInformation']),
      cartItemInformations: cartItemInformationsList,
      totalMenu: json['totalMenu'],
      totalItem: json['totalItem'],
      subTotalPrice: json['subTotalPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> cartItemInformationsList =
        cartItemInformations.map((item) => item.toJson()).toList();

    return {
      'cartId': cartId,
      'merchantInformation': merchantInformation.toJson(),
      'cartItemInformations': cartItemInformationsList,
      'totalMenu': totalMenu,
      'totalItem': totalItem,
      'subTotalPrice': subTotalPrice,
    };
  }
}

class MerchantInformation {
  int merchantId;
  String merchantName;
  String merchantType;

  MerchantInformation({
    required this.merchantId,
    required this.merchantName,
    required this.merchantType,
  });

  factory MerchantInformation.fromJson(Map<String, dynamic> json) {
    return MerchantInformation(
      merchantId: json['merchantId'],
      merchantName: json['merchantName'],
      merchantType: json['merchantType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'merchantId': merchantId,
      'merchantName': merchantName,
      'merchantType': merchantType,
    };
  }
}

class CartItemInformation {
  int cartItemId;
  int quantity;
  int totalPriceItem;
  MenuInformation menuInformation;
  List<CartVariantInformation> cartVariantInformations;

  CartItemInformation({
    required this.cartItemId,
    required this.quantity,
    required this.totalPriceItem,
    required this.menuInformation,
    required this.cartVariantInformations,
  });

  factory CartItemInformation.fromJson(Map<String, dynamic> json) {
    var cartVariantInformationsFromJson =
        json['cartVariantInformations'] as List;
    List<CartVariantInformation> cartVariantInformationsList =
        cartVariantInformationsFromJson
            .map((item) => CartVariantInformation.fromJson(item))
            .toList();

    return CartItemInformation(
      cartItemId: json['cartItemId'],
      quantity: json['quantity'],
      totalPriceItem: json['totalPriceItem'],
      menuInformation: MenuInformation.fromJson(json['menuInformation']),
      cartVariantInformations: cartVariantInformationsList,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> cartVariantInformationsList =
        cartVariantInformations.map((item) => item.toJson()).toList();

    return {
      'cartItemId': cartItemId,
      'quantity': quantity,
      'totalPriceItem': totalPriceItem,
      'menuInformation': menuInformation.toJson(),
      'cartVariantInformations': cartVariantInformationsList,
    };
  }
}

class MenuInformation {
  int menuId;
  String menuName;
  String menuPhoto;
  int menuPrice;

  MenuInformation({
    required this.menuId,
    required this.menuName,
    required this.menuPhoto,
    required this.menuPrice,
  });

  factory MenuInformation.fromJson(Map<String, dynamic> json) {
    return MenuInformation(
      menuId: json['menuId'],
      menuName: json['menuName'],
      menuPhoto: json['menuPhoto'],
      menuPrice: json['menuPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuId': menuId,
      'menuName': menuName,
      'menuPhoto': menuPhoto,
      'menuPrice': menuPrice,
    };
  }
}

class CartVariantInformation {
  int variantId;
  String variantName;
  List<VariantOptionInformation> variantOptionInformations;

  CartVariantInformation({
    required this.variantId,
    required this.variantName,
    required this.variantOptionInformations,
  });

  factory CartVariantInformation.fromJson(Map<String, dynamic> json) {
    var variantOptionInformationsFromJson =
        json['variantOptionInformations'] as List;
    List<VariantOptionInformation> variantOptionInformationsList =
        variantOptionInformationsFromJson
            .map((item) => VariantOptionInformation.fromJson(item))
            .toList();

    return CartVariantInformation(
      variantId: json['variantId'],
      variantName: json['variantName'],
      variantOptionInformations: variantOptionInformationsList,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> variantOptionInformationsList =
        variantOptionInformations.map((item) => item.toJson()).toList();

    return {
      'variantId': variantId,
      'variantName': variantName,
      'variantOptionInformations': variantOptionInformationsList,
    };
  }
}

class VariantOptionInformation {
  int cartVariantId;
  int variantOptionId;
  String variantOptionName;
  int variantOptionPrice;

  VariantOptionInformation({
    required this.cartVariantId,
    required this.variantOptionId,
    required this.variantOptionName,
    required this.variantOptionPrice,
  });

  factory VariantOptionInformation.fromJson(Map<String, dynamic> json) {
    return VariantOptionInformation(
      cartVariantId: json['cartVariantId'],
      variantOptionId: json['variantOptionId'],
      variantOptionName: json['variantOptionName'],
      variantOptionPrice: json['variantOptionPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartVariantId': cartVariantId,
      'variantOptionId': variantOptionId,
      'variantOptionName': variantOptionName,
      'variantOptionPrice': variantOptionPrice,
    };
  }
}
