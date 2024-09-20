import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  final int? menuId;
  final int? merchantId;
  final String? storeId;
  final String? imgUrl;
  final String? storeName;
  final String? rate;
  final String? likes;
  final String type;
  const ReviewScreen({
    super.key,
    this.menuId,
    this.merchantId,
    this.storeId,
    this.imgUrl,
    this.storeName,
    this.rate,
    this.likes,
    this.type = 'Kantin', // Wirausaha | Menu
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String selectedTab = 'Semua';
  Map<String, Map<String, Map<String, dynamic>>> reviewsMaps = {
    'Semua': {
      'ulasan 1': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '5',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 2': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '5',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 3': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '4',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 4': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '3',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 5': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '4',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 6': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '4',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
    },
    '5': {
      'ulasan 1': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '5',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 2': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '5',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 3': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '5',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 4': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '5',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
    },
    '4': {
      'ulasan 1': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '4',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 2': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '4',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 3': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '4',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 4': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '4',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
    },
    '3': {
      'ulasan 1': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '3',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 2': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '3',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 3': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '3',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 4': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '3',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
    },
    '2': {
      'ulasan 1': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '2',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 2': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '2',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 3': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '2',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 4': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '2',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
    },
    '1': {
      'ulasan 1': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '1',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 2': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '1',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 3': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '1',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
      'ulasan 4': {
        'id': '1',
        'nama': 'nama pengguna',
        'rate': '1',
        'ulasan': '100',
        'dateTime': '17 Juli 2024',
        'image': '',
        'respon': '',
      },
    },
  };

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 10));

    print('reload...');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: backButtonCustom(context: context),
        title: Text(
          'Ulasan ${widget.type}',
          style: AppTextStyles.title,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Warna.pageBackgroundColor,
      body: ReloadIndicatorType1(
        onRefresh: refreshPage,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  menuCardInfo(),
                  bodyReviewsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuCardInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          bottom: BorderSide(
            color: Warna.shadow.withOpacity(0.10),
          ),
        ),
        // borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              blurRadius: 20,
              spreadRadius: 0,
              color: Warna.shadow.withOpacity(0.12),
              offset: const Offset(0, 0))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            // width: double.infinity,
            height: 120,
            constraints: const BoxConstraints(
              minWidth: 120,
              maxWidth: double.infinity,
            ),
            decoration: BoxDecoration(
              color: Warna.abu, borderRadius: BorderRadius.circular(8),
              // borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Image.network(
              widget.imgUrl.toString(),
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  constraints: const BoxConstraints(
                    minWidth: 120,
                    maxWidth: double.infinity,
                  ),
                  decoration: BoxDecoration(
                      color: Warna.abu, borderRadius: BorderRadius.circular(8)
                      // borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                      ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.store,
                        size: 25,
                        color: Warna.biru,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.storeName!,
                        style: AppTextStyles.productName,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  // Info Name, rate, likes
                  widget.type == 'Kantin'
                      ?
                      // State for Kantin
                      Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Warna.kuning, width: 1),
                                    color: Warna.kuning.withOpacity(0.10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Warna.kuning,
                                      ),
                                      Text(
                                        widget.rate!,
                                        style: TextStyle(
                                            color: Warna.kuning, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '100 Penilian',
                                  style: TextStyle(
                                    color: Warna.regulerFontColor,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Warna.hijau.withOpacity(0.60),
                                        width: 1),
                                    color: Warna.hijau.withOpacity(0.10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.location_pin,
                                        size: 15,
                                        color: Warna.hijau,
                                      ),
                                      const Text(
                                        'Lokasi',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Warna.like, width: 1),
                                      color: Warna.like.withOpacity(0.10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: 10,
                                        color: Warna.like,
                                      ),
                                      Text(
                                        widget.likes!,
                                        style: TextStyle(
                                            color: Warna.like, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      :
                      // State for Wirausaha
                      widget.type == 'Wirausaha'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color: Warna.like, width: 1),
                                          color: Warna.like.withOpacity(0.10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            size: 10,
                                            color: Warna.like,
                                          ),
                                          Text(
                                            widget.likes!,
                                            style: TextStyle(
                                                color: Warna.like,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: Warna.kuning, width: 1),
                                        color: Warna.kuning.withOpacity(0.10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 10,
                                            color: Warna.kuning,
                                          ),
                                          Text(
                                            widget.rate!,
                                            style: TextStyle(
                                                color: Warna.kuning,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '100 Penilian',
                                      style: TextStyle(
                                        color: Warna.regulerFontColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Nama Mahasiswa - Prodi & Jurusan',
                                  style: TextStyle(
                                    color: Warna.regulerFontColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          :
                          // State for Menu info
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: Warna.kuning, width: 1),
                                        color: Warna.kuning.withOpacity(0.10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 10,
                                            color: Warna.kuning,
                                          ),
                                          Text(
                                            widget.rate!,
                                            style: TextStyle(
                                                color: Warna.kuning,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '100 Penilian',
                                      style: TextStyle(
                                        color: Warna.regulerFontColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color: Warna.like, width: 1),
                                          color: Warna.like.withOpacity(0.10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.favorite,
                                            size: 10,
                                            color: Warna.like,
                                          ),
                                          Text(
                                            widget.likes!,
                                            style: TextStyle(
                                                color: Warna.like,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '100 Terjual',
                                      style: TextStyle(
                                        color: Warna.regulerFontColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                widget.type == 'Menu'
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '[Deskripsi menu satu baris]',
                                            style: TextStyle(
                                              color: Warna.regulerFontColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            '${Constant.currencyCode}10.000',
                                            style: AppTextStyles.productPrice,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget starIconBuilder({
    final int starCount = 5,
    final double starSize = 24.0,
    final Color starColor = Colors.yellow,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        starCount,
        (index) {
          return Icon(
            Icons.star,
            size: starSize,
            color: starColor,
          );
        },
      ),
    );
  }

  Widget bodyReviewsList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 60,
          width: double.infinity,
          color: Colors.white,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            children: reviewsMaps.keys.map((String key) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 0),
                decoration: BoxDecoration(
                  border: key == selectedTab
                      ? Border(
                          bottom: BorderSide(
                              color: Warna.kuning,
                              width: 2,
                              style: BorderStyle.solid),
                        )
                      : null,
                ),
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedTab = key;
                    });
                    log('Tab : $selectedTab');
                  },
                  child: key == 'Semua'
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Semua',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: selectedTab == key
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                  color: selectedTab == key
                                      ? Warna.regulerFontColor
                                      : Warna.abu6,
                                ),
                              ),
                              Text(
                                '(0)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: selectedTab == key
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                                  color: selectedTab == key
                                      ? Warna.regulerFontColor
                                      : Warna.abu6,
                                ),
                              )
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              starIconBuilder(
                                starColor: Warna.kuning,
                                starCount: int.parse(key),
                                starSize: 16.0,
                              ),
                              Text(
                                '(0)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: selectedTab == key
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                                  color: selectedTab == key
                                      ? Warna.regulerFontColor
                                      : Warna.abu6,
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              );
            }).toList(),
          ),
        ),
        ListView.builder(
          itemCount: reviewsMaps[selectedTab]?.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Map<String, dynamic> reviewsItem = reviewsMaps[selectedTab]!;
            String reviewKey = reviewsItem.keys.elementAt(index);
            var item = reviewsItem[reviewKey];
            return Container(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Warna.abu, width: 1.5),
                ),
              ),
              child: reviewItemBox(
                photoProfile: '',
                name: item['nama'],
                rate: item['rate'],
                reviewsText: 'Contoh Ulasan ada disini',
                image: '',
                menuList: 'Bagator, rotbar, markabak',
                dateTime: '17 juli 2024, 13.00',
                respond: 'terima kasih banyak sudah jajan di kami',
              ),
            );
          },
        ),
      ],
    );
  }

  Widget reviewItemBox({
    final String? photoProfile,
    final String? name,
    final String? rate,
    final String? reviewsText,
    final String? image,
    final String? menuList,
    final String? dateTime,
    final String? respond,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                photoProfile!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Warna.abu2,
                    ),
                  );
                },
              ),
            ),
            title: Text(
              name!,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: starIconBuilder(
              starColor: Warna.kuning,
              starCount: int.parse(rate!),
              starSize: 16.0,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            reviewsText!,
            style: AppTextStyles.textRegular,
          ),
          // MENULIST
          menuList != null
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Warna.abu5,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.fastfood_rounded,
                        size: 18,
                        color: Warna.oranye2,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        menuList,
                        style: AppTextStyles.textRegular,
                      )
                    ],
                  ),
                )
              : Container(),
          // IMAGE REVIEWS
          image != null
              ? Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Warna.abu5,
                  ),
                  child: Image.network(
                    image,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        width: 100,
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Warna.abu5,
                        ),
                      );
                    },
                  ),
                )
              : Container(),
          const SizedBox(
            height: 5,
          ),
          Text(
            dateTime!,
            style: AppTextStyles.textRegular,
          ),
          respond != null
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Warna.abu5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Respon Penjual',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        respond,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
