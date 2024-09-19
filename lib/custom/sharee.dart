import 'dart:developer';
import 'dart:io';

import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/popup_dialog.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_share/social_share.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart' as crypto;

Map<String, String> randomDataMap = {
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

void onTapOpenShareOption(
  BuildContext context, {
  required String? pathSegment,
  String? menuId,
  String? merchantId,
  String? danusId,
  String? merchantType,
  String? imageUrl,
  String menuName = '',
  String merchantName = '',
  String danusName = '',
  String dsc = '',
  String menuPrice = '',
}) async {
  log('generate url');
  String url = '';
  if (pathSegment == 'menu') {
    url =
        "$pathSegment?menuId=$menuId&merchantId=$merchantId&merchantType=$merchantType";
  } else if (pathSegment == 'merchant') {
    url = "$pathSegment?merchantId=$merchantId&merchantType=$merchantType";
  } else if (pathSegment == 'danus') {
    url = "$pathSegment?danusId=$danusId";
  }

  String encryptedUrl = encryptUrl(
    url,
  );
  // Clipboard.setData(ClipboardData(text: encryptedUrl));
  log('Encrypted URL : $encryptedUrl');

  String realUrl = "${AppConfig.APPLINK_DOMAIN}$encryptedUrl";
  log("real url: $realUrl");

  String decryptedUrl = decryptUrl(
    encryptedUrl,
  );
  log('Decrypted URL : $decryptedUrl');

  // CREATE TEXT SHARE
  String textShare = '';
  if (pathSegment == 'menu') {
    // setState(() {
    textShare =
        "🍴 $menuName tersedia di $merchantName di Campus Food!\n\nNikmati $dsc, hanyan dengan Rp$menuPrice.\n\nPesan sekarang: $realUrl\n\n#CampusFood #$merchantName";
    // });
  } else if (pathSegment == 'merchant') {
    // setState(() {
    textShare =
        "🏪 Temukan $merchantName di Campus Food!\n\n$dsc.\nJelajahi semua menu kami di sini: $realUrl\n\n#CampusFood #$merchantName";
    // });
  } else if (pathSegment == 'danus') {
    // setState(() {
    textShare =
        "🎓 Dukung Danusan $danusName di Campus Food!\n\nBantu kami dengan membeli menu kami di: $realUrl\n\n#CampusFood #Danusan #$danusName";
    // });
  }

  // SAVE IMG TO TEMPORARY DIR
  final response =
      await get(Uri.parse("${AppConfig.URL_IMAGES_PATH}$imageUrl"));
  final documentDirectory = await getApplicationDocumentsDirectory();

  // Menyimpan gambar sebagai file lokal
  final imageFile = File('${documentDirectory.path}/temp_image.jpg');
  imageFile.writeAsBytesSync(response.bodyBytes);
  log("image path : ${imageFile.path}");

  log(textShare);
  showMyCustomDialog(context,
      barrierDismissible: true,
      text: pathSegment == 'menu'
          ? menuName
          : pathSegment == 'merchant'
              ? merchantName
              : pathSegment == 'danus'
                  ? danusName
                  : 'Share!!',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "${AppConfig.URL_IMAGES_PATH}$imageUrl",
              fit: BoxFit.fitHeight,
              height: 180,
              // width: 180,
            ),
          )
        ],
      ),
      yesText: 'Copy Link',
      noText: 'Opsi Lain',
      colorYes: Warna.kuning, onTapYes: () {
    Clipboard.setData(ClipboardData(text: realUrl));
    navigateBack(context);
  }, onTapNo: () {
    // Share.share(text)
    SocialShare.shareOptions(
      textShare,
      imagePath: imageFile.path,
    );
    navigateBack(context);
  });
}

// String encryptUrl(String longUrl, String key) {
//   final keyBytes = encrypt.Key.fromUtf8(key);
//   final iv = encrypt.IV
//       .fromLength(8); // Menggunakan IV pendek untuk hasil yang lebih pendek
//   final encrypter = encrypt.Encrypter(
//       encrypt.Salsa20(keyBytes)); // Algoritma enkripsi ringan

//   final encrypted = encrypter.encrypt(longUrl, iv: iv);
//   return base64UrlEncode(encrypted.bytes)
//       .substring(0, 8); // Hasil lebih pendek
// }

// String decryptUrl(String shortUrl, String key) {
//   final keyBytes = encrypt.Key.fromUtf8(key);
//   final iv = encrypt.IV.fromLength(8);
//   final encrypter = encrypt.Encrypter(encrypt.Salsa20(keyBytes));

//   try {
//     final decoded = base64Url.decode(shortUrl + '=='); // Tambahkan padding untuk
//     // final decoded = base64Url.decode(shortUrl).
//     final decrypted =
//         encrypter.decryptBytes(encrypt.Encrypted(decoded), iv: iv);
//     return utf8.decode(decrypted);
//   } catch (e) {
//     print('Failed to decrypt URL: $e');
//     return 'Decryption failed';
//   }
// }

String encryptUrl(String url) {
  String _keyString =
      'campusfoodempireempirecampusfood'; // Example key (32 bytes)
  String _ivString = 'campusfoodempire'; // Example IV (16 bytes)

  final key = encrypt.Key.fromUtf8(_keyString);
  final iv = encrypt.IV.fromUtf8(_ivString);
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

  final encrypted = encrypter.encrypt(url, iv: iv);

  // Gabungkan IV dan data terenkripsi, dipisahkan oleh titik dua
  // return '${iv.base64}:${encrypted.base64}';
  return '${base62Encode(iv.bytes)}:${base62Encode(encrypted.bytes)}';
}

String decryptUrl(String encryptedUrl) {
  String _keyString =
      'campusfoodempireempirecampusfood'; // Example key (32 bytes)

  final key = encrypt.Key.fromUtf8(_keyString);

  // Pisahkan IV dan data terenkripsi berdasarkan pemisah titik dua
  final parts = encryptedUrl.split(':');
  if (parts.length != 2) {
    throw FormatException('Invalid encrypted URL format');
  }

  // final iv = encrypt.IV.fromBase64(parts[0]);
  // final encrypted = encrypt.Encrypted.fromBase64(parts[1]);
  final iv = encrypt.IV(Uint8List.fromList(base62Decode(parts[0])));
  final encrypted =
      encrypt.Encrypted(Uint8List.fromList(base62Decode(parts[1])));
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

  final decrypted = encrypter.decrypt(encrypted, iv: iv);
  return decrypted;
}

String base62Chars =
    '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

String base62Encode(List<int> bytes) {
  BigInt value = BigInt.parse(hex.encode(bytes), radix: 16);
  String result = '';

  while (value > BigInt.zero) {
    var remainder = value % BigInt.from(62);
    result = base62Chars[remainder.toInt()] + result;
    value = value ~/ BigInt.from(62);
  }

  return result.padLeft(8, '0'); // Pad untuk memastikan panjang yang konsisten
}

List<int> base62Decode(String base62) {
  BigInt value = BigInt.zero;
  for (int i = 0; i < base62.length; i++) {
    value =
        value * BigInt.from(62) + BigInt.from(base62Chars.indexOf(base62[i]));
  }

  String hexString = value.toRadixString(16);
  // Pastikan panjang hexString genap
  if (hexString.length % 2 != 0) hexString = '0' + hexString;
  return hex.decode(hexString);
}
