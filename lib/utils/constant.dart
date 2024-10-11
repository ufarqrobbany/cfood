// ignore_for_file: non_constant_identifier_names

import 'package:cfood/model/get_detail_merchant_response.dart'
    as detailmerchant;
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class Constant {
  static const String baseUrl = "";

  static String appName = "C-Food";

  static String appVersion = "1.0.3";

  static String googleKey = "";

  static String mapKey = "";

  static String languageId = "Id";

  static String currencyCode = "Rp";

  static String androidAppId = "";
  static String iosAppId = "";
}

class AppConfig {
  static const String BASE_URL = "https://cfood.id/api/";

  static const String APPLINK_DOMAIN = "https://campusfood.id/to/";

  static int USER_ID = 0;

  static int STUDENT_ID = 0;

  static int USER_CAMPUS_ID = 0;

  static String NAME = '';

  static String EMAIL = '';

  static String USER_TYPE = 'reguler';

  static bool IS_DRIVER = false;

  static String URL_IMAGES_PATH = "${BASE_URL}images/";

  static String URL_PHOTO_PROFILE = '';

  // MERCHANT || CANTEEN SECTION

  static int MERCHANT_ID = 0;

  static String MERCHANT_NAME = '';

  static String MERCHANT_PHOTO = "${BASE_URL}images/";

  static String MERCHANT_DESC = '';

  static String MERCHANT_TYPE = "WIRAUSAHA";

  static bool MERCHANT_OPEN = false;

  static bool ON_DASHBOARD = false;

  static bool FROM_LINK = false;
}

class MenuConfig {
  // static List<VariantDatas> variants = [];
  static List<detailmerchant.Variant> variants = [];
}

class NotificationConfig {
  static int userNotification = 0;

  static int userChatNotification = 0;

  static int sellerNotification = 0;

  static int sellerChatNotification = 0;

  static int driverNotification = 0;

  static int driverChatNotification = 0;
}
// =======
// // ignore_for_file: non_constant_identifier_names

// import 'package:cfood/model/data_variants_local.dart';
// import 'package:cfood/model/get_detail_merchant_response.dart'
//     as detailmerchant;

// class Constant {
//   static const String baseUrl = "";

//   static String appName = "C-Food";

//   static String appVersion = "1.0.1";

//   static String googleKey = "";

//   static String mapKey = "";

//   static String languageId = "Id";

//   static String currencyCode = "Rp";

//   static String androidAppId = "";
//   static String iosAppId = "";
// }

// class AppConfig {
//   static const String BASE_URL = "https://cfood.id/api/";

//   static const String APPLINK_DOMAIN = "https://campusfood.id/";

//   static int USER_ID = 0;

//   static int STUDENT_ID = 0;

//   static int USER_CAMPUS_ID = 0;

//   static String NAME = '';

//   static String EMAIL = '';

//   static String USER_TYPE = 'reguler';

//   static bool IS_DRIVER = false;

//   static String URL_IMAGES_PATH = "${BASE_URL}images/";

//   static String URL_PHOTO_PROFILE = '';

//   // MERCHANT || CANTEEN SECTION

//   static int MERCHANT_ID = 0;

//   static String MERCHANT_NAME = '';

//   static String MERCHANT_PHOTO = "${BASE_URL}images/";

//   static String MERCHANT_DESC = '';

//   static String MERCHANT_TYPE = "WIRAUSAHA";

//   static bool MERCHANT_OPEN = false;

//   static bool ON_DASHBOARD = false;

//   static bool FROM_LINK = false;
// }

// class MenuConfig {
//   // static List<VariantDatas> variants = [];
//   static List<detailmerchant.Variant> variants = [];
// }
// >>>>>>> 3f9f3e01d190d91a8882ff0e46bacfd79ab2f602



  List<Map<String, dynamic>> orderStatusMap = [
    {
      'status': 'Belum Bayar',
      'code': 'BELUM_DIBAYAR',
      'icon': UIcons.regularRounded.money,
      'color': Warna.abu4,
      'highlight': true,
    },
    {
      'status': 'Menunggu Konfirmasi Penjual',
      'code': 'MENUNGGU_KONFIRM_PENJUAL',
      'icon': UIcons.solidRounded.time_quarter_past,
      'color': Warna.abu4,
      'highlight': true,
    },
    {
      'status': 'Pesanan Diproses',
      'code': 'DIPROSES_PENJUAL',
      'icon': UIcons.regularRounded.time_quarter_to,
      'color': Warna.kuning,
      'highlight': true,
    },
    {
      'status': 'Menunggu Konfirmasi Kurir',
      'code': 'MENUNGGU_KONFIRM_KURIR',
      'icon': UIcons.solidRounded.hat_chef,
      'color': Warna.abu,
      'highlight': true,
    },
    {
      'status': 'Pesanan Sedang Diantar',
      'code': 'DIPROSES_KURIR',
      'icon': Icons.directions_bike_rounded,
      'color': Warna.oranye2,
      'highlight': true,
    },
    {
      'status': 'Pesanan Sampai',
      'code': 'PESANAN_SAMPAI',
      'icon': UIcons.regularRounded.soup,
      'color': Warna.hijau,
      'highlight': false,
    },
    {
      'status': 'Belum Rating',
      'code': 'KONFIRM_SAMPAI',
      'icon': UIcons.regularRounded.star,
      'color': Warna.hijau,
      'highlight': false,
    },
    {
      'status': 'Pesanan Dibatalkan',
      'code': 'DIBATALKAN',
      'icon': UIcons.regularRounded.cross_circle,
      'color': Warna.like,
      'highlight': false,
    },
    {
      'status': 'Ditolak',
      'code': 'DITOLAK',
      'icon': UIcons.regularRounded.cross_circle,
      'color': Warna.like,
      'highlight': false,
    },
    {
      'status': 'Pesanan Selesai',
      'code': 'SUDAH_RATING',
      'icon': Icons.check_circle_outline_rounded,
      'color': Warna.hijau,
      'highlight': false,
    },
  ];
