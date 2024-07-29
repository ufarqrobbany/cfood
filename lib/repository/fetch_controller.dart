import 'dart:convert';
import 'dart:io';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/error_response.dart';
import 'package:cfood/model/reponse_handler.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cfood/utils/constant.dart';

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

  Future<dynamic> getData() async {
    Uri url = getUrl();
    final response = await http.get(
      url,
      headers: headers,
    );

    log('response: ${response.body}');

    if (response.statusCode <= 300) {
      log(response.body);
      return fromJson(json.decode(response.body));
    } else {
      ErrorResponse data = errorResponseFromJson(response.body);
      log(response.body);
      showToast(data.error!);
      throw Exception(data.status);
    }
  }

  Future<dynamic> postData(Map<String, dynamic> body) async {
    Uri url = getUrl();
    final response =
        await http.post(url, headers: headers, body: json.encode(body));

    log("data : $body");

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
    final response =
        await http.put(url, headers: headers, body: json.encode(body));

    log("response: ${response.body}");
    if (response.statusCode <= 300) {
      log(response.body);
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

  Future<void> deleteData() async {
    Uri url = getUrl();
    final response = await http.delete(url, headers: headers);

    if (response.statusCode <= 300) {
      log(response.body);
      return fromJson(json.decode(response.body));
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
    // required List<MultipartFile> files,
  }) async {
    try {
      Dio dio = Dio();
      Uri url = getUrl();

      // FormData formData = FormData();

      // // Add text fields
      // formData.fields.add(MapEntry(
      //   dataKeyName,
      //   json.encode(data),
      // ));

      // log(json.encode(data).toString());

      //  // Add single file
      // String fileName = file.path.split('/').last;
      // formData.files.add(MapEntry(
      //   fileKeyName,
      //   await MultipartFile.fromFile(file.path, filename: fileName),
      // ));

      // FormData creation
      FormData formData = FormData.fromMap({
        dataKeyName: json.encode(data),
        fileKeyName: await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last),
      });

      log("Request URL: $url");
      log("Request Headers: $headers");
      log("FormData: ${formData.fields}, ${formData.files}");

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

  void log(String message) {
    // Implement your logging logic here (e.g., print to console, save to file, etc.)
    debugPrint(message);
  }

  // void showToast(String message) {
  //   // Implement your toast notification logic here
  //   // For example, using FlutterToast or any other package
  // }
}
