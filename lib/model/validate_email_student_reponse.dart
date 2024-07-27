import 'dart:convert';


ValidateEmailStudentReponse validateEmailStudentReponseFromJson(String str) => ValidateEmailStudentReponse.fromJson(json.decode(str));

String validateEmailStudentReponseToJson(ValidateEmailStudentReponse data) => json.encode(data);


class ValidateEmailStudentReponse {
  int? statusCode;
  String? status;
  String? message;
  DataValidateEmailStudent? data;

  ValidateEmailStudentReponse({this.statusCode, this.status, this.message, this.data});

  factory ValidateEmailStudentReponse.fromJson(Map<String, dynamic> json) {
    return ValidateEmailStudentReponse(
      statusCode: json['statusCode'],
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? DataValidateEmailStudent.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class DataValidateEmailStudent {
  String? email;
  bool? valid;

  DataValidateEmailStudent({this.email, this.valid});

  factory DataValidateEmailStudent.fromJson(Map<String, dynamic> json) {
    return DataValidateEmailStudent(
      email: json['email'],
      valid: json['valid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'valid': valid,
    };
  }
}

