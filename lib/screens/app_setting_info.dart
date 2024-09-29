import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppSettingsInformation extends StatefulWidget {
  final String? type;
  final String? title;
  const AppSettingsInformation({super.key, this.type, this.title});

  @override
  State<AppSettingsInformation> createState() => _AppSettingsInformationState();
}

class _AppSettingsInformationState extends State<AppSettingsInformation> {
  Uri webPath = Uri.parse('https://campusfood.id');
  WebViewController webController = WebViewController();

  @override
  void initState() {
    super.initState();
   
    onEnterPage();
  }

  Future<void> onEnterPage() async {
    if (widget.type == 'Kebijakan Privasi') {
      log(widget.type.toString());
      setState(() {
        webPath = Uri.parse('https://campusfood.id/privacy-policy#app');
      });
    } else if (widget.type == 'Ketentuan Layanan') {
      log(widget.type.toString());
      setState(() {
        webPath = Uri.parse('https://campusfood.id/terms#app');
      });
    } else if (widget.type == 'Atribusi Data') {
      log(widget.type.toString());
      setState(() {
        webPath = Uri.parse('https://campusfood.id/attribution#app');
      });
    } else if(widget.type == 'Bantuan') {
      log(widget.type.toString());
      setState(() {
        webPath = Uri.parse('https://campusfood.id/help-center#app');
      });
    } 

     webController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
          LoadingAnimationWidget.staggeredDotsWave(
                  color: Warna.biru, size: 30);
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onHttpError: (HttpResponseError error) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://campusfood.id')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );

    webController.loadRequest(webPath);
  }

  void reloadPage() {
    log('reload');
    webController.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButtonCustom(context: context),
        leadingWidth: 90,
        title: Text(
          widget.title.toString(),
          style: AppTextStyles.title,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        actions: [
        IconButton(
          icon: Icon(Icons.refresh ,color: Warna.biru,),
          onPressed: () {
            reloadPage(); // Memanggil fungsi reload
          },
        ),
        const SizedBox(width: 20,),
      ],
      ),
      backgroundColor: Warna.pageBackgroundColor,
      body: webScreen(),
    );
  }

  Widget webScreen() {
    return WebViewWidget(controller: webController,);
  }
}
