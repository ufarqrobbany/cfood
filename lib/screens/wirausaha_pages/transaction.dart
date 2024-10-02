import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class TransactionWirausahaScreen extends StatefulWidget {
  const TransactionWirausahaScreen({super.key});

  @override
  State<TransactionWirausahaScreen> createState() =>
      _TransactionWirausahaScreenState();
}

class _TransactionWirausahaScreenState
    extends State<TransactionWirausahaScreen> {
  String selectedTab = 'all';
  List<Map<String, dynamic>> orderStatusTabMenu = [
    {
      'status': 'Semua',
      'code': 'all',
    },
    {
      'status': 'Dalam Proses',
      'code': 'process',
    },
    {
      'status': 'Selesai',
      'code': 'done',
    },
    {
      'status': 'Dibatalkan',
      'code': 'canceled',
    }
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
          'Transaksi',
          style: AppTextStyles.title,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        actions: [
          notifIconButton(
            icons: UIcons.solidRounded.bell,
            onPressed: () {},
            iconColor: Warna.biru,
            notifCount: '7',
          ),
          // const SizedBox(
          //   width: 10,
          // ),
          notifIconButton(
            icons: UIcons.solidRounded.comment,
            onPressed: () {},
            iconColor: Warna.biru,
            notifCount: '7',
          ),
          const SizedBox(
            width: 10,
          ),
        ],
        // TAB BUtton
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              itemCount: orderStatusTabMenu.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              itemBuilder: (context, index) {
                return tabMenuItem(
                  onPressed: () {
                    setState(() {
                      selectedTab = orderStatusTabMenu[index]['code'];
                    });
                  },
                  text: orderStatusTabMenu[index]['status'],
                  menuName: orderStatusTabMenu[index]['code'],
                  activeColor: Warna.oranye1,
                );
              },
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
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
              // Map<String, dynamic> orderMenuItems = orderListItems[index]['menu'];
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

  Widget tabMenuItem(
      {VoidCallback? onPressed,
      String? text,
      IconData? icons,
      String? menuName,
      Color? activeColor}) {
    return Container(
      decoration: BoxDecoration(
        border: menuName == selectedTab
            ? Border(
                bottom:
                    BorderSide(color: activeColor ?? Warna.oranye1, width: 2))
            : null,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          elevation: 0,
        ),
        child: icons == null
            ? Text(
                text!,
                style: TextStyle(
                  color: menuName == selectedTab
                      ? Warna.regulerFontColor
                      : Colors.black45,
                  fontSize: 15,
                  fontWeight: menuName == selectedTab
                      ? FontWeight.w700
                      : FontWeight.w600,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons,
                    size: 20,
                    color: menuName == selectedTab
                        ? activeColor
                        : Warna.regulerFontColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    text!,
                    style: TextStyle(
                      color: menuName == selectedTab
                          ? activeColor
                          : Warna.regulerFontColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
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
                          subtitle: starIconBuilder(starCount: 5, starSize: 15),
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
              child: DynamicColorButton(
                onPressed: () {},
                text: 'Pesanan Siap',
                backgroundColor: Warna.biru,
                borderRadius: 14,
              ),
            ),
          ],
        )
      ],
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
