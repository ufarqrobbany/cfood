import 'dart:developer';

import 'package:cfood/custom/CBottomSheet.dart';
import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool menuOrderCountInfo = true;
  List<Map<String, dynamic>> cartListItems = [
    {
      'id': '0',
      'store': 'nama toko',
      'type': 'Kantin',
      'selected': false,
      'menu': [
        {
          'id': '1',
          'name': 'nama menu',
          'image': '/.jpg',
          'price': 10000,
          'count': 1,
          'variants': ['coklat', 'susu', 'tiramusi'],
        },
        {
          'id': '1',
          'name': 'nama menu',
          'image': '/.jpg',
          'price': 10000,
          'count': 2,
          'variants': ['coklat', 'tiramusi'],
        },
      ],
    },
    {
      'id': '1',
      'store': 'nama toko',
      'type': 'Wirausaha',
      'selected': false,
      'menu': [
        {
          'id': '1',
          'name': 'nama menu',
          'image': '/.jpg',
          'price': 10000,
          'count': 1,
          'variants': ['coklat', 'susu', 'tiramusi'],
        },
      ],
    },
    {
      'id': '0',
      'store': 'nama toko',
      'type': 'Kantin',
      'selected': false,
      'menu': [
        {
          'id': '1',
          'name': 'nama menu',
          'image': '/.jpg',
          'price': 10000,
          'count': 3,
          'variants': ['coklat', 'susu', 'tiramusi'],
        },
      ],
    },
    {
      'id': '0',
      'store': 'nama toko',
      'type': 'Wirausaha',
      'selected': false,
      'menu': [
        {
          'id': '1',
          'name': 'nama menu',
          'image': '/.jpg',
          'price': 10000,
          'count': 1,
          'variants': ['coklat', 'susu', 'tiramusi'],
        },
        {
          'id': '1',
          'name': 'nama menu',
          'image': '/.jpg',
          'price': 10000,
          'count': 2,
          'variants': ['coklat', 'tiramusi'],
        },
      ],
    },
  ];

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
        leading: Container(
          width: 0,
        ),
        leadingWidth: 20,
        title: const Text(
          'Keranjang',
          style: AppTextStyles.title,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        actions: [
          notifIconButton(
            icons: UIcons.solidRounded.comment,
            onPressed: () {},
            iconColor: Warna.regulerFontColor,
            notifCount: '7',
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: cartBodyList(),
      floatingActionButton: storeMenuCountInfo(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  Widget cartBodyList() {
    return ReloadIndicatorType1(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ListView.builder(
            itemCount: cartListItems.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, idxCart) {
              List<Map<String, dynamic>> storeMenuList =
                  cartListItems[idxCart]['menu'];
              var store = cartListItems[idxCart];
              return Container(
                margin: idxCart == cartListItems.length - 1
                    ? const EdgeInsets.only(bottom: 180)
                    : EdgeInsets.zero,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Warna.abu5,
                      width: 14,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.radio_button_checked_rounded,
                            color: Warna.biru,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.store,
                                color: Warna.biru,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                store['store'].toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Icon(
                            UIcons.solidRounded.trash,
                            color: Warna.like,
                            size: 25,
                          )
                        ],
                      ),
                    ),
                    ListView.builder(
                      itemCount: storeMenuList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, idxMenu) {
                        var menuItem = storeMenuList[idxMenu];
                        return Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: ProductCardBoxHorizontal(
                            innerContentSize: 90,
                            onPressed: () {
                              log('product: ${menuItem['nama']}');
                              // storeMenuCountSheet();
                              menuFrameSheet(context);
                            },
                            productName: menuItem['name'],
                            description: 'deskripsi menu',
                            price: menuItem['price'].toString(),
                            count: menuItem['count'].toString(),
                            onTapAdd: () {
                              setState(() {
                                menuItem['count'] += 1;
                              });
                            },
                            onTapRemove: () {
                              setState(() {
                                menuItem['count'] -= 1;
                              });
                            },
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
      );
  }

  Widget storeMenuCountInfo() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      height: menuOrderCountInfo ? 116 : 0,
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      margin: menuOrderCountInfo ? const EdgeInsets.only(bottom: 80) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(60),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Expanded(
            //   flex: 2,
            //   child: Container(
            //     color: Warna.kuning,
            //     child: Center(
            //       child: Icon(
            //         UIcons.solidRounded.comment,
            //         size: 25,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              flex: 8,
              child: Container(
                color: Warna.biru,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListTile(
                      // contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: Icon(
                        UIcons.solidRounded.shopping_cart,
                        size: 25,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Pesan Sekarang',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800),
                      ),
                      subtitle: const Text(
                        '2 Menu | 7 Item',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: const SizedBox(
                        width: 85,
                        child: FittedBox(
                          child: Text(
                            'Rp100.000',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
