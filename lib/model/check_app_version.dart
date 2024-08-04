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
    data = json['data'] != null ? new DataVersion.fromJson(json['data']) : null;
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

class DataVersion {
  bool? isLatest;
  String? latestVersion;

  DataVersion({this.isLatest, this.latestVersion});

  DataVersion.fromJson(Map<String, dynamic> json) {
    isLatest = json['isLatest'];
    latestVersion = json['latestVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isLatest'] = this.isLatest;
    data['latestVersion'] = this.latestVersion;
    return data;
  }
}
