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
    margin: const EdgeInsets.symmetric(horizontal: 10),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shimmerBox(
          enabled: enabled,
          height: 120,
          width: double.infinity,
          radius: 8,
        ),
        const SizedBox(height: 10),
        shimmerBox(enabled: enabled, height: 15, width: 100),
        const SizedBox(height: 10),
        shimmerBox(enabled: enabled, height: 15, width: 60),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            shimmerBox(enabled: enabled, height: 15, width: 40),
            const SizedBox(
              width: 8,
            ),
            shimmerBox(enabled: enabled, height: 15, width: 40),
          ],
        )
      ],
    ),
  );
}

Widget shimmerBoxCard({required bool? enabled}) {
  return Container(
    constraints: const BoxConstraints(
      minWidth: 160,
      maxWidth: 170,
    ),
    margin: const EdgeInsets.symmetric(horizontal: 10),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        shimmerBox(
          enabled: enabled,
          height: 80,
          width: 80,
          radius: 120,
        ),
        const SizedBox(height: 10),
        shimmerBox(enabled: enabled, height: 18, width: 80),
      ],
    ),
  );
}

Widget shimmerStoreCard({required bool? enabled}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            shimmerBox(enabled: enabled, height: 18, width: 100, radius: 8),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                shimmerBox(enabled: enabled, height: 18, width: 40, radius: 8),
                const SizedBox(
                  width: 10,
                ),
                shimmerBox(enabled: enabled, height: 18, width: 40, radius: 8),
              ],
            ),
            const SizedBox(height: 10),
            // const Spacer(),
          ],
        ),
      ],
    ),
  );
}

Widget shimmerListBuilder(BuildContext context,
    {required bool? enabled,
    int? itemCount,
    bool isBox = false,
    bool? isVertical,
    EdgeInsets? padding}) {
  return ListView.builder(
    itemCount: itemCount ?? 3,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    scrollDirection: isVertical! ? Axis.vertical : Axis.horizontal,
    padding:
        padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    itemBuilder: (context, index) {
      return isBox
          ? shimmerBoxCard(enabled: enabled)
          : isVertical
              ? shimmerStoreCard(enabled: enabled)
              : shimmerProductCard(enabled: enabled);
    },
  );
}
