import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 10));

    print('reload...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButtonCustom(context: context),
        leadingWidth: 90,
        title: Text(
          'Pilih Pembayaran',
          style: AppTextStyles.appBarTitle,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ReloadIndicatorType1(
          onRefresh: refreshPage,
          child: ListView.builder(
            itemCount: 1,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 15),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  navigateBack(context, result: 1);
                },
                child: Container(
                  // height: 65,
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 20,
                          spreadRadius: 0,
                          color: Warna.shadow.withOpacity(0.12),
                          offset: const Offset(0, 0)),
                    ],
                  ),
                
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.wallet,
                        color: Warna.biru,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      const Text(
                        'Cash',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
