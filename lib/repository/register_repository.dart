import 'dart:convert';
import 'dart:developer';

import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/add_student_response.dart';
import 'package:cfood/model/add_user_response.dart';
import 'package:cfood/model/campuses_list_reponse.dart';
import 'package:cfood/model/check_email_response.dart';
import 'package:cfood/model/check_nim_response.dart';
import 'package:cfood/model/check_verify_email_response.dart';
import 'package:cfood/model/error_response.dart';
import 'package:cfood/model/major_list_reponse.dart';
import 'package:cfood/model/otp_check_response.dart';
import 'package:cfood/model/otp_response.dart';
import 'package:cfood/model/reponse_handler.dart';
import 'package:cfood/model/study_program_list_reponse.dart';
import 'package:cfood/model/validate_email_student_reponse.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterRepository {
  Future<CampusesListResponse> getDataCampuses() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}campuses/");
    final response = await http.get(url, headers: {});

    if (response.statusCode == 200) {
      log(response.body);
      return campusesListReponseFromJson(response.body);
    } else {
      CampusesListResponse data = campusesListReponseFromJson(response.body);
      showToast(data.message!);
      throw Exception('Failed to load data');
    }
  }

  Future<CheckEmailResponse> checkPostEmail(
      {String email = '', BuildContext? context}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}users/check-email");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
      },
      body: json.encode(
        {
          "email": email,
        },
      ),
    );

    if (response.statusCode <= 299) {
      log("check email ${response.body}");
      return checkEmailResponseFromJson(response.body);
    } else if (response.statusCode <= 499) {
      Error400Response data = error400ResponseFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      throw Exception(data.message);
    } else {
      ErrorResponse data = errorResponseFromJson(response.body);
      log(response.body);
      showToast(data.error!);
      throw Exception(data.status);
    }
    // else {
    //   CheckEmailResponse data = checkEmailResponseFromJson(response.body);
    //   log(response.body.toString());
    //   showToast(data.message!);
    //   throw Exception('Failed to load data');
    // }
  }

  Future<CheckVerifyEmailResponse> checkGetVerifyEmail(
      {String email = '', BuildContext? context}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}users/check-verify?email=$email");
    final response = await http.get(
      url,
    );

    if (response.statusCode <= 299) {
      log(response.body);
      return checkVerifyEmailResponseFromJson(response.body);
    } else if (response.statusCode <= 499) {
      Error400Response data = error400ResponseFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      throw Exception(data.message);
    } else {
      ErrorResponse data = errorResponseFromJson(response.body);
      log(response.body);
      showToast(data.error!);
      throw Exception(data.status);
    }
    // else {
    //   CheckVerifyEmailResponse data =
    //       checkVerifyEmailResponseFromJson(response.body);
    //   log("chek verify email : ${response.body}");
    //   showToast(data.message!);
    //   throw Exception('Failed to load data');
    // }
  }

  Future<ValidateEmailStudentReponse> validateEmailStudent(
      {String email = '', int campusId = 0, BuildContext? context}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}users/validate-student-email");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: json.encode({
          "email": email,
          "campusId": campusId,
        }));

    if (response.statusCode <= 299) {
      log("validate email student : ${response.body}");
      // ValidateEmailStudentReponse data = validateEmailStudentReponseFromJson(response.body);
      // showToast(response.body.)
      final parsedResponse = validateEmailStudentReponseFromJson(response.body);
      log("Parsed response: ${parsedResponse.data?.email}, ${parsedResponse.data?.valid}");
      return validateEmailStudentReponseFromJson(response.body);
    } else if (response.statusCode <= 499) {
      Error400Response data = error400ResponseFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      throw Exception(data.message);
    } else {
      ErrorResponse data = errorResponseFromJson(response.body);
      log(response.body);
      showToast(data.error!);
      throw Exception(data.status);
    }
    // else {
    //   ValidateEmailStudentReponse data =
    //       validateEmailStudentReponseFromJson(response.body);
    //   log(response.body);
    //   showToast(data.message!);
    //   throw Exception('Failed to load data');
    // }
  }

  // Page Sign-Up Student

  Future<MajorListReponse> getDataMajorList({int? campusId}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}majors/?campusId=$campusId");
    final response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      log(response.body);
      return majorListReponseFromJson(response.body);
    } else if (response.statusCode <= 499) {
      Error400Response data = error400ResponseFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      throw Exception(data.statusCode);
    } else {
      MajorListReponse data = majorListReponseFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      throw Exception('Failed to load data');
    }
  }

  Future<StudyProgramListReponse> getStudyProgramList(
      {int? majorId = 0}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}study-programs/?majorId=$majorId");
    final response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      log(response.body);
      return studyProgramListReponseFromJson(response.body);
    } else if (response.statusCode <= 500) {
      Error400Response data = error400ResponseFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      throw Exception(data.statusCode);
    } else {
      StudyProgramListReponse data =
          studyProgramListReponseFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      throw Exception('Failed to load data');
    }
  }

  Future<CheckNimResponse> checkPostNIM(
    BuildContext? context, {
    int nim = 0,
  }) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}students/check-nim");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: json.encode({
          "nim": nim,
        }));

    if (response.statusCode <= 400) {
      CheckNimResponse data = checkNimReponseFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      return checkNimReponseFromJson(response.body);
    } else {
      CheckNimResponse data = checkNimReponseFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      throw Exception('Failed to load data');
    }
  }

  Future<AddUserResponse> addPostUser(
    BuildContext? context, {
    String name = '',
    String email = '',
    String password = '',
    int campusId = 0,
  }) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}users/");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'campusId': campusId,
        }));

    log('response add user: ${response.body}');

    if (response.statusCode <= 300) {
      log(response.body);
      return addUserResponseFromJson(response.body);
    } else if (response.statusCode <= 499) {
      Error400Response data = error400ResponseFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      throw Exception(data.message);
    } else {
      ErrorResponse data = errorResponseFromJson(response.body);
      log(response.body);
      showToast(data.error!);
      throw Exception(data.status);
    }
  }

  Future<AddStudentResponse> addPostStudent(
    BuildContext? context, {
    int nim = 0,
    int admissionYear = 0,
    int campusId = 0,
    int majorId = 0,
    int studyProgramId = 0,
    int userId = 0,
  }) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}students/");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: json.encode({
          'nim': nim,
          'admissionYear': admissionYear,
          'campusId': campusId,
          'majorId': majorId,
          'studyProgramId': studyProgramId,
          'userId': userId,
        }));

    log("response add student: ${response.body}");

    if (response.statusCode <= 399) {
      AddStudentResponse data = addStudentResponseFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      return addStudentResponseFromJson(response.body);
    } else if (response.statusCode <= 499) {
      Error400Response data = error400ResponseFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      throw Exception(data.message);
    } else {
      // AddStudentResponse data = addStudentResponseFromJson(response.body);
      ErrorResponse data = errorResponseFromJson(response.body);
      log("error add student : ${response.body}");
      showToast(data.error!);
      throw Exception(data.status);
    }
  }

  Future<OtpResponse> sendPostOtp(
    BuildContext? context, {
    int userId = 0,
    String? to = '',
    String? name = '',
    String? type = '',
  }) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}mails/send-otp");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: json.encode({
          'userId': userId,
          'type': type,
        }));

    log(response.body);
    if (response.statusCode <= 300) {
      OtpResponse data = otpResponseFromJson(response.body);
      showToast(data.message!);
      return otpResponseFromJson(response.body);
    } else if (response.statusCode <= 499) {
      Error400Response data = error400ResponseFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      throw Exception(data.message);
    } else {
      ErrorResponse data = errorResponseFromJson(response.body);
      log(response.body);
      showToast(data.error!);
      throw Exception(data.error);
    }
  }

  Future<OtpCheckResponse> checkPostOtp(
    BuildContext? context, {
    int userId = 0,
    int otpCode = 0,
    String otpType = '',
  }) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}mails/check-otp");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: json.encode({
          'userId': userId,
          'otpCode': otpCode,
          'otpType': otpType,
        }));

    log(response.body);
    if (response.statusCode <= 399) {
      OtpCheckResponse data = otpCheckResponseFromJson(response.body);
      showToast(data.message!);
      return otpCheckResponseFromJson(response.body);
    } else if(response.statusCode <= 499) {
      OtpCheckResponse data = otpCheckResponseFromJson(response.body);
      showToast(data.message!);
      log(response.body);
      throw Exception(data.status);
    } else {
      ErrorResponse data = errorResponseFromJson(response.body);
      log(response.body);
      showToast(data.error!);
      throw Exception(data.status);
    }
  }

  Future<ResponseHendler> verifyUser(
    BuildContext? context, {
    int userId = 0,
  }) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}users/$userId/verify");
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "*/*",
      },
    );

    log(response.body);
    if (response.statusCode <= 500) {
      return responseHendlerFromJson(response.body);
    } else {
      ErrorResponse data = errorResponseFromJson(response.body);
      log(response.body);
      showToast(data.error!);
      throw Exception(data.status);
    }
  }
}
