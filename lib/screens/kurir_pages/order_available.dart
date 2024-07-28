import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';

class OrderAvailableScreen extends StatefulWidget {
  const OrderAvailableScreen({super.key});

  @override
  State<OrderAvailableScreen> createState() => _OrderAvailableScreenState();
}

class _OrderAvailableScreenState extends State<OrderAvailableScreen> {
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
        title: const Text(
          'Pesanan Tersedia',
          style: AppTextStyles.title,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Warna.pageBackgroundColor,
      body: ReloadIndicatorType1(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ListView.builder(
            itemCount: orderListItems.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            itemBuilder: (context, index) {
              List<Map<String, dynamic>> orderMenuItems =
                  orderListItems[index]['menu'];
              return Padding(
                padding: index == orderListItems.length - 1
                    ? const EdgeInsets.fromLTRB(0, 10, 0, 100)
                    : const EdgeInsets.symmetric(vertical: 10),
                child: orderItemBox(
                  storeListIndex: index,
                  storeItem: orderListItems,
                  menuItems: orderMenuItems,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

    Widget orderItemBox({
    // String? imgUrl,
    int storeListIndex = 0,
    List<Map<String, dynamic>>? storeItem,
    List<Map<String, dynamic>>? menuItems,
  }) {
    // bool highlightStatus = storeItem?[storeListIndex]['status'] == 'Belum Bayar' ||
    //                    storeItem?[storeListIndex]['status'] == 'Pesanan Sedang Disiapkan' ||
    //                    storeItem?[storeListIndex]['status'] == 'Pesanan Sedang Diantar';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '23 Juli 2024, 13.00',
              style: AppTextStyles.textRegular,
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // border: highlightStatus ? Border.all(
            //   color: Warna.kuning,
            //   width: 1,
            // ) : null,
            boxShadow: [
              BoxShadow(
                  blurRadius: 20,
                  spreadRadius: 0,
                  color: Warna.shadow.withOpacity(0.12),
                  offset: const Offset(0, 0))
            ],
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                itemCount: menuItems?.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, menuIdx) {
                  return InkWell(
                    onTap: () {
                      // navigateTo(context, OrderDetailScreen(status: storeItem[storeListIndex]['status'],));
                    },
                    child: Container(
                      // height: 100,
                      // padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: menuIdx == menuItems!.length - 1
                              ? BorderSide(color: Warna.abu, width: 1.5)
                              : const BorderSide(
                                  color: Colors.transparent, width: 1.5),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: false,
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Warna.abu,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: menuItems[menuIdx]['image'] == null
                                ? const Center(
                                    child: Icon(Icons.image),
                                  )
                                : Image.network(
                                    menuItems[menuIdx]['image'],
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Warna.abu,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          title: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                menuItems[menuIdx]['name'],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${menuItems[menuIdx]['count']}x',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                          subtitle: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                menuItems[menuIdx]['variants']
                                    .toString()
                                    .replaceAll('[', '')
                                    .replaceAll(']', ''),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    Constant.currencyCode +
                                        menuItems[menuIdx]['price'].toString(),
                                    style: AppTextStyles.productPrice,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: false,
                          leading: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Warna.abu,
                            ),
                            child: Image.network(
                              '/.jpg',
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Warna.abu,
                                ),
                              ),
                            ),
                          ),
                          title: const Text(
                            'Pembeli\n[Username Pembeli]',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // subtitle: starIconBuilder(starCount: 5),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Total',
                            style: AppTextStyles.textRegular,
                          ),
                          Text(
                            '${Constant.currencyCode}10.000',
                            style: AppTextStyles.productPrice,
                          )
                        ],
                      ))
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 45,
              width: 100,
              child: DynamicColorButton(
                onPressed: () {},
                text: 'Tolak',
                backgroundColor: Warna.like,
                borderRadius: 50,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 45,
              width: 100,
              child: DynamicColorButton(
                onPressed: () {},
                text: 'Terima',
                backgroundColor: Warna.hijau,
                borderRadius: 50,
              ),
            ),
          ],
        )
      ],
    );
  }

  List<Map<String, dynamic>> orderListItems = [
    {
      'id': '0',
      'store': 'nama toko',
      'type': 'Kantin',
      'selected': true,
      'status': 'Belum Bayar',
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
      'selected': true,
      'status': 'Pesanan Sedang Disiapkan',
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
      'selected': true,
      'status': 'Pesanan Sedang Diantar',
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
      'selected': true,
      'status': 'Pesanan Selesai',
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
      'id': '0',
      'store': 'nama toko',
      'type': 'Wirausaha',
      'selected': true,
      'status': 'Pesanan Dibatalkan',
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
}
