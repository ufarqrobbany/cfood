import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:uicons/uicons.dart';

Widget itemsEmptyBody(BuildContext context,
    {IconData? icons, Color? iconsColor, String? text, Color? bgcolors}) {
  return Container(
    // width: MediaQuery.of(context).size.width,
    // height: MediaQuery.of(context).size.height,
    width: double.infinity,
    // height: double.infinity,
    color: bgcolors ?? Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 60,
        ),
        Icon(
          icons ?? UIcons.solidRounded.bug,
          size: 40,
          color: iconsColor ?? Warna.biru,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          text ?? 'Item yang kamu cari kosong',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.normal, color: Warna.abu6),
        ),
      ],
    ),
  );
}


Widget pageOnLoading(BuildContext context) {
  return Container(
    height: double.infinity,
    width: double.infinity,
    color: Colors.white,
    child: Center(
      child: SizedBox(
        height: 50,
        child:  LoadingAnimationWidget.staggeredDotsWave(
                  color: Warna.biru, size: 30),
      ),
    ),
  );
}
