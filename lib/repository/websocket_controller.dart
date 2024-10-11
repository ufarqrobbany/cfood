import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cfood/utils/constant.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketController {
  final String baseUrl; // URL dasar dari WebSocket
  final String endpoint;
  final Function fromJson;
  final Map<String, String> headers;
  late WebSocketChannel _channel;
  final String action;

  WebSocketController({
    this.baseUrl = "ws://cfood.id/api/ws/",// Contoh URL WebSocket
    required this.endpoint,
    required this.fromJson,
    this.action = 'fetch_data',
    this.headers = const {
      "Content-Type": "application/json",
      "Accept": "*/*",
    },
  }) {
    _initializeWebSocket();
  }

  // Inisialisasi WebSocket
  void _initializeWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('$baseUrl$endpoint'),
    );
  }

  // Fungsi untuk mendapatkan data dari WebSocket
  Future<dynamic> getData() async {
    try {
      // Mengirim pesan untuk memulai request data (jika dibutuhkan)
      _channel.sink.add(json.encode({
        'action': action, // Sesuaikan action dengan kebutuhan
        'headers': headers,
      }));

      // Mendengarkan pesan yang datang dari WebSocket
      final completer = Completer<dynamic>();
      _channel.stream.listen(
        (message) {
          log('Received WebSocket message: $message');
          final data = json.decode(message);

          // Parsing data dengan fromJson
          final parsedData = fromJson(data);
          completer.complete(parsedData);
        },
        onError: (error) {
          log('WebSocket error: $error');
          completer.completeError(error);
        },
        onDone: () {
          log('WebSocket connection closed');
        },
      );

      return completer.future;
    } catch (e) {
      log('Error fetching data via WebSocket: $e');
      throw Exception('Failed to fetch data via WebSocket');
    }
  }

  // Fungsi untuk menutup WebSocket
  void closeWebSocket() {
    log("Closing WebSocket connection...");
    _channel.sink.close(status.goingAway);
  }
}
