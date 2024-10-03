import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/page_item_void.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/add_merchants_response.dart';
// import 'package:cfood/model/get_all_order_list_response.dart';
import 'package:cfood/model/get_merchant_order_response.dart';
import 'package:cfood/model/open_close_store_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/inbox.dart';
import 'package:cfood/screens/order_confirm.dart';
import 'package:cfood/screens/order_detail.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/common.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:uicons/uicons.dart';

class OrderWirausahaScreen extends StatefulWidget {
  const OrderWirausahaScreen({super.key});

  @override
  State<OrderWirausahaScreen> createState() => _OrderWirausahaScreenState();
}

class _OrderWirausahaScreenState extends State<OrderWirausahaScreen> {
  bool isOpen = false;
  AddMerchantResponse? merchantDataResponse;
  MerchantOrderResponse? orderDataResponse;
  List<DataOrder>? orderList;
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

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchSummaryMerchant();
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 10));

    print('reload...');
  }

  Future<void> fetchData() async {
    MerchantOrderResponse response = await FetchController(
        endpoint: 'orders/incoming/${AppConfig.MERCHANT_ID}',
        fromJson: (json) => MerchantOrderResponse.fromJson(json)).getData();

    if (response.statusCode == 200) {
      setState(() {
        orderDataResponse = response;
        orderList = response.data;
        log(orderList!.length.toString());
        log(orderDataResponse.toString());
      });
    }
  }

  Future<void> merchantStatusOpen(bool value) async {
    OpenCloseStoreResponse response = await FetchController(
      // endpoint: 'merchants/${AppConfig.MERCHANT_ID}/status?isOpen=$value',
      endpoint: 'merchants/${AppConfig.MERCHANT_ID}/status?isOpen=${!isOpen}',
      fromJson: (json) => OpenCloseStoreResponse.fromJson(json),
    ).putData({});

    if (response.data != null) {
      setState(() {
        isOpen = response.data!.open!;
        AppConfig.MERCHANT_OPEN = isOpen;
      });
      log('is open : $isOpen');
    }
  }

  Future<void> fetchSummaryMerchant() async {
    merchantDataResponse = await FetchController(
      endpoint: 'merchants/${AppConfig.MERCHANT_ID}',
      fromJson: (json) => AddMerchantResponse.fromJson(json),
    ).getData();

    setState(() {
      AppConfig.MERCHANT_NAME = merchantDataResponse!.data!.merchantName!;
      AppConfig.MERCHANT_DESC = merchantDataResponse!.data!.merchantDesc!;
      AppConfig.MERCHANT_PHOTO = AppConfig.URL_IMAGES_PATH +
          merchantDataResponse!.data!.merchantPhoto!;

      isOpen = merchantDataResponse!.data!.open!;
    });
    log(
      {
        "name": AppConfig.MERCHANT_NAME,
        "desc": AppConfig.MERCHANT_DESC,
        "photo": AppConfig.MERCHANT_PHOTO,
        "isOpen": isOpen,
      }.toString(),
    );
  }

  bool isConfirm = false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      body: ReloadIndicatorType1(
        onRefresh: refreshPage,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverLayoutBuilder(builder: (context, constraints) {
              // print(constraints.scrollOffset);
              final scrolled = constraints.scrollOffset > 0.0;
              final moveToogleBox = constraints.scrollOffset > 80.0;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.bounceOut,
                child: SliverAppBar(
                  leadingWidth: moveToogleBox ? 90 : 10,
                  leading: moveToogleBox ? switchOpenBox() : Container(),
                  pinned: true,
                  stretch: true,
                  title: Text(
                    AppConfig.MERCHANT_NAME,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // NOTIF BUTTONS
                  actions: [
                    notifIconButton(
                      icons: UIcons.solidRounded.bell,
                      notifCount: '22',
                    ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    notifIconButton(
                      icons: UIcons.solidRounded.comment,
                      notifCount: '5',
                      onPressed: () => navigateTo(
                          context,
                          InboxScreen(
                            canBack: true,
                          )),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                  onStretchTrigger: () {
                    return Future<void>.value();
                  },
                  // changeble background
                  backgroundColor:
                      scrolled ? Warna.biru : Warna.pageBackgroundColor,
                  // Flexible SpaceBar
                  expandedHeight: 140,
                  // expandedHeight: 245,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                      // StretchMode.fadeTitle,
                    ],
                    centerTitle: true,
                    expandedTitleScale: 1.0,
                    titlePadding: const EdgeInsets.symmetric(horizontal: 25),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          // padding: const EdgeInsets.only(bottom: 45),
                          decoration: BoxDecoration(
                            color: Warna.pageBackgroundColor,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(8),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(8),
                            ),
                            child: Image.network(
                              AppConfig.MERCHANT_PHOTO,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // child: Image.asset(
                          //   'assets/header_image.jpg',
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        Container(
                          // margin: const EdgeInsets.only(bottom: 45),
                          decoration: BoxDecoration(
                            color: Warna.biru.withOpacity(0.80),
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(8),
                            ),
                          ),
                        ),

                        // WELCOME WIDGETS
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 40),
                                constraints: const BoxConstraints(
                                  maxWidth: 280,
                                  minWidth: 280,
                                ),
                              ),
                              // const SizedBox(height: 80,),
                              const Spacer(),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Buka Toko',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  switchOpenBox(),
                                ],
                              ),

                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
            SliverList(
                delegate: SliverChildListDelegate([
              // Order list
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                child: Text(
                  'Pesanan Masuk',
                  style: AppTextStyles.subTitle,
                  textAlign: TextAlign.left,
                ),
              ),
              orderListBody(),
            ])),
          ],
        ),
      ),
    );
  }

  Widget switchOpenBox() => Transform.scale(
        scale: 1,
        child: Switch(
          value: isOpen,
          onChanged: (value) {
            // setState(() {
            //   isOpen = value;
            // });
            merchantStatusOpen(value);
          },
          activeColor: Warna.kuning,
          activeTrackColor: Warna.kuning.withOpacity(0.14),
          inactiveThumbColor: Colors.transparent,
          inactiveTrackColor: Colors.transparent,
          splashRadius: 50.0,
        ),
      );

  Widget orderListBody() {
    return orderDataResponse == null
        ? pageOnLoading(context)
        : orderList!.isEmpty
            ? itemsEmptyBody(context,
                bgcolors: Warna.pageBackgroundColor,
                icons: UIcons.solidRounded.shopping_cart,
                iconsColor: Warna.kuning,
                text: 'Tidak ada Pesanan')
            : ListView.builder(
                itemCount: orderList?.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 15),
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
              );
  }

  Widget orderItemBox({
    // String? imgUrl,
    int storeListIndex = 0,
    List<DataOrder>? storeItem,
    List<OrderItemInformations>? menuItems,
  }) {
    bool highlightStatus =
        storeItem?[storeListIndex].status == 'MENUNGGU_KONFIRM_PENJUAL' ||
            storeItem?[storeListIndex].status == 'MENUNGGU_PEMBAYARAN' ||
            storeItem?[storeListIndex].status == 'PESANAN_DIANTARKAN';

    return isConfirm == true
        ? Container()
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    storeItem![storeListIndex].orderDate.toString(),
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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListView.builder(
                      itemCount: menuItems?.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, menuIdx) {
                        return InkWell(
                          onTap: () {
                            navigateTo(
                                context,
                                OrderDetailScreen(
                                  isOwner: true,
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
                                    errorBuilder:
                                        (context, error, stackTrace) =>
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
                                  'Nobby Dharma Khaulid',
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
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DynamicColorButton(
                            onPressed: () {},
                            text: 'Tolak',
                            textColor: Warna.regulerFontColor,
                            backgroundColor: Warna.like.withOpacity(0.05),
                            border: BorderSide(color: Warna.like, width: 1),
                            borderRadius: 50,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: DynamicColorButton(
                            onPressed: () {
                              setState(() {
                                isConfirm = true;
                              });
                            },
                            text: 'Konfirmasi',
                            backgroundColor: Warna.hijau,
                            borderRadius: 50,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
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
      'store': 'Babarecii Store',
      'type': 'Wirausaha',
      'selected': true,
      'status': 'Belum Bayar',
      'menu': [
        {
          'id': '1',
          'name': 'Onde-onde si Mantan',
          'image':
              'http://cfood.id/api/images/41f5f883-9263-417d-9eb0-c1ca52753cf8.jpg',
          'price': 2000,
          'count': 5,
          'variants': [],
        }
      ],
    },
  ];
}
