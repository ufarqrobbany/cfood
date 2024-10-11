import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/page_item_void.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/transaction_merchant_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/kurir_pages/chat_seller.dart';
import 'package:cfood/screens/notification.dart';
import 'package:cfood/screens/order_confirm.dart';
import 'package:cfood/screens/order_detail.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/common.dart';
import 'package:cfood/utils/constant.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:uicons/uicons.dart';

class TransactionWirausahaScreen extends StatefulWidget {
  final int firstTabIndex;
  const TransactionWirausahaScreen({super.key, this.firstTabIndex = 0});

  @override
  State<TransactionWirausahaScreen> createState() =>
      _TransactionWirausahaScreenState();
}

class _TransactionWirausahaScreenState
    extends State<TransactionWirausahaScreen> {
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
    TransactionMerchantResponseModel response = await FetchController(
            endpoint: 'orders/merchants/${AppConfig.MERCHANT_ID}',
            fromJson: (json) => TransactionMerchantResponseModel.fromJson(json))
        .getData();

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
        selectedTab = orderStatusTabMenu[widget.firstTabIndex]['code'];
        selectedTabName = orderStatusTabMenu[widget.firstTabIndex]['status'];
        orderList = orderStatusTabMenu[widget.firstTabIndex]['data'];
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
          'Transaksi',
          style: AppTextStyles.title,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        actions: [
          notifIconButton(
            icons: UIcons.solidRounded.bell,
            onPressed: () {
              navigateTo(context, const NotificationScreen());
            },
            iconColor: Warna.biru,
            notifCount: NotificationConfig.sellerNotification.toString(),
          ),
          // const SizedBox(
          //   width: 10,
          // ),
          notifIconButton(
            icons: UIcons.solidRounded.comment,
            onPressed: () {
              navigateTo(context, const ChatSellerScreen());
            },
            iconColor: Warna.biru,
            notifCount: NotificationConfig.sellerChatNotification.toString(),
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
      backgroundColor: Colors.white,
      body: orderDataResponse == null
          ? pageOnLoading(context)
          : orderList!.isEmpty
              ? itemsEmptyBody(context,
                  bgcolors: Warna.pageBackgroundColor, // perbaiki ini
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
                      : FontWeight.normal,
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

  int calculateTotalPrice(List<OrderItemInformations> menuItems) {
    return menuItems.fold(0, (sum, item) => sum + item.totalPriceItem!);
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
    storeItem![storeListIndex].totalPrice =
        calculateTotalPrice(menuItems ?? []);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              storeItem[storeListIndex].orderDate.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.only(top: 0),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     // Icon(
                    //     //   Icons.store,
                    //     //   color: Warna.biru,
                    //     //   size: 20,
                    //     // ),
                    //     Icon(
                    //       storeItem![storeListIndex]
                    //                   .orderInformation!
                    //                   .!
                    //                   .merchantType ==
                    //               "WIRAUSAHA"
                    //           ? CommunityMaterialIcons.handshake
                    //           : Icons.store,
                    //       color: storeItem[storeListIndex]
                    //                   .orderInformation!
                    //                   .merchantInformation!
                    //                   .merchantType ==
                    //               "WIRAUSAHA"
                    //           ? Warna.kuning
                    //           : Warna.biru,
                    //       size: 20,
                    //     ),
                    //     const SizedBox(
                    //       width: 5,
                    //     ),
                    //     Expanded(
                    //       flex: 2,
                    //       child: Text(
                    //         storeItem![storeListIndex]
                    //             .orderInformation!
                    //             .merchantInformation!
                    //             .merchantName
                    //             .toString(),
                    //         // 'nama toko',
                    //         style: const TextStyle(
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.w700,
                    //         ),
                    //       ),
                    //     ),
                    //     // const Spacer(),
                    //     Expanded(
                    //       child: Text(
                    //         storeItem[storeListIndex].orderDate.toString(),
                    //         // style: AppTextStyles.textRegular,
                    //         textAlign: TextAlign.end,
                    //         style: const TextStyle(
                    //           fontSize: 13,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                                  isOwner: true,
                                ));
                          },
                          child: Container(
                            // height: 100,
                            // padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Warna.abu5, width: 1.5),
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
                                  child: menuItems![menuIdx]
                                              .menuInformation!
                                              .menuPhoto ==
                                          null
                                      ? const Center(
                                          child: Icon(Icons.image),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            AppConfig.URL_IMAGES_PATH +
                                                menuItems[menuIdx]
                                                    .menuInformation!
                                                    .menuPhoto!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
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
                                ),
                                title: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        menuItems[menuIdx]
                                            .menuInformation!
                                            .menuName!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
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
                                    Text(menuItems[menuIdx]
                                            .orderVariantInformations!
                                            .isEmpty
                                        ? ''
                                        : getVariantDescription(
                                            menuItems[menuIdx]
                                                .orderVariantInformations!)),
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
                                              formatNumberWithThousandsSeparator(
                                                      menuItems[menuIdx]
                                                          .totalPriceItem!)
                                                  .toString(),
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
                          flex: 9,
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
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(
                                      '${AppConfig.URL_IMAGES_PATH}${storeItem![storeListIndex].orderInformation!.userInformation!.userPhoto}',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: Warna.abu,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  storeItem[storeListIndex]
                                      .orderInformation!
                                      .userInformation!
                                      .userName
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: storeItem[storeListIndex]
                                            .orderInformation!
                                            .userInformation!
                                            .studentInformation ==
                                        null
                                    ? null
                                    : Text(
                                        storeItem[storeListIndex]
                                            .orderInformation!
                                            .userInformation!
                                            .studentInformation!
                                            .studyProgramInformation!
                                            .studyProgramName
                                            .toString(),
                                        style: const TextStyle(
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
                                  '${Constant.currencyCode}${formatNumberWithThousandsSeparator(storeItem[storeListIndex].totalPrice!)}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0C356D),
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              dynamicButtonStatusOrder(
                status: storeItem![storeListIndex].status!,
                onPressed: () {
                  navigateTo(
                      context,
                      OrderDetailScreen(
                        status: storeItem[storeListIndex].status,
                        fromConfirm: false,
                        orderId: storeItem[storeListIndex].id,
                        isOwner: true,
                      ));
                },
                statusMap: orderStatusMap,
                text: storeItem[storeListIndex].status!,
              ),
            ],
          ),
        ),
      ],
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
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(8)),
                ),
              ),
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Warna.biru, size: 25),
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
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(8)),
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
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(8)),
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
