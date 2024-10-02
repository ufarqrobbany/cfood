import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/page_item_void.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/get_all_order_list_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/order_confirm.dart';
import 'package:cfood/screens/order_detail.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/common.dart';
import 'package:cfood/utils/constant.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String selectedTab = 'all';
  String selectedTabName = 'Semua';
  DataOrders? orderDataResponse;
  List<OrderItem>? orderList;
  List<Map<String, dynamic>> orderStatusTabMenu = [
    {
      'status': 'Semua',
      'code': 'all',
      'data': DataOrders().all,
    },
    {
      'status': 'Dalam Proses',
      'code': 'inProcess',
      'data': DataOrders().inProcess,
    },
    {
      'status': 'Selesai',
      'code': 'done',
      'data': DataOrders().done,
    },
    {
      'status': 'Dibatalkan',
      'code': 'cancelled',
      'data': DataOrders().cancelled,
    }
  ];
  List<Map<String, dynamic>> orderStatusMap = [
    {
      'status': 'Belum Bayar',
      'code': 'BELUM_BAYAR',
      'icon': Icons.money,
      'color': Warna.abu4,
      'highlight': true,
    },
    {
      'status': 'Menunggu Konfirmasi Penjual',
      'code': 'MENUNGGU_KONFIRM_PENJUAL',
      'icon': UIcons.solidRounded.hat_chef,
      'color': Warna.kuning,
      'highlight': true,
    },
     {
      'status': 'Pesanan Disiapkan',
      'code': 'DIPROSES_PENJUAL',
      'icon': UIcons.solidRounded.hat_chef,
      'color': Warna.kuning,
      'highlight': true,
    },
     {
      'status': 'Menunggu Konfirmasi Kurir',
      'code': 'MENUNGGU_KONFIRM_KURIR',
      'icon': UIcons.solidRounded.hat_chef,
      'color': Warna.kuning,
      'highlight': true,
    },
    {
      'status': 'Pesanan Sedang Diantar',
      'code': 'DIPROSES_KURIR',
      'icon': Icons.directions_bike_rounded,
      'color': Warna.oranye2,
      'highlight': true,
    },
    {
      'status': 'Pesanan Selesai',
      'code': 'PESANAN_SAMPAI',
      'icon': Icons.check_circle_outline_rounded,
      'color': Warna.hijau,
      'highlight': false,
    },
     {
      'status': 'Konfirmasi sudah Sampai',
      'code': 'KONFIRM_SAMPAI',
      'icon': Icons.check_circle_outline_rounded,
      'color': Warna.hijau,
      'highlight': false,
    },
    {
      'status': 'Pesanan Dibatalkan',
      'code': 'DIBATALKAN',
      'icon': UIcons.regularRounded.calendar_exclamation,
      'color': Warna.like,
      'highlight': false,
    },
    {
      'status': 'Ditolak',
      'code': 'DITOLAK',
      'icon': UIcons.regularRounded.calendar_exclamation,
      'color': Warna.like,
      'highlight': false,
    },
  ];

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

  Future<Map<String, dynamic>> buttonChangeState({
    String? status,
    String? statusCode,
    List<Map<String, dynamic>>? statusMap,
  }) async {
    if (status == null && statusCode == null) {
      throw ArgumentError("Either status or statusCode must be provided.");
    }

    Map<String, dynamic>? result;
    // log("status : $status");

    if (status != null) {
      result = statusMap?.firstWhere((element) => element['code'] == status,
          orElse: () => {});
    } 
    // else if (statusCode != null) {
    //   result = statusMap?.firstWhere((element) => element['code'] == statusCode,
    //       orElse: () => {});
    // }

    // log(result.toString());

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
    fetchData();
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 10));

    print('reload...');
  }

  Future<void> fetchData() async {
    OrderListResponse response = await FetchController(
        endpoint: 'orders/${AppConfig.USER_ID}',
        fromJson: (json) => OrderListResponse.fromJson(json)).getData();

    if (response.statusCode == 200) {
      setState(() {
        orderDataResponse = response.data;
        orderStatusTabMenu = [
          {
            'status': 'Semua',
            'code': 'all',
            'data': orderDataResponse?.all,
          },
          {
            'status': 'Dalam Proses',
            'code': 'inProcess',
            'data': orderDataResponse?.inProcess,
          },
          {
            'status': 'Selesai',
            'code': 'done',
            'data': orderDataResponse?.done,
          },
          {
            'status': 'Dibatalkan',
            'code': 'cancelled',
            'data': orderDataResponse?.cancelled,
          }
        ];
        orderList = orderStatusTabMenu[0]['data'];
        log(orderList!.length.toString());
        log(orderDataResponse.toString());
      });
    }
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
            'Pesanan',
            style: AppTextStyles.title,
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          scrolledUnderElevation: 0,
          actions: [
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
                itemCount: orderStatusTabMenu?.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 25),
                itemBuilder: (context, index) {
                  return tabMenuItem(
                    onPressed: () {
                      setState(() {
                        selectedTab = orderStatusTabMenu[index]['code'];
                        selectedTabName = orderStatusTabMenu[index]['status'];
                        orderList = orderStatusTabMenu[index]['data'];
                        log(orderList!.length.toString());
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
        body: orderDataResponse == null
            ? pageOnLoading(context)
            : orderList!.isEmpty
                ? itemsEmptyBody(context,
                    bgcolors: Colors.white,
                    icons: UIcons.solidRounded.shopping_cart,
                    iconsColor: Warna.kuning,
                    text: 'Tidak ada pesanan dengan status $selectedTabName')
                : ReloadIndicatorType1(
                    onRefresh: refreshPage,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ListView.builder(
                        // itemCount: orderListItems.length,
                        itemCount: orderList?.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: index == orderList!.length - 1
                                ? const EdgeInsets.fromLTRB(0, 10, 0, 100)
                                : const EdgeInsets.symmetric(vertical: 10),
                            child: orderItemBox(
                              storeListIndex: index,
                              storeItem: orderList,
                              menuItems: orderList![index]
                                  .orderInformation
                                  ?.orderItemInformations,
                            ),
                          );
                        },
                      ),
                    ),
                  ));
  }

  Widget orderItemBox({
    // String? imgUrl,
    int storeListIndex = 0,
    List<OrderItem>? storeItem,
    List<OrderItemInformations>? menuItems,
  }) {
    bool highlightStatus =
        storeItem?[storeListIndex].status == 'MENUNGGU_KONFIRM_PENJUAL' ||
            storeItem?[storeListIndex].status == 'MENUNGGU_PEMBAYARAN' ||
            storeItem?[storeListIndex].status == 'PESANAN_DIANTARKAN';

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
              // Icon(
              //   Icons.store,
              //   color: Warna.biru,
              //   size: 20,
              // ),
               Icon(
                storeItem![storeListIndex].orderInformation!.merchantInformation!
                            .merchantType ==
                        "WIRAUSAHA"
                    ? CommunityMaterialIcons.handshake
                    : Icons.store,
                color: storeItem[storeListIndex].orderInformation!.merchantInformation!
                            .merchantType ==
                        "WIRAUSAHA"
                    ? Warna.kuning
                    : Warna.biru,
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 2,
                child: Text(
                  storeItem![storeListIndex]
                      .orderInformation!
                      .merchantInformation!
                      .merchantName
                      .toString(),
                  // 'nama toko',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // const Spacer(),
              Expanded(
                child: Text(
                  storeItem[storeListIndex].orderDate.toString(),
                  // style: AppTextStyles.textRegular,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
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
                      OrderDetailScreen(
                        status: storeItem[storeListIndex].status,
                        fromConfirm: false,
                        orderId: storeItem[storeListIndex].id,
                      ));
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
                        child: menuItems[menuIdx].menuInformation!.menuPhoto ==
                                null
                            ? const Center(
                                child: Icon(Icons.image),
                              )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                  AppConfig.URL_IMAGES_PATH +
                                      menuItems[menuIdx]
                                          .menuInformation!
                                          .menuPhoto!,
                                          fit: BoxFit.cover,
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
                      ),
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              menuItems[menuIdx].menuInformation!.menuName!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            '${menuItems[menuIdx].quantity}x',
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
                          Text( menuItems[menuIdx].orderVariantInformations!.isEmpty
                            ? ''
                            : getVariantDescription(
                                 menuItems[menuIdx].orderVariantInformations!)),
                          // menuItems[menuIdx]
                          //         .orderVariantInformations != null ?
                          // SizedBox(
                          //   height: 15,
                          //   width: MediaQuery.of(context).size.width * 0.60,
                          //   child: ListView.builder(
                          //     itemCount: menuItems[menuIdx]
                          //         .orderVariantInformations!
                          //         .length,
                          //     shrinkWrap: true,
                          //     physics: const NeverScrollableScrollPhysics(),
                          //     scrollDirection: Axis.horizontal,
                          //     itemBuilder: (context, variantIdx) {
                          //       return Text(
                          //         menuItems[menuIdx]
                          //             .orderVariantInformations![variantIdx]
                          //             .variantOptionInformations
                          //             .toString()
                          //             .replaceAll('[', '')
                          //             .replaceAll(']', ''),
                          //       );
                          //     },
                          //   ),
                          // ) : const SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                Constant.currencyCode +
                                    formatNumberWithThousandsSeparator(menuItems[menuIdx]
                                        .totalPriceItem!).toString(),
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
            status: storeItem[storeListIndex].status!,
            onPressed: () {
              navigateTo(
                  context,
                  OrderDetailScreen(
                    status: storeItem[storeListIndex].status,
                    fromConfirm: false,
                    orderId: storeItem[storeListIndex].id,
                  ));
            },
            statusMap: orderStatusMap,
            text: storeItem[storeListIndex].status!,
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
        } 
        else if (snapshot.hasError) {
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
        } 
        else if (snapshot.hasData) {
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
