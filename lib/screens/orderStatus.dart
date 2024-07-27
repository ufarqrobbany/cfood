import 'package:cfood/custom/CBottomSheet.dart';
import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';

class OrderStatusScreen extends StatefulWidget {
  final String orderId;
  final String orderStatus;

  const OrderStatusScreen(
      {super.key, this.orderId = '', this.orderStatus = 'Belum Bayar'});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {

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
  }

  Future<void> onEnterPage() async {
    if (widget.orderId != '') {
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
        title: const Text(
          'Status Pesanan',
          style: AppTextStyles.textRegular,
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
