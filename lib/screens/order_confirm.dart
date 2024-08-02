import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/screens/order_detail.dart';
import 'package:cfood/screens/payment_method.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';

class OrderConfirmScreen extends StatefulWidget {
  const OrderConfirmScreen({super.key});

  @override
  State<OrderConfirmScreen> createState() => _OrderConfirmScreenState();
}

class _OrderConfirmScreenState extends State<OrderConfirmScreen> {
  TextEditingController noteController = TextEditingController();
  bool buttonLoad = false;
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
        leading: backButtonCustom(context: context),
        leadingWidth: 90,
        title: Text(
          'Konfirmasi Pesanan',
          style: AppTextStyles.appBarTitle,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ReloadIndicatorType1(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.max,
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
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Warna.abu,
                        ),
                      ),
                    ),
                  ),
                  title: const Text(
                    'Penjual [Username Penjual]',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'D4 Teknik Informatika',
                    style: TextStyle(
                      fontSize: 13,
                      color: Warna.abu4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Divider(
                  height: 10,
                  thickness: 1,
                  color: Warna.abu2,
                ),
                orderItemBox(
                  storeListIndex: 0,
                  storeItem: orderStatusInfoData,
                  menuItems: orderStatusInfoData['menu'],
                ),
                orderCalculateCostBox(),

                const SizedBox(
                  height: 20,
                ),

                CTextField(
                  controller: noteController,
                  labelText: 'Catatan',
                  borderRadius: 10,
                ),

                const SizedBox(
                  height: 20,
                ),

                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: CBlueButton(
                    isLoading: buttonLoad,
                    borderRadius: 60,
                    onPressed: () {
                      navigateTo(context, const PaymentMethodScreen());
                    }, text: 'Pilih Metode Pembayaran'),
                )
              ],
            ),
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
                padding: const EdgeInsets.all(5),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30), color: Warna.abu,),
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
}
