import 'package:cfood/style.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(
      msg, 
      duration: duration ?? Toast.lengthLong, 
      gravity: gravity,
      backgroundColor: Colors.white,
      backgroundRadius: 15, 
      textStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: Color(0xFF4A4A4A),
        
      ),
      border: Border.all(color: Warna.kuning, width: 1.5)
      );
  }

  void showLoadState({int? duration, int? gravity}) {
    Toast.show(
      '● ● ●',
      duration: duration ?? Toast.lengthLong, 
      gravity: gravity,
      backgroundColor: Colors.white,
      backgroundRadius: 15, 
      textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Warna.biru,
        
      ),
      border: Border.all(color: Warna.kuning, width: 1.5)
    );
  }