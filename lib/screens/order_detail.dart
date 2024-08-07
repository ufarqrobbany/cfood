import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/order_status_timeline_tile.dart';
import 'package:cfood/model/confirm_cart_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/chat.dart';
import 'package:cfood/screens/order_confirm.dart';
import 'package:cfood/screens/rate_screen.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/common.dart';
import 'package:cfood/utils/constant.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class OrderDetailScreen extends StatefulWidget {
  final String? status;
  final int? merchantId;
  final int? cartId;

  final String noteOrder;
  final String orderNumber;
  final String orderTime;
  final String paymentMethod;
  const OrderDetailScreen({
    super.key,
    this.status,
    this.merchantId,
    this.cartId,
    this.noteOrder = '',
    this.orderNumber = '',
    this.orderTime = '',
    this.paymentMethod = '',
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  ConfirmCartResponse? confirmCartResponse;
  DataConfirmCart? dataConfirmCart;
  String currentStatus = '';
  final List<Map<String, dynamic>> orderStatusProses = [
    {
      'status': 'Dikonfirmasi',
      'time': '00.00',
      'done': true,
      'onProgress': false,
    },
    {
      'status': 'Diproses',
      'time': '00.00',
      'done': true,
      'onProgress': false,
    },
    {
      'status': 'Diantar',
      'time': '00.00',
      'done': false,
      'onProgress': true,
    },
    {
      'status': 'Selesai',
      'time': '00.00',
      'done': false,
      'onProgress': false,
    },
  ];

  Map<String, dynamic> driverInfo = {
    'id': '0000',
    'profile': '/.jpg',
    'name': 'Kusen DanaAtamaya',
    'rate': '5.0',
    'notification': 7,
  };

  Map<String, dynamic> orderStatusInfoData = {
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
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      currentStatus = widget.status!;
    });
    fetchData();
  }

  Future<void> fetchData() async {
    if (widget.cartId != null) {
      fetchConfirmCartByCartId();
    } else {
      fetchConfirmCartByMerchantId();
    }
  }

  Future<void> fetchConfirmCartByCartId() async {
    confirmCartResponse = await FetchController(
      endpoint: 'carts/confirm?cartId=${widget.cartId}',
      fromJson: (json) => ConfirmCartResponse.fromJson(json),
    ).getData();

    setState(() {
      dataConfirmCart = confirmCartResponse?.data;
    });
  }

  Future<void> fetchConfirmCartByMerchantId() async {
    confirmCartResponse = await FetchController(
      endpoint:
          'carts/confirm-merchant?userId=${AppConfig.USER_ID}&merchantId=${widget.merchantId}',
      fromJson: (json) => ConfirmCartResponse.fromJson(json),
    ).getData();

    setState(() {
      dataConfirmCart = confirmCartResponse?.data;
    });
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 10));

    print('reload...');
  }

  int calculateSubtotalCost(Map<String, dynamic> orderData) {
    List<dynamic> menuItems = orderData['menu'];
    int totalPrice = 0;

    for (var item in menuItems) {
      int price = item['price'];
      int count = item['count'];
      totalPrice += price * count;
    }

    return totalPrice;
  }

  int calculateTotalMenuItems(Map<String, dynamic> orderData) {
    List<dynamic> menuItems = orderData['menu'];
    int totalItems = 0;

    for (var item in menuItems) {
      int count = item['count'];
      totalItems += count;
    }

    return totalItems;
  }

  int calculateTotalCost({int? subtotal, int? shipping, int? service}) {
    int totalCost = subtotal! + shipping! + service!;

    return totalCost;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: backButtonCustom(context: context),
        title: const Text(
          'Detail Pesanan',
          style: AppTextStyles.title,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: dataConfirmCart == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    currentStatus == 'pesanan dibuat'
                        ? const Center(
                            child: Text(
                              'Menunggu Konfirmasi',
                              style: AppTextStyles.subTitle,
                            ),
                          )
                        : currentStatus == 'pesanan dikonfirmasi'
                            ? const Center(
                                child: Text(
                                  'Pesanan Dikonfirmasi',
                                  style: AppTextStyles.subTitle,
                                ),
                              )
                            : currentStatus == 'pesanan sudah sampai'
                                ? const Center(
                                    child: Text(
                                      'Pesanan Sudah Sampai',
                                      style: AppTextStyles.subTitle,
                                    ),
                                  )
                                : Container(),
                    currentStatus == 'Belum Bayar'
                        ? Container(
                            height: 50,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            child: DynamicColorButton(
                              onPressed: () {},
                              text: 'Batalkan Pesanan',
                              backgroundColor: Warna.like,
                              borderRadius: 54,
                            ),
                          )
                        : currentStatus == 'selesai'
                            ? Container(
                                height: 50,
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: DynamicColorButton(
                                  onPressed: () {},
                                  text: 'Konfirmasi Telah Diterima',
                                  backgroundColor: Warna.kuning,
                                  borderRadius: 54,
                                ),
                              )
                            : currentStatus == 'pesanan dibuat'
                                ? Container(
                                    height: 50,
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: DynamicColorButton(
                                      onPressed: () {},
                                      text: 'Batalkan Pesanan',
                                      backgroundColor: Warna.like,
                                      borderRadius: 54,
                                    ),
                                  )
                                : currentStatus == 'pesanan dikonfirmasi'
                                    ? Container(
                                        height: 50,
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Text(
                                          'Buat kesepakatan dengan penjual dan tunggu pesananmu diantarakan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Warna.abu4,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ))
                                    : currentStatus == 'pesanan sudah sampai'
                                        ? Container(
                                            height: 50,
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: DynamicColorButton(
                                              onPressed: () {},
                                              text: 'Konfirmasi Sudah Diterima',
                                              backgroundColor: Warna.hijau,
                                              borderRadius: 54,
                                            ),
                                          )
                                        : Container(),
                    // Container(
                    //   height: 130,
                    //   margin: const EdgeInsets.symmetric(vertical: 10),
                    //   child: StatusOrderTimeLineTileWidget(
                    //     processIndex: 0,
                    //     status: '',
                    //     statusListMapData: orderStatusProses,
                    //   ),
                    // ),

                    Divider(
                      height: 10,
                      thickness: 1.5,
                      color: Warna.abu,
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: false,
                       leading: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          child:
                              dataConfirmCart?.userInformation.userPhoto == null
                                  ?  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Warna.abu,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Icon(Icons.person))
                                  : Image.network(
                                      "${AppConfig.URL_IMAGES_PATH}${dataConfirmCart!.userInformation.userPhoto}",
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                    ),
                        ),
                        title: Text(
                          dataConfirmCart!.userInformation.userName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: dataConfirmCart!.userInformation.studentInformation == null ? null : Text(
                          dataConfirmCart!.userInformation.studentInformation!
                              .studyProgramInformation.studyProgramName,
                          style: TextStyle(
                            fontSize: 13,
                            color: Warna.abu4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ),
                    Divider(
                      height: 10,
                      thickness: 1.5,
                      color: Warna.abu,
                    ),
                    // orderItemBox(),
                    orderItemBox(),

                    orderCalculateCostBox(),

                    boxOrderInfoDetail(),

                    // Container(
                    //   height: 50,
                    //   width: double.infinity,
                    //   margin: const EdgeInsets.symmetric(vertical: 10),
                    //   child: DynamicColorButton(
                    //     onPressed: () {
                    //       navigateTo(context, const OrderConfirmScreen());
                    //     },
                    //     text: 'Bayar',
                    //     backgroundColor: Warna.kuning,
                    //     borderRadius: 54,
                    //   ),
                    // ),
                    // currentStatus == 'pesanan dibuat' ?
                    Container(
                      height: 50,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: DynamicColorButton(
                        onPressed: () {
                          navigateTo(
                            context,
                            ChatScreen(
                              isMerchant: true,
                              merchantId: 1,
                              userId: 1,
                            ),
                          );
                        },
                        icon: Icon(
                          UIcons.solidRounded.comment,
                          color: Colors.white,
                        ),
                        text: 'Chat Penjual',
                        backgroundColor: Warna.kuning,
                        borderRadius: 54,
                      ),
                    ),

                    currentStatus == 'pesanan sudah sampai'
                        ? Container(
                            height: 50,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: DynamicColorButton(
                              onPressed: () {
                                navigateTo(context, const RateScreen());
                              },
                              text: 'Beri Penilaian',
                              backgroundColor: Warna.kuning,
                              borderRadius: 54,
                            ),
                          )
                        : Container(),

                    // Container(
                    //   height: 50,
                    //   width: double.infinity,
                    //   margin: const EdgeInsets.symmetric(vertical: 10),
                    //   child: DynamicColorButton(
                    //     onPressed: () {},
                    //     text: 'Ubah Metode Pembayaran',
                    //     backgroundColor: Warna.biru,
                    //     borderRadius: 54,
                    //   ),
                    // ),
                    const SizedBox(
                      height: 15,
                    ),

                    // SizedBox(height: 100,),
                  ],
                ),
              ),
      ),
    );
  }

  Widget orderItemBox({
    // String? imgUrl,
    int storeListIndex = 0,
    Map<String, dynamic>? storeItem,
    List<Map<String, dynamic>>? menuItems,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Warna.abu,
            width: 1.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                dataConfirmCart!
                            .cartInformation.merchantInformation.merchantType ==
                        "WIRAUSAHA"
                    ? CommunityMaterialIcons.handshake
                    : Icons.store,
                color: dataConfirmCart!
                            .cartInformation.merchantInformation.merchantType ==
                        "WIRAUSAHA"
                    ? Warna.kuning
                    : Warna.biru,
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                dataConfirmCart!
                    .cartInformation.merchantInformation.merchantName,
                // 'nama toko',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
            ],
          ),
          ListView.builder(
            itemCount:
                dataConfirmCart!.cartInformation.cartItemInformations.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, menuIdx) {
              var item = dataConfirmCart!
                  .cartInformation.cartItemInformations[menuIdx];
              return Container(
                // height: 100,
                // padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: menuIdx ==
                            dataConfirmCart!.cartInformation
                                    .cartItemInformations.length -
                                1
                        ? const BorderSide(
                            color: Colors.transparent, width: 1.5)
                        : BorderSide(color: Warna.abu, width: 1.5),
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
                      child: item.menuInformation.menuPhoto == null
                          ? const Center(
                              child: Icon(Icons.image),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "${AppConfig.URL_IMAGES_PATH}${item.menuInformation.menuPhoto}",
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
                              )),
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            item.menuInformation.menuName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${item.quantity}x',
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
                        Text(item.cartVariantInformations.isEmpty
                            ? ''
                            : getVariantDescription(
                                item.cartVariantInformations)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              Constant.currencyCode +
                                  formatNumberWithThousandsSeparator(
                                      item.totalPriceItem),
                              style: AppTextStyles.productPrice,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          //
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Subtotal ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Warna.regulerFontColor,
                ),
              ),
              Text(
                  "(${dataConfirmCart!.cartInformation.totalMenu} Menu | ${dataConfirmCart!.cartInformation.totalItem} Item)",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Warna.regulerFontColor)),
              const Spacer(),
              Text(
                Constant.currencyCode +
                    formatNumberWithThousandsSeparator(
                        dataConfirmCart!.cartInformation.subTotalPrice),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Warna.biru,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget orderCalculateCostBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Warna.abu,
            width: 1.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          dataConfirmCart!.cartInformation.merchantInformation.merchantType ==
                  "KANTIN"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Biaya Pengiriman',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Warna.regulerFontColor,
                      ),
                    ),
                    Text(
                      "${Constant.currencyCode}${formatNumberWithThousandsSeparator(5000)}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Warna.biru,
                      ),
                    )
                  ],
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Biaya Layanan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Warna.regulerFontColor,
                ),
              ),
              Text(
                "${Constant.currencyCode}${formatNumberWithThousandsSeparator(dataConfirmCart!.serviceCost)}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Warna.biru,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Total ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Warna.regulerFontColor,
                ),
              ),
              const Spacer(),
              Text(
                Constant.currencyCode +
                    formatNumberWithThousandsSeparator(
                        dataConfirmCart!.totalPrice),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Warna.biru,
                ),
              )
            ],
          )
        ],
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
              Text(
                widget.noteOrder != '' ? widget.noteOrder : 'Tidak ada',
                style: const TextStyle(
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
                  Text(
                    widget.orderNumber != '' ? widget.orderNumber : '768768976897678709',
                    style: const TextStyle(
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
              Text(
                widget.orderTime != '' ? widget.orderTime : 'date mounth year, time',
                style: const TextStyle(
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
              Text(
                widget.paymentMethod != '' ? widget.paymentMethod : 'cash',
                style: const TextStyle(
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
