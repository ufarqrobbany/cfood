import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/style.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({super.key});

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  TextEditingController reviewsTextController = TextEditingController();
  int selectedStarIndex = 4;
  String type = 'wirausaha';
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
          'Beri Penilaian',
          style: AppTextStyles.appBarTitle,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ReloadIndicatorType1(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                productBoxRate(),
                CTextField(
                  labelText: 'Ulasan',
                  controller: reviewsTextController,
                  minLines: 3,
                ),
                const SizedBox(
                  height: 10,
                ),
                userInfoBox(),
                boxOrderInfoDetail(),

                 Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: DynamicColorButton(
                  onPressed: () {
                  },
                  text: 'Beri Penilaian',
                  backgroundColor: Warna.kuning,
                  borderRadius: 54,
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userInfoBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        dense: false,
        shape: Border(
          bottom: BorderSide(color: Warna.abu, width: 1.5),
          top: BorderSide(color: Warna.abu, width: 1.5),
        ),
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Warna.abu,
          ),
          child: Image.network(
            '/.jpg',
            errorBuilder: (context, error, stackTrace) => Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Warna.abu,
              ),
            ),
          ),
        ),
        title: const Text(
          'Penjual [Username Penjual]',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'D4 Teknik Informatika',
          style: TextStyle(
            fontSize: 13,
            color: Warna.abu4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget productBoxRate() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Pesanan Sudah Sampai',
          style: AppTextStyles.subTitle,
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type == 'kantin' ? Icons.store : CommunityMaterialIcons.handshake,
              size: 20,
              color: type == 'kantin' ? Warna.biru : Warna.kuning,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Nama Toko',
              style: AppTextStyles.canteenName,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Warna.abu,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Nama Produk',
          style: AppTextStyles.textRegular,
        ),
        const Text(
          'Rp10.000',
          style: AppTextStyles.productPrice,
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 200,
          child: starIconBuilder(
            starColor: Warna.kuning,
            starCount: 5,
            starSize: 30,
          ),
        ),
      ],
    );
  }

  Widget starIconBuilder({
    final int starCount = 5,
    final double starSize = 24.0,
    final Color starColor = Colors.yellow,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        starCount,
        (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedStarIndex = index;
              });
              log(selectedStarIndex.toString());
            },
            child: Icon(
              Icons.star,
              size: starSize,
              color: index <= selectedStarIndex
                  ? Warna.kuning
                  : (index > selectedStarIndex
                      ? Colors.grey
                      : Colors.grey),
            ),
          );
        },
      ),
    );
  }

  Widget boxOrderInfoDetail() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Catatan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Warna.regulerFontColor,
                ),
              ),
              const Text(
                'Tidak ada',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'No. Pesanan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Warna.regulerFontColor,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '768768976897678709',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'SALIN',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Warna.kuning,
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Waktu Pemesanan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Warna.regulerFontColor,
                ),
              ),
              const Text(
                '31 Juli 2024, 15.08',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pembayaran',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Warna.regulerFontColor,
                ),
              ),
              const Text(
                'Gopay',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
