import 'dart:async';
import 'dart:developer';

import 'package:cfood/model/get_rooms_chat.dart';
import 'package:cfood/model/reponse_handler.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/repository/websocket_controller.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class ServiceNotification {
  void initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
        // notificationTitle: 'Location Service',
        // notificationText: 'Running in Background...',
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
      ),
    );

    service.startService();
  }

  static void onStart(ServiceInstance service) async {
    Timer.periodic(const Duration(seconds: 45), (timer) async {
      if (service is AndroidServiceInstance) {
        service.on('stopService').listen((event) {
          service.stopSelf();
        });
      }

      // fetch notification
      await fetcthMessages();
    });
  }

  static Future<void> fetcthMessages() async {
    log('service notification running');
    GetChatRoomResponse? roomResponse;
    DataRoom? dataRoomMerchant;
    int totalUnreadMessages = 0;
    // DataRoom? dataRoomDriver;
    roomResponse = await WebSocketController(
        // endpoint: 'chats/merchants?userId=91',
        endpoint: 'chats/merchants?userId=${AppConfig.USER_ID}',
        fromJson: (json) => GetChatRoomResponse.fromJson(json)).getData();

    if (roomResponse != null) {
      dataRoomMerchant = roomResponse.data;

      if (dataRoomMerchant != null && dataRoomMerchant.rooms != null) {
        // Looping melalui setiap room untuk menjumlahkan unreadMessages
        totalUnreadMessages = dataRoomMerchant.rooms!
            .map((room) =>
                room.unreadMessages ?? 0) // Ambil nilai unreadMessages
            .reduce(
                (value, element) => value + element); // Totalkan unreadMessages

        // Menyimpan total unreadMessages di suatu tempat, misalnya di NotificationConfig
        NotificationConfig.userChatNotification = totalUnreadMessages;

        print('Total unread messages: $totalUnreadMessages');
      }
    }
  }


}

class NotificationUnreads {

    static Future<void> fecthUnreadMessageUser(BuildContext context, {int countDown = 20, int unreadMessage = 0, Function(int updatedUnreadMessage)? onUpdatedMessage}) async {
    // Timer.periodic(const Duration(seconds: 45), (timer) async {
      ResponseHendler response = await FetchController(
          endpoint: 'chats/unreads/user/${AppConfig.USER_ID}',
          fromJson: (json) => ResponseHendler.fromJson(json)).getData();

      if (response.statusCode == 200) {
        unreadMessage = response.data;
        onUpdatedMessage!(unreadMessage);
      }
    // });
  }

  static Future<void> fecthUnreadMessageMerchant(BuildContext context, {int countDown = 20, int unreadMessage = 0, Function(int updatedUnreadMessage)? onUpdatedMessage}) async {
    // Timer.periodic(const Duration(seconds: 45), (timer) async {
      ResponseHendler response = await FetchController(
          endpoint: 'chats/unreads/merchant/${AppConfig.MERCHANT_ID}',
          fromJson: (json) => ResponseHendler.fromJson(json)).getData();

      if (response.statusCode == 200) {
        unreadMessage = response.data;
        onUpdatedMessage!(unreadMessage);
      }
    // });
  }
}
