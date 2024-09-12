import 'dart:math';

import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

String formatNumberWithThousandsSeparator(int number) {
  final numberFormat = NumberFormat(
      '#,###', 'id_ID'); // Format untuk pemisah ribuan menggunakan titik
  return numberFormat.format(number);
}

String generateRandomString(int length) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
}

// Map<String, String> generateRandomMap() {
//   return {
//     'menu?': generateRandomString(3),
//     'merchant?': generateRandomString(3),
//     'chat?': generateRandomString(3),
//     'kurir?': generateRandomString(3),
//     'danus?': generateRandomString(3),
//     'menuId=': generateRandomString(3),
//     'merchantId=': generateRandomString(3),
//     'merchantType=': generateRandomString(3),
//     'userId=': generateRandomString(3),
//     'danusId=': generateRandomString(3),
//     'organizationId': generateRandomString(3),
//     'kurirId=': generateRandomString(3),
//     'chatId=': generateRandomString(3),
//     'orderId=': generateRandomString(3),
//     'WIRAUSAHA': generateRandomString(3),
//     'REGULER': generateRandomString(3),
//     'KANTIN': generateRandomString(3),
//   };
// }

Map<String, String> generateRandomMap() {
  return {
    'menu?': 'mu',
    'merchant?': 'me',
    'chat?': 'ct',
    'kurir?': 'kr',
    'danus?': 'dn',
    'menuId=': 'mid',
    'merchantId=': 'mrd',
    'merchantType=': 'mt',
    'userId=': 'ui',
    'danusId=': 'di',
    'organizationId': 'oi',
    'kurirId=': 'ki',
    'chatId=': 'ci',
    'orderId=': 'ori',
    'WIRAUSAHA': 'W',
    'REGULER': 'R',
    'KANTIN': 'K',
  };
}

Map<String, String> randomMap = generateRandomMap();

Map<String, String> numberMap = {
  '1': generateRandomString(3),
  '2': generateRandomString(3),
  '3': generateRandomString(3),
  '4': generateRandomString(3),
  '3': generateRandomString(3),
  '6': generateRandomString(3),
  '7': generateRandomString(3),
  '8': generateRandomString(3),
  '9': generateRandomString(3),
};

Map<String, String> punctuationMap = {
  '=': '!',
  '?': '/',
  '&': '^',
  '/': '?',
  ':': ';',
};

// Map<String, String> punctuationMap = {
//   '=': generateRandomString(3),
//   '?': generateRandomString(3),
//   '&': generateRandomString(3),
//   '/': generateRandomString(3),
//   ':': generateRandomString(3),
// };

class UserLocation {

  static const Map<String, dynamic> DATA= {
       "id": 3,
      "type": '',
      "name": "",
      "menu": "",
      "harga": "",
      "lokasi": LatLng(0, 0),
      // "lokasi": const LatLng(-6.871736, 107.574984)
  };
}