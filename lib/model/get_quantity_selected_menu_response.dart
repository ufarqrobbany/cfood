class GetQuantitySelectedMenuResponse {
  int? statusCode;
  String? status;
  String? message;
  List<DataQuantityMenu>? data;

  GetQuantitySelectedMenuResponse(
      {this.statusCode, this.status, this.message, this.data});

  GetQuantitySelectedMenuResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataQuantityMenu>[];
      json['data'].forEach((v) {
        data!.add(DataQuantityMenu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataQuantityMenu {
  int? menuId;
  int? quantity;

  DataQuantityMenu({this.menuId, this.quantity});

  DataQuantityMenu.fromJson(Map<String, dynamic> json) {
    menuId = json['menuId'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['menuId'] = menuId;
    data['quantity'] = quantity;
    return data;
  }
}
