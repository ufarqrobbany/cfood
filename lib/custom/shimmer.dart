import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget customShimmer(
  {
    Widget? child,
    required bool ? enabled,
  }
  ) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    enabled: enabled!,
    direction: ShimmerDirection.ltr,
    period: const Duration(milliseconds: 1000),
    child: child!,
  );
}

Widget shimmerBox(
  {
    required bool? enabled,
    double? width,
    double? height,
    double? radius,
  }
) {
  return customShimmer(
    enabled: enabled,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 5),
        color: Warna.abu,
      ),
    )
  );
}