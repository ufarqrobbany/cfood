import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/order_status_timeline_tile.dart';
import 'package:cfood/screens/chat.dart';
import 'package:cfood/screens/order_confirm.dart';
import 'package:cfood/screens/rate_screen.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class OrderDetailScreen extends StatefulWidget {
  final String? status;
  const OrderDetailScreen({super.key, this.status});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.status == 'Belum Bayar'
                  ? const Center(
                      child: Text(
                        'Menunggu Pembayaran',
                        style: AppTextStyles.subTitle,
                      ),
                    )
                  : Container(),
              widget.status == 'Belum Bayar'
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
                  : widget.status == 'selesai' ? Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: DynamicColorButton(
                  onPressed: () {},
                  text: 'Konfirmasi Telah Diterima',
                  backgroundColor: Warna.kuning,
                  borderRadius: 54,
                ),
              ) :Container(),
              Container(
                height: 130,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: StatusOrderTimeLineTileWidget(
                  processIndex: 0,
                  status: '',
                  statusListMapData: orderStatusProses,
                ),
              ),
              ListTile(
                shape: Border(
                  bottom: BorderSide(color: Warna.abu, width: 1.5),
                  top: BorderSide(color: Warna.abu, width: 1.5),
                ),
                dense: false,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 15,
                ),
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Warna.abu,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image.network(
                    '/.jpg',
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Warna.abu,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      );
                    },
                  ),
                ),
                title: Text(
                  driverInfo['name'].toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      driverInfo['rate'].toString(),
                    )
                  ],
                ),
                trailing: notifIconButton(
                  notifCount: driverInfo['notification'].toString(),
                  onPressed: () {},
                  icons: UIcons.regularRounded.comment,
                  iconColor: Warna.regulerFontColor,
                ),
              ),
              orderItemBox(
                storeListIndex: 0,
                storeItem: orderStatusInfoData,
                menuItems: orderStatusInfoData['menu'],
              ),

              orderCalculateCostBox(),

              boxOrderInfoDetail(),

              Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: DynamicColorButton(
                  onPressed: () {
                    navigateTo(context, const OrderConfirmScreen());
                  },
                  text: 'Bayar',
                  backgroundColor: Warna.kuning,
                  borderRadius: 54,
                ),
              ),

              Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: DynamicColorButton(
                  onPressed: () {
                    navigateTo(context, ChatScreen(isMerchant: true, merchantId: 1, userId: 1,),);
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

              Container(
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
              ),

              Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: DynamicColorButton(
                  onPressed: () {},
                  text: 'Ubah Metode Pembayaran',
                  backgroundColor: Warna.biru,
                  borderRadius: 54,
                ),
              ),
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
    int subTotalPrice = calculateSubtotalCost(storeItem!);
    int itemCount = calculateTotalMenuItems(storeItem);
    int totalCost = calculateTotalCost(
      subtotal: subTotalPrice,
      shipping: 5000,
      service: 1000,
    );
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
                Icons.store,
                color: Warna.biru,
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                storeItem['store'].toString(),
                // 'nama toko',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                height: 20,
                width: 20,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Warna.regulerFontColor,
                    size: 15,
                  ),
                ),
              )
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
                        status: storeItem['status'],
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
          //
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text(
                'Subtotal ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text("(${menuItems?.length} Menu | $itemCount Item)"),
              const Spacer(),
              Text(
                Constant.currencyCode + subTotalPrice.toString(),
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
    int subTotalPrice = calculateSubtotalCost(orderStatusInfoData);
    int totalCost = calculateTotalCost(
      subtotal: subTotalPrice,
      shipping: 5000,
      service: 1000,
    );
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
                "${Constant.currencyCode}5000",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Warna.biru,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Biaya Layanan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Warna.regulerFontColor,
                ),
              ),
              Text(
                "${Constant.currencyCode}1000",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
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
              const Text(
                'Total ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                Constant.currencyCode + totalCost.toString(),
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
