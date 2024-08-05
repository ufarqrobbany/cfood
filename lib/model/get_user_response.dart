import 'dart:convert';

GetUserResponse getUserResponseFromJson(String str) => GetUserResponse.fromJson(json.decode(str));

class GetUserResponse {
  int? statusCode;
  String? status;
  String? message;
  DataUser? data;

  GetUserResponse({this.statusCode, this.status, this.message, this.data});

  factory GetUserResponse.fromJson(Map<String, dynamic> json) => GetUserResponse(
    statusCode: json["statusCode"],
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : DataUser.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class DataUser {
  int? id;
  String? name;
  String? email;
  dynamic userPhoto;
  DataUserCampus? campus;
  StudentInformation? studentInformation;
  dynamic isPenjual;
  MerchantInformation? merchantInformation;
  bool? kurir;

  DataUser({
    this.id,
    this.name,
    this.email,
    this.userPhoto,
    this.campus,
    this.studentInformation,
    this.isPenjual,
    this.merchantInformation,
    this.kurir,
  });

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    userPhoto: json["userPhoto"],
    campus: json["campus"] == null ? null : DataUserCampus.fromJson(json["campus"]),
    studentInformation: json["studentInformation"] == null ? null : StudentInformation.fromJson(json["studentInformation"]),
    isPenjual: json["isPenjual"],
    merchantInformation: json["merchantInformation"] == null ? null : MerchantInformation.fromJson(json["merchantInformation"]),
    kurir: json["kurir"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "userPhoto": userPhoto,
    "campus": campus?.toJson(),
    "studentInformation": studentInformation?.toJson(),
    "isPenjual": isPenjual,
    "merchantInformation": merchantInformation,
    "kurir": kurir,
  };
}

class DataUserCampus {
  int? id;
  String? campusName;

  DataUserCampus({this.id, this.campusName});

  factory DataUserCampus.fromJson(Map<String, dynamic> json) => DataUserCampus(
    id: json["id"],
    campusName: json["campusName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "campusName": campusName,
  };
}

class StudentInformation {
  int? id;
  String? nim;
  String? admissionYear;
  DataUserMajor? major;
  StudyProgram? studyProgram;

  StudentInformation({
    this.id,
    this.nim,
    this.admissionYear,
    this.major,
    this.studyProgram,
  });

  factory StudentInformation.fromJson(Map<String, dynamic> json) => StudentInformation(
    id: json["id"],
    nim: json["nim"],
    admissionYear: json["admissionYear"],
    major: json["major"] == null ? null : DataUserMajor.fromJson(json["major"]),
    studyProgram: json["studyProgram"] == null ? null : StudyProgram.fromJson(json["studyProgram"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nim": nim,
    "admissionYear": admissionYear,
    "major": major?.toJson(),
    "studyProgram": studyProgram?.toJson(),
  };
}

class DataUserMajor {
  int? id;
  String? majorName;

  DataUserMajor({this.id, this.majorName});

  factory DataUserMajor.fromJson(Map<String, dynamic> json) => DataUserMajor(
    id: json["id"],
    majorName: json["majorName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "majorName": majorName,
  };
}

class StudyProgram {
  int? id;
  String? programName;

  StudyProgram({this.id, this.programName});

  factory StudyProgram.fromJson(Map<String, dynamic> json) => StudyProgram(
    id: json["id"],
    programName: json["programName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "programName": programName,
  };
}

class MerchantInformation {
  int? merchantId;
  String? merchantName;
  String? merchantPhoto;
  String? merchantDesc;
  String? merchantType;

  MerchantInformation(
      {this.merchantId,
      this.merchantName,
      this.merchantPhoto,
      this.merchantDesc,
      this.merchantType,});

  MerchantInformation.fromJson(Map<String, dynamic> json) {
    merchantId = json['id'];
    merchantName = json['merchantName'];
    merchantPhoto = json['merchantPhoto'];
    merchantDesc = json['merchantDesc'];
    merchantType = json['merchantType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantId'] = merchantId;
    data['merchantName'] = merchantName;
    data['merchantPhoto'] = merchantPhoto;
    data['merchantDesc'] = merchantDesc;
    data['merchantType'] = merchantType;
    return data;
  }
}
