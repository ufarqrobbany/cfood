class CheckVersionAppResponse {
  int? statusCode;
  String? status;
  String? message;
  DataVersion? data;

  CheckVersionAppResponse(
      {this.statusCode, this.status, this.message, this.data});

  CheckVersionAppResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataVersion.fromJson(json['data']) : null;
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

class DataVersion {
  bool? isLatest;
  String? latestVersion;

  DataVersion({this.isLatest, this.latestVersion});

  DataVersion.fromJson(Map<String, dynamic> json) {
    isLatest = json['isLatest'];
    latestVersion = json['latestVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isLatest'] = isLatest;
    data['latestVersion'] = latestVersion;
    return data;
  }
}
