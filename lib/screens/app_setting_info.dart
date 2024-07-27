import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';

class AppSettingsInformation extends StatefulWidget {
  final String? type;
  final String? title;
  const AppSettingsInformation({super.key, this.type, this.title});

  @override
  State<AppSettingsInformation> createState() => _AppSettingsInformationState();
}

class _AppSettingsInformationState extends State<AppSettingsInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButtonCustom(context: context),
        leadingWidth: 90,
        title: Text(widget.title.toString(), style: AppTextStyles.title,),
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Warna.pageBackgroundColor,
    );
  }
}