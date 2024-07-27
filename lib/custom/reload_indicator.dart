import 'package:cfood/style.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class ReloadIndicatorType1 extends StatelessWidget {
  Widget? child;
  AsyncCallback? onRefresh;
  IndicatorController? controller;
  ReloadIndicatorType1({super.key, this.child, this.onRefresh, this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomMaterialIndicator(
      onRefresh: onRefresh!, 
      indicatorBuilder: (context, controller) {
        return LoadingAnimationWidget.beat(color: Warna.kuning, size: 30, );
      },backgroundColor: Warna.biru,
      durations: const RefreshIndicatorDurations(
        finalizeDuration: Duration(milliseconds: 300), 
        cancelDuration: Duration(milliseconds: 300), 
        settleDuration: Duration(milliseconds: 300),
        ),
      controller: controller,
      child: child!,
      );
  }
}