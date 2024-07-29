import 'package:cfood/custom/CBottomSheet.dart';
import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';

class DriverOrderStatusScreen extends StatefulWidget {
  final int orderId;
  final String orderStatus;

  const DriverOrderStatusScreen(
      {super.key, this.orderId = 0, this.orderStatus = 'Belum Bayar'});

  @override
  State<DriverOrderStatusScreen> createState() =>
      _DriverOrderStatusScreenState();
}

class _DriverOrderStatusScreenState extends State<DriverOrderStatusScreen> {
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
    onEnterPage();
  }

  Future<void> onEnterPage() async {
    if (widget.orderId != 0) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          statusOrderSheet(
            context,
            status: widget.orderStatus,
            orderId: widget.orderId,
            driverInfo: driverInfo,
            orderInfo: orderInfo,
            isCashless: orderInfo['method'] == 'cash' ? false : true,
            onPressedSeeDetail: () {},
            onPressedStatusButton: () {},
          );
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
      body: const SizedBox(
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
