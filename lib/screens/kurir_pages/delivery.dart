import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/screens/kurir_pages/order_status.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class DeliveryInfoScreen extends StatefulWidget {
  const DeliveryInfoScreen({super.key});

  @override
  State<DeliveryInfoScreen> createState() => _DeliveryInfoScreenState();
}

class _DeliveryInfoScreenState extends State<DeliveryInfoScreen> {
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
  List<Map<String, dynamic>> orderStatusMap = [
    {
      'status': 'Belum Bayar',
      'code': 'belum_bayar',
      'icon': Icons.money,
      'color': Warna.abu4,
      'highlight': true,
    },
    {
      'status': 'Pesanan Sedang Disiapkan',
      'code': 'disiapkan',
      'icon': UIcons.solidRounded.hat_chef,
      'color': Warna.kuning,
      'highlight': true,
    },
    {
      'status': 'Pesanan Sedang Diantar',
      'code': 'diantar',
      'icon': Icons.directions_bike_rounded,
      'color': Warna.oranye2,
      'highlight': true,
    },
    {
      'status': 'Pesanan Selesai',
      'code': 'selesai',
      'icon': Icons.check_circle_outline_rounded,
      'color': Warna.hijau,
      'highlight': false,
    },
    {
      'status': 'Pesanan Dibatalkan',
      'code': 'dibatalkan',
      'icon': UIcons.regularRounded.calendar_exclamation,
      'color': Warna.like,
      'highlight': false,
    },
  ];

  List<Map<String, dynamic>> orderListItems = [
    {
      'id': '00',
      'store': 'nama toko',
      'type': 'Kantin',
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
  ];

  Future<Map<String, dynamic>> buttonChangeState({
    String? status,
    String? statusCode,
    List<Map<String, dynamic>>? statusMap,
  }) async {
    if (status == null && statusCode == null) {
      throw ArgumentError("Either status or statusCode must be provided.");
    }

    Map<String, dynamic>? result;

    if (status != null) {
      result = statusMap?.firstWhere((element) => element['status'] == status,
          orElse: () => {});
    } else if (statusCode != null) {
      result = statusMap?.firstWhere((element) => element['code'] == statusCode,
          orElse: () => {});
    }

    if (result == null || result.isEmpty) {
      throw Exception("Status or code not found in the status map.");
    }

    return {
      'text': result['status'],
      'icon': result['icon'],
      'color': result['color'],
      'highlight': result['highlight'],
    };
  }

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
        leadingWidth: 90,
        leading: backButtonCustom(context: context),
        title: const Text(
          'Pengantaran',
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
                    activeColor: Warna.kuning,
                  );
                },
              ),
            ),
          ),
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

  Widget orderItemBox({
    // String? imgUrl,
    int storeListIndex = 0,
    List<Map<String, dynamic>>? storeItem,
    List<Map<String, dynamic>>? menuItems,
  }) {
    bool highlightStatus = storeItem?[storeListIndex]['status'] ==
            'Belum Bayar' ||
        storeItem?[storeListIndex]['status'] == 'Pesanan Sedang Disiapkan' ||
        storeItem?[storeListIndex]['status'] == 'Pesanan Sedang Diantar';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: highlightStatus
            ? Border.all(
                color: Warna.kuning,
                width: 1,
              )
            : null,
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
                storeItem![storeListIndex]['store'].toString(),
                // 'nama toko',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              const Text(
                '23 Juli 2024, 13.00',
                style: AppTextStyles.textRegular,
              ),
            ],
          ),
          ListView.builder(
            itemCount: menuItems?.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, menuIdx) {
              return InkWell(
                onTap: () {
                  navigateTo(
                    context,
                    DriverOrderStatusScreen(
                      orderStatus: storeItem[storeListIndex]['status'],
                      orderId: 1,
                    ),
                  );
                },
                child: Container(
                  // height: 100,
                  // padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: menuIdx == menuItems!.length - 1
                          ? const BorderSide(
                              color: Colors.transparent, width: 1.5)
                          : BorderSide(color: Warna.abu5, width: 1.5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
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
                                      borderRadius: BorderRadius.circular(8),
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
          dynamicButtonStatusOrder(
            status: storeItem[storeListIndex]['status'],
            onPressed: () {
              navigateTo(
                  context,
                  DriverOrderStatusScreen(
                    orderId: int.parse(storeItem[storeListIndex]['id']),
                    orderStatus: storeItem[storeListIndex]['status'],
                  ));
            },
            statusMap: orderStatusMap,
            text: storeItem[storeListIndex]['status'],
          ),
        ],
      ),
    );
  }

  // Belum Bayar | Pesanan sedang DIkirim | Pesanan Sedang diantar | Pesanana Selesai | Pesanan Dibatalkan
  Widget dynamicButtonStatusOrder({
    String? type,
    VoidCallback? onPressed,
    String status = '',
    String text = '',
    // IconData? icons,
    //  Future<Map<String, dynamic>> state,
    List<Map<String, dynamic>>? statusMap,
  }) {
    return FutureBuilder<Map<String, dynamic>>(
      future: buttonChangeState(status: status, statusMap: statusMap),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 36,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(34),
                ),
              ),
              child: const CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 36,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(34),
                ),
              ),
              child: const Text(
                "Error",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final statusData = snapshot.data!;
          return SizedBox(
            height: 36,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: statusData['color'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(34),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    statusData['icon'],
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    statusData['text'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
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
                    BorderSide(color: activeColor ?? Warna.kuning, width: 2))
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
                      : Warna.abu6,
                  fontSize: 15,
                  fontWeight: menuName == selectedTab
                      ? FontWeight.w700
                      : FontWeight.normal,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons,
                    size: 20,
                    color: menuName == selectedTab ? activeColor : Warna.abu6,
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
                      fontWeight: menuName == selectedTab
                          ? FontWeight.w700
                          : FontWeight.normal,
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
