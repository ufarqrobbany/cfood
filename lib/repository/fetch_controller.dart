import 'dart:convert';
import 'dart:io';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/error_response.dart';
import 'package:cfood/model/reponse_handler.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:cfood/utils/constant.dart';
import 'package:path/path.dart' as path;

class FetchController {
  final String baseUrl;
  final String endpoint;
  final Map<String, String> headers;
  final Function fromJson;

  FetchController({
    this.baseUrl = AppConfig.BASE_URL,
    required this.endpoint,
    this.headers = const {
      "Content-Type": "application/json",
      "Accept": "*/*",
    },
    required this.fromJson,
  });

  Uri getUrl() {
    return Uri.parse('$baseUrl$endpoint');
  }

  Future<dynamic> getData({bool ignoreErrorToast = false}) async {
    Uri url = getUrl();
    final response = await http.get(
      url,
      headers: headers,
    );

    log('response: ${response.body}');

    if (response.statusCode <= 300) {
      // dynamic data = fromJson(json.decode(response.body));
      log(response.body);
      // showToast(data.message);
      return fromJson(json.decode(response.body));
    } else {
      ErrorResponse data = errorResponseFromJson(response.body);
      log(response.body);
      if (ignoreErrorToast == false) {
        showToast(data.error!);
      }
      throw Exception(data.status);
    }
  }

  Future<dynamic> postData(Map<String, dynamic> body) async {
    Uri url = getUrl();
    final response = await http.post(url,
        headers: headers, body: body == {} ? null : json.encode(body));

    log("data : $body");
    log("response : ${response.body}");

    if (response.statusCode <= 300) {
      log(response.body);
      return fromJson(json.decode(response.body));
    } else if (response.statusCode <= 499) {
      Error400Response data = error400ResponseFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      return {
        'status': 'error',
        'message': data.message
      }; // Mengembalikan error tanpa melempar exception
    } else {
      ErrorResponse data = errorResponseFromJson(response.body);
      log(response.body);
      showToast(data.error!);
      return {
        'status': 'error',
        'message': data.error
      }; // Mengembalikan error tanpa melempar exception
    }
  }

  Future<dynamic> putData(Map<String, dynamic> body) async {
    Uri url = getUrl();
    final response = await http.put(url,
        headers: headers, body: body == {} ? null : json.encode(body));

    log("response: ${response.body}");
    if (response.statusCode <= 300) {
      dynamic data = fromJson(json.decode(response.body));
      log(response.body);
      showToast(data.message!);
      return fromJson(json.decode(response.body));
    } else if (response.statusCode <= 499) {
      ResponseHendler data = responseHendlerFromJson(response.body);
      log(response.body);
      showToast(data.message!);
      return responseHendlerFromJson(
          response.body); // Mengembalikan error tanpa melempar exception
    } else {
      ErrorResponse data = errorResponseFromJson(response.body);
      log(response.body);
      showToast(data.error!);
      throw Exception(data.status);
    }
  }

  Future<dynamic> deleteData() async {
    Uri url = getUrl();
    final response = await http.delete(url, headers: headers);

    log(response.body);

    if (response.statusCode <= 399) {
      log(response.body);
      return fromJson(json.decode(response.body));
    } else if (response.statusCode <= 499) {
      Error400Response data = error400ResponseFromJson(response.body);
      log(response.body);
      showToast(data.status!);
      throw Exception(data.status);
    } else {
      ErrorResponse data = errorResponseFromJson(response.body);
      log(response.body);
      showToast(data.error!);
      throw Exception(data.status);
    }
  }

  // Method to upload file and text data
  Future<dynamic> postMultipartData({
    required String dataKeyName,
    required Map<String, dynamic> data,
    required File file,
    required String fileKeyName,
    bool customToJson = false,
    var dataFromCustomToJson,
    // required List<MultipartFile> files,
  }) async {
    try {
      Dio dio = Dio();
      Uri url = getUrl();

      log(json.encode(data));

      // FormData creation
      FormData formData = FormData.fromMap({
        // dataKeyName: json.encode(data),
        dataKeyName: MultipartFile.fromString(
          customToJson ? dataFromCustomToJson : json.encode(data),
          contentType: MediaType.parse('application/json'),
        ),
        fileKeyName: await MultipartFile.fromFile(
          file.path,
          filename: path.basename(file.path),
          contentType:
              MediaType('image', path.extension(file.path).replaceAll('.', '')),
        ),
      });

      log("Request URL: $url");
      log("Request Headers: $headers");
      log("FormData Fields: ${formData.fields}");
      log("FormData Files: ${formData.files}");

      Response response = await dio.post(
        url.toString(),
        data: formData,
        options: Options(
          headers: headers,
        ),
      );

      log("Response URI: ${response.statusCode}");
      log("Response URI: ${response.realUri}");
      log("Response data: ${response.data}");

      if (response.statusCode! <= 499) {
        log(response.data.toString());
        return fromJson(response.data);
      } else {
        ErrorResponse data = errorResponseFromJson(response.data);
        log(response.data.toString());
        showToast(data.error!);
        return {
          'status': 'error',
          'message': data.error
        }; // Return error without throwing exception
      }
    } catch (e) {
      log(e.toString());
      showToast("An error occurred");
      throw Exception("Failed to upload data");
    }
  }

  Future<dynamic> puttMultipartData({
    required String dataKeyName,
    required Map<String, dynamic> data,
    required File? file,
    required String fileKeyName,
    required bool? withImage,
    // required List<MultipartFile> files,
  }) async {
    try {
      Dio dio = Dio();
      Uri url = getUrl();

      log('Data: ${json.encode(data)}');
      log('File: ${file?.path}');
      String dataEncode = json.encode(data);
      FormData formData = withImage == false
          ? FormData.fromMap({
              dataKeyName: MultipartFile.fromString(
                dataEncode,
                contentType: MediaType.parse('application/json'),
              ),
            })
          : FormData.fromMap({
              dataKeyName: MultipartFile.fromString(
                dataEncode,
                contentType: MediaType.parse('application/json'),
              ),
              fileKeyName: await MultipartFile.fromFile(
                file!.path,
                filename: path.basename(file.path),
                contentType: MediaType(
                    'image', path.extension(file.path).replaceAll('.', '')),
              ),
            });

      // Log formData content to debug
      for (var field in formData.fields) {
        log("FormData Field: ${field.key} = ${field.value}");
      }
      for (var file in formData.files) {
        log("FormData File: ${file.key} = ${file.value.filename}");
      }

      log("Request URL: $url");
      log("Request Headers: $headers");

      Response response = await dio.put(
        url.toString(),
        data: formData,
        options: Options(
          headers: headers,
        ),
      );

      log("Response URI: ${response.statusCode}");
      log("Response URI: ${response.realUri}");
      log("Response data: ${response.data}");

      if (response.statusCode! <= 499) {
        log(response.data.toString());
        return fromJson(response.data);
      } else {
        ErrorResponse data = errorResponseFromJson(response.data);
        log(response.data.toString());
        showToast(data.error!);
        return {
          'status': 'error',
          'message': data.error
        }; // Return error without throwing exception
      }
    } catch (e) {
      log(e.toString());
      showToast("An error occurred");
      throw Exception("Failed to upload data");
    }
  }

  void log(String message) {
    // Implement your logging logic here (e.g., print to console, save to file, etc.)
    debugPrint(message);
  }

  // void showToast(String message) {
  //   // Implement your toast notification logic here
  //   // For example, using FlutterToast or any other package
  // }
}
