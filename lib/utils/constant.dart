// ignore_for_file: non_constant_identifier_names

import 'package:cfood/model/data_variants_local.dart';
import 'package:cfood/model/get_detail_merchant_response.dart'
    as detailmerchant;

class Constant {
  static const String baseUrl = "";

  static String appName = "C-Food";

  static String appVersion = "1.0.1";

  static String googleKey = "";

  static String mapKey = "";

  static String languageId = "Id";

  static String currencyCode = "Rp";

  static String androidAppId = "";
  static String iosAppId = "";
}

class AppConfig {
  static const String BASE_URL = "http://cfood.id/api/";

  static const String APPLINK_DOMAIN = "https://campusfood.id/";

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
