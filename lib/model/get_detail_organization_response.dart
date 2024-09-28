
class GetDetailOrganizationResponse {
  int? statusCode;
  String? status;
  String? message;
  DataDetailOrganization? data;

  GetDetailOrganizationResponse(
      {this.statusCode, this.status, this.message, this.data});

  GetDetailOrganizationResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? DataDetailOrganization.fromJson(json['data'])
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

class DataDetailOrganization {
  int? organizationId;
  String? organizationName;
  String? organizationShortname;
  String? organizationLogo;
  int? totalActivity;
  int? totalWirausaha;
  int? totalMenu;
  int? campusId;
  List<Activity>? activities;

  DataDetailOrganization(
      {this.organizationId,
      this.organizationName,
      this.organizationShortname,
      this.organizationLogo,
      this.totalActivity,
      this.totalWirausaha,
      this.totalMenu,
      this.campusId,
      this.activities});

  DataDetailOrganization.fromJson(Map<String, dynamic> json) {
    organizationId = json['organizationId'];
    organizationName = json['organizationName'];
    organizationShortname = json['organizationShortname'];
    organizationLogo = json['organizationLogo'];
    totalActivity = json['totalActivity'];
    totalWirausaha = json['totalWirausaha'];
    totalMenu = json['totalMenu'];
    campusId = json['campusId'];
    if (json['activities'] != null) {
      activities = [];
      json['activities'].forEach((v) {
        activities!.add(Activity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['organizationId'] = organizationId;
    data['organizationName'] = organizationName;
    data['organizationShortname'] = organizationShortname;
    data['organizationLogo'] = organizationLogo;
    data['totalActivity'] = totalActivity;
    data['totalWirausaha'] = totalWirausaha;
    data['totalMenu'] = totalMenu;
    data['campusId'] = campusId;
    if (activities != null) {
      data['activities'] = activities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Activity {
  String? activityName;
  List<Merchant>? merchants;

  Activity({this.activityName, this.merchants});

  Activity.fromJson(Map<String, dynamic> json) {
    activityName = json['activityName'];
    if (json['merchants'] != null) {
      merchants = [];
      json['merchants'].forEach((v) {
        merchants!.add(Merchant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['activityName'] = activityName;
    if (merchants != null) {
      data['merchants'] = merchants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Merchant {
  int? merchantId;
  String? merchantName;
  String? merchantPhoto;
  String? merchantType;
  double? rating;
  int? followers;
  String? location;
  int? userId;
  bool? open;
  bool? danus;

  Merchant(
      {this.merchantId,
      this.merchantName,
      this.merchantPhoto,
      this.merchantType,
      this.rating,
      this.followers,
      this.location,
      this.userId,
      this.open,
      this.danus});

  Merchant.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    merchantName = json['merchantName'];
    merchantPhoto = json['merchantPhoto'];
    merchantType = json['merchantType'];
    rating = json['rating'];
    followers = json['followers'];
    location = json['location'];
    userId = json['userId'];
    open = json['open'];
    danus = json['danus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantId'] = merchantId;
    data['merchantName'] = merchantName;
    data['merchantPhoto'] = merchantPhoto;
    data['merchantType'] = merchantType;
    data['rating'] = rating;
    data['followers'] = followers;
    data['location'] = location;
    data['userId'] = userId;
    data['open'] = open;
    data['danus'] = danus;
    return data;
  }
}
