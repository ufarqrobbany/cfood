
class DeleteCartResponse {
  int? statusCode;
  String? status;
  String? message;
  bool? data;

  DeleteCartResponse({this.statusCode, this.status, this.message, this.data});

  DeleteCartResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    data['data'] = this.data;

    return data;
  }
}
