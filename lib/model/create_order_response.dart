import 'package:cfood/model/confirm_cart_response.dart';

class CreateOrderResponse {
  int? statusCode;
  String? status;
  String? message;
  DataOrder? data;

  CreateOrderResponse({this.statusCode, this.status, this.message, this.data});

  CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DataOrder.fromJson(json['data']) : null;
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

class DataOrder {
  int? id;
  String? orderNumber;
  String? orderDate;
  String? note;
  String? status;
  UserInformation? userInformation;
  OrderInformation? orderInformation;
  String? paymentMethod;
  int? serviceCost;
  int? shippingCost;
  int? voucherCost;
  int? totalPrice;

  DataOrder(
      {this.id,
      this.orderNumber,
      this.orderDate,
      this.note,
      this.status,
      this.userInformation,
      this.orderInformation,
      this.paymentMethod,
      this.serviceCost,
      this.shippingCost,
      this.voucherCost,
      this.totalPrice});

  DataOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['orderNumber'];
    orderDate = json['orderDate'];
    note = json['note'];
    status = json['status'];
    userInformation = json['userInformation'] != null
        ? new UserInformation.fromJson(json['userInformation'])
        : null;
    orderInformation = json['orderInformation'] != null
        ? new OrderInformation.fromJson(json['orderInformation'])
        : null;
    paymentMethod = json['paymentMethod'];
    serviceCost = json['serviceCost'];
    shippingCost = json['shippingCost'];
    voucherCost = json['voucherCost'];
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    data['orderDate'] = this.orderDate;
    data['note'] = this.note;
    data['status'] = this.status;
    if (this.userInformation != null) {
      data['userInformation'] = this.userInformation!.toJson();
    }
    if (this.orderInformation != null) {
      data['orderInformation'] = this.orderInformation!.toJson();
    }
    data['paymentMethod'] = this.paymentMethod;
    data['serviceCost'] = this.serviceCost;
    data['shippingCost'] = this.shippingCost;
    data['voucherCost'] = this.voucherCost;
    data['totalPrice'] = this.totalPrice;
    return data;
  }
}

class UserInformation {
  int? userId;
  String? userName;
  String? userPhoto;
  CampusInformation? campusInformation;
  StudentInformation? studentInformation;

  UserInformation(
      {this.userId,
      this.userName,
      this.userPhoto,
      this.campusInformation,
      this.studentInformation});

  UserInformation.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    userPhoto = json['userPhoto'];
    campusInformation = json['campusInformation'] != null
        ? new CampusInformation.fromJson(json['campusInformation'])
        : null;
    studentInformation = json['studentInformation'] != null
        ? new StudentInformation.fromJson(json['studentInformation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['userPhoto'] = this.userPhoto;
    if (this.campusInformation != null) {
      data['campusInformation'] = this.campusInformation!.toJson();
    }
    if (this.studentInformation != null) {
      data['studentInformation'] = this.studentInformation!.toJson();
    }
    return data;
  }
}

class CampusInformation {
  int? campusId;
  String? campusName;

  CampusInformation({this.campusId, this.campusName});

  CampusInformation.fromJson(Map<String, dynamic> json) {
    campusId = json['campusId'];
    campusName = json['campusName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['campusId'] = this.campusId;
    data['campusName'] = this.campusName;
    return data;
  }
}

class StudentInformation {
  int? studentId;
  int? addmissionYear;
  String? nim;
  StudyProgramInformation? studyProgramInformation;
  MajorInformation? majorInformation;

  StudentInformation(
      {this.studentId,
      this.addmissionYear,
      this.nim,
      this.studyProgramInformation,
      this.majorInformation});

  StudentInformation.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    addmissionYear = json['addmissionYear'];
    nim = json['nim'];
    studyProgramInformation = json['studyProgramInformation'] != null
        ? new StudyProgramInformation.fromJson(json['studyProgramInformation'])
        : null;
    majorInformation = json['majorInformation'] != null
        ? new MajorInformation.fromJson(json['majorInformation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentId'] = this.studentId;
    data['addmissionYear'] = this.addmissionYear;
    data['nim'] = this.nim;
    if (this.studyProgramInformation != null) {
      data['studyProgramInformation'] = this.studyProgramInformation!.toJson();
    }
    if (this.majorInformation != null) {
      data['majorInformation'] = this.majorInformation!.toJson();
    }
    return data;
  }
}

class StudyProgramInformation {
  int? studyProgramId;
  String? studyProgramName;

  StudyProgramInformation({this.studyProgramId, this.studyProgramName});

  StudyProgramInformation.fromJson(Map<String, dynamic> json) {
    studyProgramId = json['studyProgramId'];
    studyProgramName = json['studyProgramName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studyProgramId'] = this.studyProgramId;
    data['studyProgramName'] = this.studyProgramName;
    return data;
  }
}

class MajorInformation {
  int? majorId;
  String? majorName;

  MajorInformation({this.majorId, this.majorName});

  MajorInformation.fromJson(Map<String, dynamic> json) {
    majorId = json['majorId'];
    majorName = json['majorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['majorId'] = this.majorId;
    data['majorName'] = this.majorName;
    return data;
  }
}

class OrderInformation {
  int? orderId;
  MerchantInformation? merchantInformation;
  List<OrderItemInformation>? orderItemInformations;
  int? totalMenu;
  int? totalItem;
  int? subTotalPrice;

  OrderInformation(
      {this.orderId,
      this.merchantInformation,
      this.orderItemInformations,
      this.totalMenu,
      this.totalItem,
      this.subTotalPrice});

  OrderInformation.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    merchantInformation = json['merchantInformation'] != null
        ? new MerchantInformation.fromJson(json['merchantInformation'])
        : null;
    if (json['orderItemInformations'] != null) {
      orderItemInformations = <OrderItemInformation>[];
      json['orderItemInformations'].forEach((v) {
        orderItemInformations!.add(new OrderItemInformation.fromJson(v));
      });
    }
    totalMenu = json['totalMenu'];
    totalItem = json['totalItem'];
    subTotalPrice = json['subTotalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    if (this.merchantInformation != null) {
      data['merchantInformation'] = this.merchantInformation!.toJson();
    }
    if (this.orderItemInformations != null) {
      data['orderItemInformations'] =
          this.orderItemInformations!.map((v) => v.toJson()).toList();
    }
    data['totalMenu'] = this.totalMenu;
    data['totalItem'] = this.totalItem;
    data['subTotalPrice'] = this.subTotalPrice;
    return data;
  }
}

class OrderItemInformation {
  int cartItemId;
  int quantity;
  int totalPriceItem;
  MenuInformation menuInformation;
  List<OrderVariantInformations> cartVariantInformations;

  OrderItemInformation({
    required this.cartItemId,
    required this.quantity,
    required this.totalPriceItem,
    required this.menuInformation,
    required this.cartVariantInformations,
  });

  factory OrderItemInformation.fromJson(Map<String, dynamic> json) {
    var cartVariantInformationsFromJson =
        json['orderVariantInformations'] as List;
    List<OrderVariantInformations> cartVariantInformationsList =
        cartVariantInformationsFromJson
            .map((item) => OrderVariantInformations.fromJson(item))
            .toList();

    return OrderItemInformation(
      cartItemId: json['orderItemId'],
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
      'orderItemId': cartItemId,
      'quantity': quantity,
      'totalPriceItem': totalPriceItem,
      'menuInformation': menuInformation.toJson(),
      'orderVariantInformations': cartVariantInformationsList,
    };
  }
}

class OrderVariantInformations {
  int? variantId;
  String? variantName;
  List<VariantOptionInformations>? variantOptionInformations;

  OrderVariantInformations(
      {this.variantId, this.variantName, this.variantOptionInformations});

  OrderVariantInformations.fromJson(Map<String, dynamic> json) {
    variantId = json['variantId'];
    variantName = json['variantName'];
    if (json['variantOptionInformations'] != null) {
      variantOptionInformations = <VariantOptionInformations>[];
      json['variantOptionInformations'].forEach((v) {
        variantOptionInformations!
            .add( VariantOptionInformations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['variantId'] = this.variantId;
    data['variantName'] = this.variantName;
    if (this.variantOptionInformations != null) {
      data['variantOptionInformations'] =
          this.variantOptionInformations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariantOptionInformations {
  int? orderVariantId;
  int? variantOptionId;
  String? variantOptionName;
  int? variantOptionPrice;

  VariantOptionInformations(
      {this.orderVariantId,
      this.variantOptionId,
      this.variantOptionName,
      this.variantOptionPrice});

  VariantOptionInformations.fromJson(Map<String, dynamic> json) {
    orderVariantId = json['orderVariantId'];
    variantOptionId = json['variantOptionId'];
    variantOptionName = json['variantOptionName'];
    variantOptionPrice = json['variantOptionPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['orderVariantId'] = this.orderVariantId;
    data['variantOptionId'] = this.variantOptionId;
    data['variantOptionName'] = this.variantOptionName;
    data['variantOptionPrice'] = this.variantOptionPrice;
    return data;
  }
}

class MerchantInformation {
  int? merchantId;
  String? merchantName;
  String? merchantType;

  MerchantInformation({this.merchantId, this.merchantName, this.merchantType});

  MerchantInformation.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    merchantName = json['merchantName'];
    merchantType = json['merchantType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['merchantId'] = this.merchantId;
    data['merchantName'] = this.merchantName;
    data['merchantType'] = this.merchantType;
    return data;
  }
}


