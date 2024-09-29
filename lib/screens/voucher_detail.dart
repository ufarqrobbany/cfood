import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/voucher_response.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VoucherDetail extends StatefulWidget {
  String? type;
  Voucher? dataVoucher;
  VoucherDetail({super.key, this.type, this.dataVoucher});

  @override
  State<VoucherDetail> createState() => _VoucherDetailState();
}

class _VoucherDetailState extends State<VoucherDetail> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> refreshPage() async {
    log('reload');
  }

  String formatDateTime(String dateTimeStr) {
    // Parse the string into a DateTime object
    DateTime parsedDateTime = DateTime.parse(dateTimeStr);

    // Format the DateTime object into the desired format: dd/MM/yyyy
    String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDateTime);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: backButtonCustom(context: context),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          'Voucher Promo',
          style: AppTextStyles.appBarTitle,
        ),
      ),
      backgroundColor: Colors.white,
      body: ReloadIndicatorType1(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              voucherCardBox(),
              detailInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget voucherCardBox() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        width: double.infinity,
        // height: 100,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Warna.biru,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Text(
                  'C-FOOD',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1
                      ..color = Warna.kuning,
                  ),
                ),
                const Text(
                  'C-FOOD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: Warna.kuning,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'VOUCHER ${widget.type!.toUpperCase() == "DISCOUNT" ? "DISKON" : "CASHBACK"}',
                style: TextStyle(
                    fontSize: 12,
                    color: Warna.biru,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget detailInfo() {
    String formatedDateTime =
        formatDateTime(widget.dataVoucher!.expiryDate.toString());
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.dataVoucher!.voucherName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Minimal Belanja: Rp${formatNumberWithThousandsSeparator(widget.dataVoucher!.voucherMinimumPurchasePrice).toString()}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Berlaku hingga: $formatedDateTime',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Kuantitas: ${widget.dataVoucher!.voucherQuantity}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Syarat dan Ketentuan:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            widget.dataVoucher!.voucherDescription.toString(),
            style: TextStyle(
              color: Warna.regulerFontColor,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
