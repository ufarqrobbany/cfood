import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget customShimmer({
  Widget? child,
  required bool? enabled,
}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    enabled: enabled!,
    direction: ShimmerDirection.ltr,
    period: const Duration(milliseconds: 1000),
    child: child!,
  );
}

Widget shimmerBox({
  required bool? enabled,
  double? width,
  double? height,
  double? radius,
}) {
  return customShimmer(
      enabled: enabled,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 5),
          color: Warna.abu,
        ),
      ));
}

Widget shimmerProductCard({required bool? enabled}) {
  return Container(
    constraints: const BoxConstraints(
      minWidth: 160,
      maxWidth: 170,
    ),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          blurRadius: 20,
          spreadRadius: 0,
          color: Warna.shadow.withOpacity(0.12),
          offset: const Offset(0, 0),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        shimmerBox(enabled: enabled, height: 120, width: 120, radius: 8,),
        const SizedBox(height: 10),
        shimmerBox(enabled: enabled, height: 15, width: 100),
        const SizedBox(height: 10),
        shimmerBox(enabled: enabled, height: 15, width: 60),
      ],
    ),
  );
}

Widget shimmerStoreCard({required bool? enabled}) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          blurRadius: 20,
          spreadRadius: 0,
          color: Warna.shadow.withOpacity(0.12),
          offset: const Offset(0, 0),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shimmerBox(enabled: enabled, height: 120, width: 120, radius: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            shimmerBox(enabled: enabled, height: 15, width: 100, radius: 8),
            const SizedBox(height: 10),
            shimmerBox(enabled: enabled, height: 15, width: 60, radius: 8),
          ],
        ),
      ],
    ),
  );
}

Widget shimmerListBuilder(BuildContext context, item, {required bool? enabled, int? itemCount, bool? isVertical}) {
  return ListView.builder(
    itemCount: itemCount ?? 3,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    scrollDirection: isVertical! ? Axis.vertical : Axis.horizontal,
    itemBuilder: (context, index) {
    return isVertical ? shimmerStoreCard(enabled: enabled) : shimmerProductCard(enabled: enabled);
  },);
}