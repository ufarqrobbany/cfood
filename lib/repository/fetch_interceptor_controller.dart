import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cfood/utils/constant.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

class LoggerInterceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    debugPrint('----- Request -----');
    debugPrint(request.toString());
    debugPrint(request.headers.toString());
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    debugPrint('----- Response -----');
    debugPrint('Code: ${response.statusCode}');
    if (response is Response) {
      debugPrint(response.body);
    }
    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() {
    // Implement the logic to determine if a request should be intercepted
    return true; // For now, it always intercepts requests
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    // Implement the logic to determine if a response should be intercepted
    return true; // For now, it always intercepts responses
  }
}

class FetchInterceptorController {
  final BuildContext context;
  final String baseUrl;
  final String endpoint;
  final Map<String, String> headers;
  final Function fromJson;
  final http.Client client;

  FetchInterceptorController({
    required this.context,
    this.baseUrl = AppConfig.BASE_URL,
    required this.endpoint,
    this.headers = const {
      "Content-Type": "application/json",
      "Accept": "*/*",
    },
    required this.fromJson,
  }) : client = InterceptedClient.build(
          interceptors: [LoggerInterceptor()],
          client: IOClient(
            HttpClient()
              ..badCertificateCallback =
                  (X509Certificate cert, String host, int port) => true,
          ),
        );

  Uri getUrl() {
    return Uri.parse('$baseUrl$endpoint');
  }

  Future<dynamic> getData() async {
    Uri url = getUrl();
    final response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      log(response.body);
      return fromJson(json.decode(response.body));
    } else {
      log('Failed to load data');
      throw Exception('Failed to load data');
    }
  }

    Future<dynamic> postData(dynamic body) async {
    Uri url = getUrl();
    final response = await client.post(url, headers: headers, body: json.encode(body));

    if (response.statusCode <= 399) {
      log(response.body);
      var data = fromJson(json.decode(response.body));
      showToast(data.message);
      return fromJson(json.decode(response.body));
    } else {
      log('Failed to post data');
      throw Exception('Failed to post data');
    }
  }

  void log(String message) {
    // Implement your logging logic here (e.g., print to console, save to file, etc.)
    debugPrint(message);
  }

  void showToast(String message) {
    // Implement your toast notification logic here
    // For example, using FlutterToast or any other package
  }
}
