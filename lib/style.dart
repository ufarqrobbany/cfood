import 'package:flutter/material.dart';

class Warna {
  static Color kuning = const Color(0xffFFC01E);
  static Color oranye1 = const Color(0xffFD7702);
  static Color oranye2 = const Color(0xffFF5003);
  static Color biru1 = const Color(0xff0C356D);
  static Color biru2 = const Color(0xff062D61);
  static Color biru = const Color(0xff002347);
  static Color abu = const Color(0xffF2F2F2);
  static Color abu2 = const Color(0xffCFCFCF);
  static Color abu3 = const Color(0xFFD9D9D9);
  static Color abu4 = const Color(0xff929292);
  static Color abu5 = const Color(0xffF5F5F5);
  static Color abu6 = const Color(0xff949494);
  static Color shadow = const Color(0xff002347);
  static Color like = const Color(0xffF44336);
  static Color pageBackgroundColor = const Color(0xffF9F9F9);
  static Color regulerFontColor = const Color(0xff353535);
  static Color hijau = const Color(0xff469E2B);
}

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: Color(0xFF353535),
  );

  static const TextStyle subTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: Color(0xFF353535),
  );

  static const TextStyle titleBackgroundDark = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );

  static const TextStyle textRegular = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Color(0xFF4A4A4A),
  );

  static const TextStyle textRegularBackgroundDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Color(0xFFF0F0F0),
  );

  static const TextStyle labelInput = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF4A4A4A),
  );

  static const TextStyle placeholderInput = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xFFB6B6B6),
  );

  static const TextStyle textInput = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: Color(0xFF4A4A4A),
  );

  static const TextStyle textRadioButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xFF4A4A4A),
  );

  static const TextStyle link = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFF0C356D),
  );

  static const TextStyle textButtonBackgroundDark = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle textRadioButton15 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: Color(0xFF4A4A4A),
  );

  static const TextStyle productName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF353535),
  );

  static const TextStyle productStoreName = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color(0xFF4A4A4A),
  );

  static const TextStyle productPrice = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Color(0xFF0C356D),
  );

  static const TextStyle canteenName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF353535),
  );

  static TextStyle appBarTitle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w600,
    color: Warna.regulerFontColor,
  );
}
