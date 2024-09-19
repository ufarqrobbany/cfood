import 'dart:async';
import 'dart:developer';

import 'package:cfood/custom/CBottomSheet.dart';
import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DriverOrderStatusScreen extends StatefulWidget {
  final int orderId;
  final String orderStatus;

  const DriverOrderStatusScreen(
      {super.key, this.orderId = 0, this.orderStatus = ''});

  @override
  State<DriverOrderStatusScreen> createState() =>
      _DriverOrderStatusScreenState();
}

class _DriverOrderStatusScreenState extends State<DriverOrderStatusScreen> {
  WebViewController webController = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onHttpError: (HttpResponseError error) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse('https://maps.app.goo.gl/JNtBjD4qUq5VbRSM6'));

  
  Map<String, dynamic> driverInfo = {
    'id': '0000',
    'profile': '/.jpg',
    'name': 'Kusen DanaAtamaya',
    'rate': '5.0',
    'notification': 7,
  };

  Map<String, dynamic> orderInfo = {
    'id': '0999',
    'store_name': 'C-Food Kedai',
    'price': 20000,
    'method': 'cash',
    'menu_count': 3,
    'items_count': 6,
    'location': 'Gedung SerbaGKguna Lt.3'
  };

  @override
  void initState() {
    super.initState();
    log('open bottom sheet');
    log({
      'orderId': widget.orderId,
      'orderStatus': widget.orderStatus,
    }.toString());
    onEnterPage();
  }

  Future<void> onEnterPage() async {
    if (widget.orderId != 0) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          showStatusInfo();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButtonCustom(context: context),
        leadingWidth: 90,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          'Status Pesanan',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Warna.regulerFontColor,
          ),
        ),
      ),
      backgroundColor: Warna.pageBackgroundColor,
      body: webMapScreen(),
      // body: const SizedBox(
      //   height: double.infinity,
      //   width: double.infinity,
      // ),
      floatingActionButton: IconButton(
        onPressed: () {
          showStatusInfo();
        },
        icon: Icon(
          UIcons.solidRounded.info,
          color: Warna.biru,
        ),
        iconSize: 50,
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget webMapScreen() {
    return WebViewWidget(controller: webController);
  }

  Future showStatusInfo() {
    return statusDeliverySheet(
      context,
      status: widget.orderStatus,
      // status: 'Diproses',
      orderId: widget.orderId,
      driverInfo: driverInfo,
      orderInfo: orderInfo,
      orderStatusIndex: 2,
      orderStatusProses: orderStatusProses,
      onPressedSeeDetail: () {},
      onPressedStatusButton: () {},
    );
  }

  final List<Map<String, dynamic>> orderStatusProses = [
    {
      'status': 'Dikonfirmasi',
      'time': '00.00',
      'done': true,
      'onProgress': false,
    },
    {
      'status': 'Diproses',
      'time': '00.00',
      'done': true,
      'onProgress': false,
    },
    {
      'status': 'Diantar',
      'time': '00.00',
      'done': false,
      'onProgress': true,
    },
    {
      'status': 'Selesai',
      'time': '00.00',
      'done': false,
      'onProgress': false,
    },
  ];
}
