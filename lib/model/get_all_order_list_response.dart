class OrderListResponse {
  int? statusCode;
  String? status;
  String? message;
  DataOrders? data;

  OrderListResponse({this.statusCode, this.status, this.message, this.data});

  OrderListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ?  DataOrders.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
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
        all!.add(OrderItem.fromJson(v));
      });
    }
    if (json['inProcess'] != null) {
      inProcess = <OrderItem>[];
      json['inProcess'].forEach((v) {
        inProcess!.add(OrderItem.fromJson(v));
      });
    }
    if (json['done'] != null) {
      done = <OrderItem>[];
      json['done'].forEach((v) {
        done!.add(OrderItem.fromJson(v));
      });
    }
    if (json['cancelled'] != null) {
      cancelled = <OrderItem>[];
      json['cancelled'].forEach((v) {
        cancelled!.add(OrderItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
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

  OrderItem(
      {this.id,
      this.orderNumber,
      this.orderDate,
      this.status,
      this.orderInformation});

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['orderNumber'];
    orderDate = json['orderDate'];
    status = json['status'];
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
  MerchantInformation? merchantInformation;
  List<OrderItemInformations>? orderItemInformations;

  OrderInformation(
      {this.orderId, this.merchantInformation, this.orderItemInformations});

  OrderInformation.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    merchantInformation = json['merchantInformation'] != null
        ?  MerchantInformation.fromJson(json['merchantInformation'])
        : null;
    if (json['orderItemInformations'] != null) {
      orderItemInformations = <OrderItemInformations>[];
      json['orderItemInformations'].forEach((v) {
        orderItemInformations!.add( OrderItemInformations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['orderId'] = this.orderId;
    if (this.merchantInformation != null) {
      data['merchantInformation'] = this.merchantInformation!.toJson();
    }
    if (this.orderItemInformations != null) {
      data['orderItemInformations'] =
          this.orderItemInformations!.map((v) => v.toJson()).toList();
    }
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
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['merchantId'] = this.merchantId;
    data['merchantName'] = this.merchantName;
    data['merchantType'] = this.merchantType;
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
        ?  MenuInformation.fromJson(json['menuInformation'])
        : null;
    if (json['orderVariantInformations'] != null) {
      orderVariantInformations = <OrderVariantInformations>[];
      json['orderVariantInformations'].forEach((v) {
        orderVariantInformations!.add( OrderVariantInformations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
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
    final Map<String, dynamic> data =  Map<String, dynamic>();
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

// class All {
//   int? id;
//   String? orderNumber;
//   String? orderDate;
//   String? status;
//   OrderInformation? orderInformation;

//   All(
//       {this.id,
//       this.orderNumber,
//       this.orderDate,
//       this.status,
//       this.orderInformation});

//   All.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     orderNumber = json['orderNumber'];
//     orderDate = json['orderDate'];
//     status = json['status'];
//     orderInformation = json['orderInformation'] != null
//         ?  OrderInformation.fromJson(json['orderInformation'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     data['id'] = this.id;
//     data['orderNumber'] = this.orderNumber;
//     data['orderDate'] = this.orderDate;
//     data['status'] = this.status;
//     if (this.orderInformation != null) {
//       data['orderInformation'] = this.orderInformation!.toJson();
//     }
//     return data;
//   }
// }

// class Done {
//   int? id;
//   String? orderNumber;
//   String? orderDate;
//   String? status;
//   OrderInformation? orderInformation;

//   Done(
//       {this.id,
//       this.orderNumber,
//       this.orderDate,
//       this.status,
//       this.orderInformation});

//   Done.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     orderNumber = json['orderNumber'];
//     orderDate = json['orderDate'];
//     status = json['status'];
//     orderInformation = json['orderInformation'] != null
//         ?  OrderInformation.fromJson(json['orderInformation'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     data['id'] = this.id;
//     data['orderNumber'] = this.orderNumber;
//     data['orderDate'] = this.orderDate;
//     data['status'] = this.status;
//     if (this.orderInformation != null) {
//       data['orderInformation'] = this.orderInformation!.toJson();
//     }
//     return data;
//   }
// }

// class InProcess {
//   int? id;
//   String? orderNumber;
//   String? orderDate;
//   String? status;
//   OrderInformation? orderInformation;

//   InProcess(
//       {this.id,
//       this.orderNumber,
//       this.orderDate,
//       this.status,
//       this.orderInformation});

//   InProcess.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     orderNumber = json['orderNumber'];
//     orderDate = json['orderDate'];
//     status = json['status'];
//     orderInformation = json['orderInformation'] != null
//         ?  OrderInformation.fromJson(json['orderInformation'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     data['id'] = this.id;
//     data['orderNumber'] = this.orderNumber;
//     data['orderDate'] = this.orderDate;
//     data['status'] = this.status;
//     if (this.orderInformation != null) {
//       data['orderInformation'] = this.orderInformation!.toJson();
//     }
//     return data;
//   }
// }

// class Cancelled {
//   int? id;
//   String? orderNumber;
//   String? orderDate;
//   String? status;
//   OrderInformation? orderInformation;

//   Cancelled(
//       {this.id,
//       this.orderNumber,
//       this.orderDate,
//       this.status,
//       this.orderInformation});

//   Cancelled.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     orderNumber = json['orderNumber'];
//     orderDate = json['orderDate'];
//     status = json['status'];
//     orderInformation = json['orderInformation'] != null
//         ?  OrderInformation.fromJson(json['orderInformation'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     data['id'] = this.id;
//     data['orderNumber'] = this.orderNumber;
//     data['orderDate'] = this.orderDate;
//     data['status'] = this.status;
//     if (this.orderInformation != null) {
//       data['orderInformation'] = this.orderInformation!.toJson();
//     }
//     return data;
//   }
// }
