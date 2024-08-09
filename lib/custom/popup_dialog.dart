import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';

Future<void> showMyCustomDialog(
  BuildContext context, {
  final String? text,
  final VoidCallback? onTapYes,
  final VoidCallback? onTapNo,
  final String? yesText,
  final String? noText,
  final Color? colorYes,
  final Color? colorNO,
  final bool justYEs = false,
  final Widget? content,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // actionsPadding: const EdgeInsets.all(10),
        actionsPadding: EdgeInsets.zero,
        title: Text(
          text!,
          style: AppTextStyles.textRegular,
          textAlign: TextAlign.center,
        ),
        content: content,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actionsOverflowAlignment: OverflowBarAlignment.end,
        actionsOverflowDirection: VerticalDirection.down,
        actions: [
          ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8),),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                justYEs == true ? Container() :
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: DynamicColorButton(
                      onPressed: onTapNo ??
                          () {
                            navigateBack(context);
                          },
                      text: noText ?? 'Tidak',
                      textColor: Warna.regulerFontColor,
                      backgroundColor: colorNO ?? Warna.abu,
                      borderRadius: 0,
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: DynamicColorButton(
                      onPressed: onTapYes ??
                          () {
                            navigateBack(context);
                          },
                      text: yesText ?? 'Ya',
                      backgroundColor: colorYes ?? Warna.kuning,
                      borderRadius: 0,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
        // actions: <Widget>[
        //   SizedBox(
        //     height: 50,
        //     width: 120,
        //     child: DynamicColorButton(
        //       onPressed: onTapNo ?? () {
        //         navigateBack(context);
        //       },
        //       text: noText ?? 'Tidak',
        //       textColor: Warna.regulerFontColor,
        //       backgroundColor: colorNO ?? Warna.abu,
        //       borderRadius: 8,
        //     ),
        //   ),
        //   SizedBox(
        //     height: 50,
        //     width: 120,
        //     child: DynamicColorButton(
        //       onPressed: onTapYes ?? () {
        //         navigateBack(context);
        //       },
        //       text: yesText ?? 'Ya',
        //       backgroundColor: colorYes ?? Warna.kuning,
        //       borderRadius: 8,
        //     ),
        //   ),
        // ],
      );
    },
  );
}
