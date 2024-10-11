class TransactionMerchantResponseModel {
  int? statusCode;
  String? status;
  String? message;
  DataOrders? data;

  TransactionMerchantResponseModel(
      {this.statusCode, this.status, this.message, this.data});

  TransactionMerchantResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DataOrders.fromJson(json['data']) : null;
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

class DataOrders {
  List<OrderItem>? all;
  List<OrderItem>? inProcess;
  List<OrderItem>? done;
  List<OrderItem>? cancelled;

  DataOrders({this.all, this.inProcess, this.done, this.cancelled});

  DataOrders.fromJson(Map<String, dynamic> json) {
    if (json['all'] != null) {
      all = <OrderItem>[];
      json['all'].forEach((v) {
        all!.add(new OrderItem.fromJson(v));
      });
    }
    if (json['inProcess'] != null) {
      inProcess = <OrderItem>[];
      json['inProcess'].forEach((v) {
        inProcess!.add(new OrderItem.fromJson(v));
      });
    }
    if (json['done'] != null) {
      done = <OrderItem>[];
      json['done'].forEach((v) {
        done!.add(new OrderItem.fromJson(v));
      });
    }
    if (json['cancelled'] != null) {
      cancelled = <OrderItem>[];
      json['cancelled'].forEach((v) {
        cancelled!.add(new OrderItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.all != null) {
      data['all'] = this.all!.map((v) => v.toJson()).toList();
    }
    if (this.inProcess != null) {
      data['inProcess'] = this.inProcess!.map((v) => v.toJson()).toList();
    }
    if (this.done != null) {
      data['done'] = this.done!.map((v) => v.toJson()).toList();
    }
    if (this.cancelled != null) {
      data['cancelled'] = this.cancelled!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItem {
  int? id;
  String? orderNumber;
  String? orderDate;
  String? status;
  OrderInformation? orderInformation;
  int? totalPrice;

  OrderItem(
      {this.id,
      this.orderNumber,
      this.orderDate,
      this.status,
      this.totalPrice,
      this.orderInformation});

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['orderNumber'];
    orderDate = json['orderDate'];
    status = json['status'];
    totalPrice = json['totalPrice'];
    orderInformation = json['orderInformation'] != null
        ?  OrderInformation.fromJson(json['orderInformation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    data['orderDate'] = this.orderDate;
    data['status'] = this.status;
    if (this.orderInformation != null) {
      data['orderInformation'] = this.orderInformation!.toJson();
    }
    return data;
  }
}

class OrderInformation {
  int? orderId;
  UserInformation? userInformation;
  List<OrderItemInformations>? orderItemInformations;

  OrderInformation(
      {this.orderId, this.userInformation, this.orderItemInformations});

  OrderInformation.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    userInformation = json['userInformation'] != null
        ? new UserInformation.fromJson(json['userInformation'])
        : null;
    if (json['orderItemInformations'] != null) {
      orderItemInformations = <OrderItemInformations>[];
      json['orderItemInformations'].forEach((v) {
        orderItemInformations!.add(new OrderItemInformations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    if (this.userInformation != null) {
      data['userInformation'] = this.userInformation!.toJson();
    }
    if (this.orderItemInformations != null) {
      data['orderItemInformations'] =
          this.orderItemInformations!.map((v) => v.toJson()).toList();
    }
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

class OrderItemInformations {
  int? orderItemId;
  int? quantity;
  int? totalPriceItem;
  MenuInformation? menuInformation;
  List<OrderVariantInformations>? orderVariantInformations;

  OrderItemInformations(
      {this.orderItemId,
      this.quantity,
      this.totalPriceItem,
      this.menuInformation,
      this.orderVariantInformations});

  OrderItemInformations.fromJson(Map<String, dynamic> json) {
    orderItemId = json['orderItemId'];
    quantity = json['quantity'];
    totalPriceItem = json['totalPriceItem'];
    menuInformation = json['menuInformation'] != null
        ? new MenuInformation.fromJson(json['menuInformation'])
        : null;
    if (json['orderVariantInformations'] != null) {
      orderVariantInformations = <OrderVariantInformations>[];
      json['orderVariantInformations'].forEach((v) {
        orderVariantInformations!.add(new OrderVariantInformations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderItemId'] = this.orderItemId;
    data['quantity'] = this.quantity;
    data['totalPriceItem'] = this.totalPriceItem;
    if (this.menuInformation != null) {
      data['menuInformation'] = this.menuInformation!.toJson();
    }
    if (this.orderVariantInformations != null) {
      data['orderVariantInformations'] =
          this.orderVariantInformations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuInformation {
  int? menuId;
  String? menuName;
  String? menuPhoto;
  int? menuPrice;

  MenuInformation({this.menuId, this.menuName, this.menuPhoto, this.menuPrice});

  MenuInformation.fromJson(Map<String, dynamic> json) {
    menuId = json['menuId'];
    menuName = json['menuName'];
    menuPhoto = json['menuPhoto'];
    menuPrice = json['menuPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuId'] = this.menuId;
    data['menuName'] = this.menuName;
    data['menuPhoto'] = this.menuPhoto;
    data['menuPrice'] = this.menuPrice;
    return data;
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
            .add(new VariantOptionInformations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderVariantId'] = this.orderVariantId;
    data['variantOptionId'] = this.variantOptionId;
    data['variantOptionName'] = this.variantOptionName;
    data['variantOptionPrice'] = this.variantOptionPrice;
    return data;
  }
}

// class OrderItemInformations {
//   int? orderItemId;
//   int? quantity;
//   int? totalPriceItem;
//   MenuInformation? menuInformation;
//   List<VariantOptionInformations>? orderVariantInformations;

//   OrderItemInformations(
//       {this.orderItemId,
//       this.quantity,
//       this.totalPriceItem,
//       this.menuInformation,
//       this.orderVariantInformations});

//   OrderItemInformations.fromJson(Map<String, dynamic> json) {
//     orderItemId = json['orderItemId'];
//     quantity = json['quantity'];
//     totalPriceItem = json['totalPriceItem'];
//     menuInformation = json['menuInformation'] != null
//         ? new MenuInformation.fromJson(json['menuInformation'])
//         : null;
//     if (json['orderVariantInformations'] != null) {
//       orderVariantInformations = <VariantOptionInformations>[];
//       json['orderVariantInformations'].forEach((v) {
//         orderVariantInformations!.add(new VariantOptionInformations.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['orderItemId'] = this.orderItemId;
//     data['quantity'] = this.quantity;
//     data['totalPriceItem'] = this.totalPriceItem;
//     if (this.menuInformation != null) {
//       data['menuInformation'] = this.menuInformation!.toJson();
//     }
//     if (this.orderVariantInformations != null) {
//       data['orderVariantInformations'] =
//           this.orderVariantInformations!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
