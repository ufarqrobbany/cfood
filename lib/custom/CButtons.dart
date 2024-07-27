import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CBlueButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final double borderRadius;
  final Color? backgroundColor;
  final Color textColor;
  final EdgeInsets padding;
  final double fontSize;
  final FontWeight fontWeight;
  final double elevation;
  final Widget? icon;
  final bool isLoading;

  const CBlueButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.borderRadius = 8,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.bold,
    this.elevation = 0,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<CBlueButton> createState() => _CBlueButtonState();
}

class _CBlueButtonState extends State<CBlueButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isLoading == true ? () {} : widget.onPressed,
      style: ElevatedButton.styleFrom(
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: widget.isLoading == true
            ? Colors.grey.shade200
            : widget.backgroundColor ?? Warna.biru,
        padding: widget.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        elevation: widget.elevation,
      ),
      child: widget.icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.icon!,
                const SizedBox(width: 8.0),
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: widget.fontSize,
                    fontWeight: widget.fontWeight,
                  ),
                ),
              ],
            )
          : widget.isLoading == true
              ?
              // LoadingAnimationWidget.waveDots(color: Warna.biru, size: 30)
              LoadingAnimationWidget.staggeredDotsWave(
                  color: Warna.biru, size: 30)
              : Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: widget.fontSize,
                    fontWeight: widget.fontWeight,
                  ),
                ),
    );
  }
}

class DynamicColorButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final double borderRadius;
  final Color? backgroundColor;
  final Color textColor;
  final EdgeInsets padding;
  final double fontSize;
  final FontWeight fontWeight;
  final double elevation;
  final Widget? icon;
  final bool isLoading;

  const DynamicColorButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.borderRadius = 8,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.bold,
    this.elevation = 0,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<DynamicColorButton> createState() => _DynamicColorButtonState();
}

class _DynamicColorButtonState extends State<DynamicColorButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.isLoading == true ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: widget.isLoading == true
            ? Colors.grey.shade200
            : widget.backgroundColor ?? Warna.biru,
        padding: widget.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        elevation: widget.elevation,
      ),
      child: widget.icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.icon!,
                const SizedBox(width: 8.0),
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: widget.fontSize,
                    fontWeight: widget.fontWeight,
                  ),
                ),
              ],
            )
          : widget.isLoading == true
              ?
              // LoadingAnimationWidget.waveDots(color: Warna.biru, size: 30)
              LoadingAnimationWidget.staggeredDotsWave(
                  color: Warna.biru, size: 30)
              : Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: widget.fontSize,
                    fontWeight: widget.fontWeight,
                  ),
                ),
    );
  }
}

class CYellowMoreButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final double? height;
  final TextStyle? textStyle;
  const CYellowMoreButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.height,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 25,
      child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              backgroundColor: Warna.kuning.withOpacity(0.10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: textStyle ??
                TextStyle(
                  color: Warna.kuning,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
          )),
    );
  }
}

Widget backButtonCustom(
    {required BuildContext? context, VoidCallback? customTap}) {
  // leadingWidth: 90,
  return IconButton(
    onPressed: customTap ?? () => navigateBack(context),
    icon: Icon(
      Icons.arrow_back,
      color: Warna.biru,
    ),
    padding: const EdgeInsets.all(5),
    iconSize: 18,
    style: IconButton.styleFrom(
        backgroundColor: Warna.abu, shape: const CircleBorder()),
  );
}

class CTabButtons extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final EdgeInsets padding;
  final double fontSize;
  final String? typeTab;
  final String? selectedTab;
  const CTabButtons({
    super.key,
    required this.onPressed,
    required this.text,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    this.fontSize = 16.0,
    this.typeTab,
    this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    bool active = typeTab == selectedTab;
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            elevation: 0,
            maximumSize: const Size.fromHeight(43),
            minimumSize: const Size.fromHeight(43),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            backgroundColor: active ? Warna.kuning : Warna.abu,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            )),
        child: Text(
          text,
          maxLines: 1,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: Warna.regulerFontColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ));
  }
}

Widget notifIconButton(
    {VoidCallback? onPressed, IconData? icons, String? notifCount, Color? iconColor}) {
  return Stack(
    children: [
      IconButton(
        onPressed: onPressed,
        padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
        icon: Icon(
          icons,
          size: 22,
          color: iconColor ?? Colors.white,
        ),
      ),
      Positioned(
          right: 11,
          top: 11,
          child: Container(
            width: 15,
            height: 15,
            // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
              color: Warna.kuning,
              borderRadius: BorderRadius.circular(33),
            ),
            child: Center(
              child: Text(
                notifCount!,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ))
    ],
  );
}

class DynamicButtonStatusOrder extends StatelessWidget {
  final String status;
  final List<Map<String, dynamic>> statusMap;
  final VoidCallback? onPressed;

  const DynamicButtonStatusOrder({super.key, 
    required this.status,
    required this.statusMap,
    this.onPressed, required String text,
  });

  Future<Map<String, dynamic>> buttonChangeState({
    String? status,
    String? statusCode,
    List<Map<String, dynamic>>? statusMap,
  }) async {
    if (status == null && statusCode == null) {
      throw ArgumentError("Either status or statusCode must be provided.");
    }

    Map<String, dynamic>? result;

    if (status != null) {
      result = statusMap?.firstWhere((element) => element['status'] == status,
          orElse: () => {});
    } else if (statusCode != null) {
      result = statusMap?.firstWhere((element) => element['code'] == statusCode,
          orElse: () => {});
    }

    if (result == null || result.isEmpty) {
      throw Exception("Status or code not found in the status map.");
    }

    return {
      'text': result['status'],
      'icon': result['icon'],
      'color': result['color'],
      'highlight': result['highlight'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: buttonChangeState(status: status, statusMap: statusMap),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 36,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(34),
                ),
              ),
              child: const CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 36,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(34),
                ),
              ),
              child: const Text(
                "Error",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final statusData = snapshot.data!;
          return SizedBox(
            height: 36,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: statusData['color'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(34),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    statusData['icon'],
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    statusData['text'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

