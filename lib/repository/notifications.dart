import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/main.dart';
import 'package:cfood/model/get_detail_merchant_response.dart';
import 'package:cfood/screens/canteen.dart';
import 'package:cfood/screens/inbox.dart';
import 'package:cfood/screens/main.dart';
import 'package:cfood/screens/organization.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';

class NotificationController {
  final String? notifType;
  final DataDetailMerchant? dataMerchant;
  final Menu? dataMenu;
  final DanusInformation? dataDanus;

  NotificationController({
    this.notifType,
    this.dataMerchant,
    this.dataMenu,
    this.dataDanus,
  });
  // Inisialisasi notifikasi lokal
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/logo_mini',
      // null,
      // 'resource://assets/logo_mini',
      [
        NotificationChannel(
          channelKey: '1',
          channelName: 'CFood Official',
          channelDescription: 'Official Notification from CFood developer',
          defaultColor: Warna.biru,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: '2',
          channelName: 'Kantin',
          channelDescription: 'Notification from Canteen followed by user',
          defaultColor: Warna.biru,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: '3',
          channelName: 'Wirausaha',
          channelDescription: 'Notification from Wirausaha followed by user',
          defaultColor: Warna.biru,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: '4',
          channelName: 'Kurir',
          channelDescription: 'Notification from kurir',
          defaultColor: Warna.biru,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
      ],
      debug: true,
    );
  }

  // Inisialisasi Isolate untuk menerima port
  static Future<void> initializeIsolateReceivePort() async {
    IsolateNameServer.registerPortWithName(
      ReceivePort().sendPort,
      'notification_send_port',
    );
  }

  // Method untuk menampilkan dialog atau alasan mengapa aplikasi membutuhkan notifikasi
  static Future<bool> displayNotificationRationale() async {
    // Menampilkan dialog atau UI untuk meyakinkan pengguna memberikan izin notifikasi
    bool userGrantedPermission = await showDialog<bool>(
          context: MyApp.navigatorKey.currentContext!,
          builder: (context) {
            return AlertDialog(
              title: Text('Notification Permission'),
              content: Text(
                  'Aplikasi ini memerlukan izin notifikasi untuk memberi tahu Anda tentang hal penting.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Tolak'),
                ),
                TextButton(
                  onPressed: () {
                    AwesomeNotifications()
                        .requestPermissionToSendNotifications()
                        .then((value) {
                      Navigator.of(context).pop(value);
                    });
                  },
                  child: Text('Izinkan'),
                ),
              ],
            );
          },
        ) ??
        false;

    return userGrantedPermission;
  }

  // listener actions
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification, BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Notification created ${receivedNotification.channelKey}',
        ),
        backgroundColor: Warna.biru,
      ),
    );
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  Future<void> onActionReceivedMethod(ReceivedAction receivedAction, BuildContext context) async {
    log(receivedAction.payload.toString());
    log('Received notification action with type: ${receivedAction.payload!['notifType']}');

    // String type = receivedAction.payload!['notifType'].toString();
    // String? menuId = receivedAction.payload!['dataMenuId'].toString();
    // int? merchantId =
    //     int.parse(receivedAction.payload!['merchantId'].toString());
    // String? merchantType = receivedAction.payload!['dataMerchantType'].toString();
    // bool? isDanus = receivedAction.payload?['isDanus'] == 'yes' ? true : false;
    // int? danusId = int.parse(receivedAction.payload!['danusId'].toString());

    if (receivedAction.payload?['notifType'] == 'menu') {
      log(receivedAction.channelKey!);
      log("notif ${receivedAction.payload!['notifType']} go to ${receivedAction.payload!['notifType']} screen, menuId : ${ receivedAction.payload!['dataMenuId'].toString()},");
      if(receivedAction.buttonKeyInput == 'detail') {
        MyApp.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => CanteenScreen(
              key: MyApp.navigatorKey,
              isOwner: false,
              itsDanusan: receivedAction.payload?['isDanus'] == 'yes' ? true : false,
              menuId:  receivedAction.payload?['dataMenuId'].toString(),
              merchantId: int.parse(receivedAction.payload!['merchantId'].toString()),
              merchantType: receivedAction.payload!['dataMerchantType'].toString(),
            ),
          ),
          (route) => route.isActive
          );
      } else if (receivedAction.buttonKeyInput == 'buy') {
        MyApp.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => CanteenScreen(
              isOwner: false,
              itsDanusan: receivedAction.payload?['isDanus'] == 'yes' ? true : false,
              menuId:  receivedAction.payload!['dataMenuId'].toString(),
              merchantId: int.parse(receivedAction.payload!['merchantId'].toString()),
              merchantType: receivedAction.payload!['dataMerchantType'].toString(),
            ),
          ),
          (route) => route.isFirst);
      }
      MyApp.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => CanteenScreen(
              isOwner: false,
              itsDanusan: receivedAction.payload?['isDanus'] == 'yes' ? true : false,
              menuId:  receivedAction.payload!['dataMenuId'].toString(),
              merchantId: int.parse(receivedAction.payload!['merchantId'].toString()),
              merchantType: receivedAction.payload!['dataMerchantType'].toString(),
            ),
          ),
          (route) => route.isFirst);
      //  MyApp.navigatorKey.currentState?.pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (context) => InboxScreen(),
      //     ),
      //     (route) => route.isFirst);
    } else if (receivedAction.payload?['notifType'] == 'merchant') {
      log(receivedAction.channelKey!);
      log("notif ${receivedAction.payload!['notifType']} go to ${receivedAction.payload!['notifType']} screen, merchantType : ${ receivedAction.payload!['dataMerchantType']}");
      MyApp.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => CanteenScreen(
              isOwner: false,
              itsDanusan: receivedAction.payload?['isDanus'] == 'yes' ? true : false,
              merchantId: int.parse(receivedAction.payload!['merchantId'].toString()),
              merchantType: receivedAction.payload!['dataMerchantType'].toString(),
            ),
          ),
          (route) => route.isFirst);
    } else if (receivedAction.payload?['notifType'] == 'danus') {
      MyApp.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => OrganizationScreen(
              id: int.parse(receivedAction.payload!['danusId'].toString()),
            ),
          ),
          (route) => route.isFirst);
    } else {
      MyApp.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
          (route) => route.isFirst);
    }
  }

  // Membuat Notifikasi Baru
  Future<void> createNotification({
    required int channelId,
    required String channelKey,
    required String title,
    required String body,
    String? bigPictureUrl,
    String? largeIconUrl,
    Map<String, String>? payload,
    String? icon,
  }) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed)
      isAllowed = await NotificationController.displayNotificationRationale();
    if (!isAllowed) return;

    log("notif $notifType go to $notifType screen");

    await AwesomeNotifications().createNotification(
      // schedule: NotificationCalendar(
      //   day: DateTime.now().day,
      //   month: DateTime.now().month,
      //   year: DateTime.now().year,
      //   hour: DateTime.now().hour,
      //   minute: DateTime.now().minute,
      // ),
      content: NotificationContent(
          id: channelId,
          channelKey: channelKey,
          title: title,
          body: body,
          bigPicture: bigPictureUrl,
          largeIcon: largeIconUrl,
          notificationLayout: NotificationLayout.BigPicture,
          // payload: payload,
          backgroundColor: Warna.biru,
          color: Warna.kuning,
          icon: icon,
          roundedLargeIcon: false,
          payload: notifType == 'menu'
              ? {
                  'notifType': notifType,
                  'dataMenuId': dataMenu?.id.toString(),
                  'merchantId': dataMenu?.merchantId.toString(),
                  'dataMerchantType': dataMerchant?.merchantType ?? '',
                  'isDanus': dataMenu?.isDanus == true ? 'yes' : 'no',
                }
              : notifType == 'merchant'
                  ? {
                      'notifType': notifType,
                      'merchantId': dataMerchant?.merchantId.toString(),
                      'dataMerchantType': dataMerchant?.merchantType ?? '',
                      'isDanus': dataMenu?.isDanus == true ? 'yes' : 'no',
                    }
                  : notifType == 'danus'
                      ? {
                          'danusId': dataDanus?.organizationId.toString(),
                        }
                      : {}),
      actionButtons: notifType == 'menu'
          ? [
              NotificationActionButton(
                key: 'detail',
                label: 'Selengkapnya',
              ),
              NotificationActionButton(
                key: 'buy',
                label: 'Beli',
              ),
            ]
          : [],
    );
  }
}

// class NotificationRepository {
//   // Inisialisasi Notification
//   Future<void> initializeNotifications() async {
//     await NotificationController.initializeLocalNotifications();
//   }

//   // Membuat Notifikasi Baru
//   Future<void> createNotification({
//     required int channelId,
//     required String channelKey,
//     required String title,
//     required String body,
//     String? bigPictureUrl,
//     String? largeIconUrl,
//     Map<String, String>? payload,
//     String? icon,
//   }) async {
//     bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
//     if (!isAllowed)
//       isAllowed = await NotificationController.displayNotificationRationale();
//     if (!isAllowed) return;

//     await AwesomeNotifications().createNotification(
//       // schedule: NotificationCalendar(
//       //   day: DateTime.now().day,
//       //   month: DateTime.now().month,
//       //   year: DateTime.now().year,
//       //   hour: DateTime.now().hour,
//       //   minute: DateTime.now().minute,
//       // ),
//       content: NotificationContent(
//         id: channelId,
//         channelKey: channelKey,
//         title: title,
//         body: body,
//         bigPicture: bigPictureUrl,
//         largeIcon: largeIconUrl,
//         notificationLayout: NotificationLayout.BigPicture,
//         payload: payload,
//         backgroundColor: Warna.biru,
//         color: Warna.kuning,
//         icon: icon,
//         roundedLargeIcon: false,
//         // actionType: Action
//       ),
//       actionButtons: [
//         NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
//         NotificationActionButton(
//             key: 'DISMISS',
//             label: 'Dismiss',
//             actionType: ActionType.DismissAction,
//             isDangerousOption: true),
//       ],
//     );
//   }

//   // Menjadwalkan Notifikasi
//   Future<void> scheduleNotification({
//     required String title,
//     required String body,
//     required int hoursFromNow,
//     String? bigPictureUrl,
//     String? largeIconUrl,
//     Map<String, String>? payload,
//     bool repeatNotif = false,
//   }) async {
//     var scheduledTime = DateTime.now().add(Duration(hours: hoursFromNow));

//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: -1,
//         channelKey: 'alerts',
//         title: title,
//         body: body,
//         bigPicture: bigPictureUrl,
//         largeIcon: largeIconUrl,
//         notificationLayout: NotificationLayout.BigPicture,
//         payload: payload,
//       ),
//       schedule: NotificationCalendar(
//         hour: scheduledTime.hour,
//         minute: scheduledTime.minute,
//         second: scheduledTime.second,
//         repeats: repeatNotif,
//       ),
//       actionButtons: [
//         NotificationActionButton(
//           key: 'REDIRECT',
//           label: 'Redirect',
//         ),
//         NotificationActionButton(
//             key: 'DISMISS',
//             label: 'Dismiss',
//             actionType: ActionType.DismissAction,
//             isDangerousOption: true),
//       ],
//     );
//   }

//   // Reset Badge
//   Future<void> resetBadgeCounter() async {
//     await AwesomeNotifications().resetGlobalBadge();
//   }

//   // Batalkan semua notifikasi
//   Future<void> cancelAllNotifications() async {
//     await AwesomeNotifications().cancelAll();
//   }
// }
