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
        data!.add(new DataQuantityMenu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    data['message'] = this.message;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuId'] = this.menuId;
    data['quantity'] = this.quantity;
    return data;
  }
}
