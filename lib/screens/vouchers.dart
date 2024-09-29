import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/voucher_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/app_setting_info.dart';
import 'package:cfood/screens/voucher_detail.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/common.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class VouchersScreen extends StatefulWidget {
  String? totalPurchasePrice;
  VouchersScreen({super.key, this.totalPurchasePrice});

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen> {
  IndicatorController _indicatorController = IndicatorController();
  ScrollController _scrollController = ScrollController();
  VoucherResponse? voucherResponse;
  VoucherData? voucherDataResponse;

  @override
  void initState() {
    super.initState();
    fetchVoucher();
  }

  Future<void> fetchVoucher() async {
    log('load voucher');
    voucherResponse = await FetchController(
      endpoint:
          'orders/vouchers?totalPurchasePrice=${widget.totalPurchasePrice}',
      fromJson: (json) => VoucherResponse.fromJson(json),
    ).getData();

    setState(() {
      voucherDataResponse = voucherResponse?.data;
    });
    log('response : $voucherResponse');
    log('data : $voucherDataResponse');
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
          'Gunakan Voucher',
          style: AppTextStyles.appBarTitle,
        ),
      ),
      backgroundColor: Colors.white,
      body: ReloadIndicatorType1(
        onRefresh: refreshPage,
        controller: _indicatorController,
        child: voucherItems(),
      ),
    );
  }

  Widget voucherItems() {
    if (voucherDataResponse == null) {
      return Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
              color: Warna.biru, size: 30));
    }

    // Combine all vouchers into sections for display
    final sections = [
      {'title': 'Diskon', 'vouchers': voucherDataResponse!.discount},
      {'title': 'Cashback', 'vouchers': voucherDataResponse!.cashback},
      {'title': 'Gratis Ongkir', 'vouchers': voucherDataResponse!.freeShipping},
    ];
    return ListView.builder(
      itemCount: sections.length,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      itemBuilder: (context, index) {
        final section = sections[index];
        final vouchers = section['vouchers'] as List<Voucher>;

        if (vouchers.isEmpty) {
          return SizedBox.shrink(); // Skip if no vouchers
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section['title'].toString(),
              style: AppTextStyles.subTitle,
            ),
            ListView.builder(
              shrinkWrap: true, // Allow nested ListView
              physics:
                  const NeverScrollableScrollPhysics(), // Prevent scrolling in nested ListView
              itemCount: vouchers.length,
              padding: const EdgeInsets.symmetric(vertical: 2),
              itemBuilder: (context, voucherIndex) {
                final voucher = vouchers[voucherIndex];
                String formatedDatTime =
                    formatDateTime(voucher.expiryDate.toString());
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 20,
                              spreadRadius: 0,
                              color: Warna.shadow.withOpacity(0.12),
                              offset: const Offset(0, 0))
                        ]),
                    child: ListTile(
                      leading: SizedBox(
                        width: 32,
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      title: Text(
                        voucher.voucherName,
                        style: AppTextStyles.subTitle,
                      ),
                      subtitle: RichText(
                          text: TextSpan(
                        text:
                            'Min. Belanja Rp${formatNumberWithThousandsSeparator(voucher.voucherMinimumPurchasePrice)}\nBerlaku s.d. $formatedDatTime\nSisa ${voucher.voucherQuantity} ',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Warna.abu6,
                            fontSize: 12),
                        children: [
                          TextSpan(
                            text: ' S&K',
                            style: TextStyle(
                              color: Warna.biru1,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // context.pushReplacementNamed('register');
                                navigateTo(
                                    context,
                                    VoucherDetail(
                                      type: section['title'].toString(),
                                      dataVoucher: voucher,
                                    ));
                                // edit disini
                              },
                          ),
                        ],
                      )),
                      trailing: SizedBox(
                        width: 77,
                        height: 35,
                        child: CBlueButton(
                          backgroundColor: (voucher.voucherQuantity > 0)
                              ? Warna.biru
                              : Colors.grey.shade200,
                          onPressed: () {
                            log('gunakan: $voucher');
                            if (voucher.voucherQuantity > 0) {
                              navigateBack(context, result: voucher);
                            }
                          },
                          text: 'Gunakan',
                          borderRadius: 6,
                          fontSize: 13,
                          padding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
