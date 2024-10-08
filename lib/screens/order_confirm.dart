import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/create_order_response.dart';
import 'package:cfood/model/reponse_handler.dart';
import 'package:cfood/model/voucher_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/order_detail.dart';
import 'package:cfood/model/confirm_cart_response.dart';
import 'package:cfood/screens/payment_method.dart';
import 'package:cfood/screens/voucher_detail.dart';
import 'package:cfood/screens/vouchers.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/common.dart';
import 'package:cfood/utils/constant.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uicons/uicons.dart';

String getVariantDescription(List<dynamic> variants) {
  if (variants.isEmpty) {
    return '';
  }

  List<String> variantOptionNames = [];

  for (var variant in variants) {
    for (var option in variant.variantOptionInformations) {
      variantOptionNames.add(option.variantOptionName);
    }
  }

  return variantOptionNames.join(", ");
}

class OrderConfirmScreen extends StatefulWidget {
  final int? merchantId;
  final int? cartId;

  const OrderConfirmScreen({super.key, this.merchantId, this.cartId});

  @override
  State<OrderConfirmScreen> createState() => _OrderConfirmScreenState();
}

class _OrderConfirmScreenState extends State<OrderConfirmScreen> {
  TextEditingController noteController = TextEditingController();
  bool buttonLoad = false;

  ConfirmCartResponse? confirmCartResponse;
  CreateOrderResponse? createOrderResponse;
  DataConfirmCart? dataConfirmCart;
  String selectedPaymentMethod = '';
  String selectedPaymentMethodName = '';
  Voucher? selectedVoucher;
  int totalCostBefore = 0;

  @override
  void initState() {
    super.initState();
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

  Future<void> createOrder(BuildContext context) async {
    String orderStatus = '';
    if (selectedPaymentMethod == '') {
      showToast('Pilih Metode Pembayaran');
      return;
    }

    if (selectedPaymentMethod == 'cash') {
      setState(() {
        orderStatus = 'MENUNGGU_KONFIRM_PENJUAL';
      });
    } else {
      setState(() {
        orderStatus = 'BELUM_DIBAYAR';
      });
    }
    setState(() {
      buttonLoad = true;
    });
    try {
      createOrderResponse = await FetchController(
        endpoint: 'orders/',
        fromJson: (json) => CreateOrderResponse.fromJson(json),
      ).postData({
        'cartId': dataConfirmCart!.cartInformation.cartId,
        'voucherId': selectedVoucher?.voucherId,
        'paymentMethod': selectedPaymentMethod,
        'orderStatus': orderStatus,
        'note': noteController.text,
      });
      log(createOrderResponse.toString());
      if (createOrderResponse!.statusCode == 200) {
        log('create order');
        var currentTime = getCurrentDateTime();
        log(currentTime);
        setState(() {
          buttonLoad = false;
        });
        log('go to detail');
        navigateTo(
          context,
          OrderDetailScreen(
            cartId: widget.cartId,
            merchantId: widget.merchantId,
            noteOrder: noteController.text,
            orderNumber: '65987879867576',
            orderTime: currentTime.toString(),
            paymentMethod: selectedPaymentMethod,
            dataOrder: createOrderResponse?.data,
            status:
                'pesanan dibuat', // pesanan dibuat, pesanan dikonfirmasi, pesanan sudah sampai
          ),
        );
      }
    } on Exception catch (e) {
      setState(() {
        buttonLoad = false;
      });
      showToast('Gagal Membuat Pesanan ERROR: $e');
    }
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 10));
    // fetchConfirmOrder();
    print('reload...');
    fetchData();
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

  void calculateCost() {
    if (totalCostBefore == 0) {
      setState(() {
        totalCostBefore = dataConfirmCart!.totalPrice;
      });
      if (selectedVoucher!.voucherPriceType == 'PERCENT') {
        // Hitung diskon berbasis persentase
        final discount =
            (dataConfirmCart!.totalPrice * selectedVoucher!.voucherPrice) / 100;

        // Kurangi total price dengan diskon, pastikan konversi ke int jika totalPrice adalah int
        dataConfirmCart!.totalPrice =
            (dataConfirmCart!.totalPrice - discount).toInt();

        // Debug print untuk memastikan diskon sudah benar
        log('Diskon PERCENT: $discount');
        log('Total Price setelah diskon: ${dataConfirmCart!.totalPrice}');
      } else if (selectedVoucher!.voucherPriceType == 'FLAT') {
        setState(() {
          dataConfirmCart!.totalPrice -= selectedVoucher!.voucherPrice;
        });
      }
    } else {
      setState(() {
        dataConfirmCart!.totalPrice = totalCostBefore;
      });
    }
  }

  String getCurrentDateTime() {
    // Mendapatkan waktu sekarang
    DateTime now = DateTime.now();

    // Format tanggal
    String day = DateFormat('d').format(now);
    String month = DateFormat('MMMM', 'id_ID').format(now);
    String year = DateFormat('y').format(now);

    // Format waktu
    String hour = DateFormat('H').format(now);
    String minute = (now.minute / 10).toStringAsFixed(1);

    // Menggabungkan hasil format
    return '$day $month $year, $hour.$minute';
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
        child: dataConfirmCart == null
            ? Container()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: false,
                        leading: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          child:
                              dataConfirmCart?.userInformation.userPhoto == null
                                  ? Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Warna.abu,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: const Icon(Icons.person))
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
                        subtitle: dataConfirmCart!
                                    .userInformation.studentInformation ==
                                null
                            ? null
                            : Text(
                                dataConfirmCart!
                                    .userInformation
                                    .studentInformation!
                                    .studyProgramInformation
                                    .studyProgramName,
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
                      orderItemBox(),
                      orderCalculateCostBox(),
                      const SizedBox(
                        height: 20,
                      ),
                      voucherBox(),
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
                      selectedPaymentMethod == ''
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Metode Pembayaran',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Warna.regulerFontColor,
                                  ),
                                ),
                                Text(
                                  selectedPaymentMethodName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Warna.biru,
                                  ),
                                )
                              ],
                            ),
                      selectedPaymentMethod == ''
                          ? Container()
                          : const SizedBox(
                              height: 20,
                            ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: CBlueButton(
                            // isLoading: buttonLoad,
                            borderRadius: 60,
                            onPressed: buttonLoad ? () {} : () {
                              navigateTo(context, const PaymentMethodScreen())
                                  .then((value) {
                                setState(() {
                                  selectedPaymentMethodName = value['name'];
                                  selectedPaymentMethod = value['code'];
                                  log('payement method : $selectedPaymentMethod');
                                });
                              });
                            },
                            text: selectedPaymentMethod != ''
                                ? 'Ubah Metode Pembayaran'
                                : 'Pilih Metode Pembayaran'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      selectedPaymentMethod == ''
                          ? Container()
                          : SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: CBlueButton(
                                onPressed: () {
                                  createOrder(context);
                                  // navigateTo(
                                  //   context,
                                  //   OrderDetailScreen(
                                  //     cartId: widget.cartId,
                                  //     merchantId: widget.merchantId,
                                  //     noteOrder: noteController.text,
                                  //     orderNumber: '65987879867576',
                                  //     orderTime: currentTime.toString(),
                                  //     paymentMethod: selectedPaymentMethod,
                                  //     status:
                                  //         'pesanan dibuat', // pesanan dibuat, pesanan dikonfirmasi, pesanan sudah sampai
                                  //   ),
                                  // );
                                },
                                isLoading: buttonLoad,
                                borderRadius: 60,
                                text: 'Buat Pesanan',
                                backgroundColor: Warna.kuning,
                              ),
                            ),
                      const SizedBox(
                        height: 40,
                      ),
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
          selectedVoucher != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Voucher Diskon',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Warna.regulerFontColor,
                      ),
                    ),
                    selectedVoucher!.voucherPriceType == 'PERCENT'
                        ? Text(
                            "-${Constant.currencyCode}${formatNumberWithThousandsSeparator((dataConfirmCart!.cartInformation.subTotalPrice * (selectedVoucher!.voucherPrice / 100)).toInt())}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Warna.biru,
                            ),
                          )
                        : Text(
                            "-${Constant.currencyCode}${formatNumberWithThousandsSeparator(selectedVoucher!.voucherPrice)}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Warna.biru,
                            ),
                          )
                  ],
                )
              : Container(),
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
                    formatNumberWithThousandsSeparator(selectedVoucher != null
                        ? selectedVoucher!.voucherPriceType == 'PERCENT'
                            ? (dataConfirmCart!.cartInformation.subTotalPrice -
                                    (dataConfirmCart!
                                            .cartInformation.subTotalPrice *
                                        (selectedVoucher!.voucherPrice / 100)))
                                .toInt()
                            : dataConfirmCart!.cartInformation.subTotalPrice -
                                selectedVoucher!.voucherPrice
                        : dataConfirmCart!.totalPrice),
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

  Widget voucherBox() {
    return ListTile(
      leading: Icon(
        Icons.confirmation_number_outlined,
        color: selectedVoucher != null ? Warna.kuning : Warna.biru,
        size: 28,
      ),
      title: Text(
        selectedVoucher != null
            ? selectedVoucher!.voucherName
            : 'Voucher tidak terpasang',
      ),
      titleTextStyle: TextStyle(
        color: selectedVoucher != null ? Colors.white : Warna.biru,
        fontWeight: FontWeight.w400,
      ),
      trailing: selectedVoucher != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 74,
                  height: 35,
                  child: CBlueButton(
                    onPressed: () {
                      // navigateTo(context, VoucherDetail());
                      navigateTo(
                          context,
                          VouchersScreen(
                            totalPurchasePrice:
                                dataConfirmCart!.totalPrice.toString(),
                          )).then((value) {
                        setState(() {
                          selectedVoucher = value;
                        });
                        calculateCost();
                        log('voucher selected : ${selectedVoucher!.voucherId}');
                      });
                    },
                    text: 'Ganti',
                    borderRadius: 5,
                    fontSize: 13,
                    textColor: Warna.biru,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.all(5),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  height: 35,
                  width: 35,
                  child: IconButton(
                    onPressed: () {
                      // navigateTo(context, VoucherDetail());
                      setState(() {
                        selectedVoucher = null;
                      });
                      calculateCost();
                    },
                    icon: Icon(
                      UIcons.solidRounded.trash,
                      color: Colors.white,
                      size: 15,
                    ),
                    padding: const EdgeInsets.all(0),
                    style: IconButton.styleFrom(
                        backgroundColor: Warna.like,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        )),
                  ),
                ),
              ],
            )
          : SizedBox(
              width: 74,
              height: 35,
              child: CBlueButton(
                onPressed: () {
                  // navigateTo(context, VoucherDetail());
                  navigateTo(
                      context,
                      VouchersScreen(
                        totalPurchasePrice:
                            dataConfirmCart!.totalPrice.toString(),
                      )).then((value) {
                    setState(() {
                      selectedVoucher = value;
                    });
                    calculateCost();
                    log('voucher selected : ${selectedVoucher!.voucherId}');
                  });
                },
                text: 'Pilih',
                borderRadius: 5,
                fontSize: 13,
                padding: EdgeInsets.all(5),
              ),
            ),
      enabled: true,
      tileColor: selectedVoucher != null ? Warna.biru : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Warna.abu3, width: 1.5),
      ),
    );
  }
}
// =======
// import 'dart:developer';

// import 'package:cfood/custom/CButtons.dart';
// import 'package:cfood/custom/CPageMover.dart';
// import 'package:cfood/custom/CTextField.dart';
// import 'package:cfood/custom/page_item_void.dart';
// import 'package:cfood/custom/reload_indicator.dart';
// import 'package:cfood/repository/fetch_controller.dart';
// import 'package:cfood/screens/order_detail.dart';
// import 'package:cfood/model/confirm_cart_response.dart';
// import 'package:cfood/screens/payment_method.dart';
// import 'package:cfood/style.dart';
// import 'package:cfood/utils/common.dart';
// import 'package:cfood/utils/constant.dart';
// import 'package:community_material_icon/community_material_icon.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// String getVariantDescription(List<dynamic> variants) {
//   if (variants.isEmpty) {
//     return '';
//   }

//   List<String> variantOptionNames = [];

//   for (var variant in variants) {
//     for (var option in variant.variantOptionInformations) {
//       variantOptionNames.add(option.variantOptionName);
//     }
//   }

//   return variantOptionNames.join(", ");
// }

// class OrderConfirmScreen extends StatefulWidget {
//   final int? merchantId;
//   final int? cartId;

//   const OrderConfirmScreen({super.key, this.merchantId, this.cartId});

//   @override
//   State<OrderConfirmScreen> createState() => _OrderConfirmScreenState();
// }

// class _OrderConfirmScreenState extends State<OrderConfirmScreen> {
//   TextEditingController noteController = TextEditingController();
//   bool buttonLoad = false;

//   ConfirmCartResponse? confirmCartResponse;
//   DataConfirmCart? dataConfirmCart;
//   String selectedPaymentMethod = '';
//   String selectedPaymentMethodName = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     if (widget.cartId != null) {
//       fetchConfirmCartByCartId();
//     } else {
//       fetchConfirmCartByMerchantId();
//     }
//   }

//   Future<void> fetchConfirmCartByCartId() async {
//     confirmCartResponse = await FetchController(
//       endpoint: 'carts/confirm?cartId=${widget.cartId}',
//       fromJson: (json) => ConfirmCartResponse.fromJson(json),
//     ).getData();

//     setState(() {
//       dataConfirmCart = confirmCartResponse?.data;
//     });
//   }

//   Future<void> fetchConfirmCartByMerchantId() async {
//     confirmCartResponse = await FetchController(
//       endpoint:
//           'carts/confirm-merchant?userId=${AppConfig.USER_ID}&merchantId=${widget.merchantId}',
//       fromJson: (json) => ConfirmCartResponse.fromJson(json),
//     ).getData();

//     setState(() {
//       dataConfirmCart = confirmCartResponse?.data;
//     });
//   }

//   Future<void> refreshPage() async {
//     await Future.delayed(const Duration(seconds: 10));
//     // fetchConfirmOrder();
//     print('reload...');
//     fetchData();
//   }

//   int calculateSubtotalCost(Map<String, dynamic> orderData) {
//     List<dynamic> menuItems = orderData['menu'];
//     int totalPrice = 0;

//     for (var item in menuItems) {
//       int price = item['price'];
//       int count = item['count'];
//       totalPrice += price * count;
//     }

//     return totalPrice;
//   }

//   int calculateTotalMenuItems(Map<String, dynamic> orderData) {
//     List<dynamic> menuItems = orderData['menu'];
//     int totalItems = 0;

//     for (var item in menuItems) {
//       int count = item['count'];
//       totalItems += count;
//     }

//     return totalItems;
//   }

//   int calculateTotalCost({int? subtotal, int? shipping, int? service}) {
//     int totalCost = subtotal! + shipping! + service!;

//     return totalCost;
//   }

//   String getCurrentDateTime() {
//     // Mendapatkan waktu sekarang
//     DateTime now = DateTime.now();

//     // Format tanggal
//     String day = DateFormat('d').format(now);
//     String month = DateFormat('MMMM', 'id_ID').format(now);
//     String year = DateFormat('y').format(now);

//     // Format waktu
//     String hour = DateFormat('H').format(now);
//     String minute = (now.minute / 10).toStringAsFixed(1);

//     // Menggabungkan hasil format
//     return '$day $month $year, $hour.$minute';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: backButtonCustom(context: context),
//         leadingWidth: 90,
//         title: Text(
//           'Konfirmasi Pesanan',
//           style: AppTextStyles.appBarTitle,
//         ),
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.white,
//         scrolledUnderElevation: 0,
//       ),
//       backgroundColor: Colors.white,
//       body: ReloadIndicatorType1(
//         onRefresh: refreshPage,
//         child: dataConfirmCart == null
//             ? Container()
//             : SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       ListTile(
//                         contentPadding: EdgeInsets.zero,
//                         dense: false,
//                         leading: ClipRRect(
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(100)),
//                           child:
//                               dataConfirmCart?.userInformation.userPhoto == null
//                                   ? Container(
//                                       height: 40,
//                                       width: 40,
//                                       decoration: BoxDecoration(
//                                         color: Warna.abu,
//                                         borderRadius: BorderRadius.circular(50),
//                                       ),
//                                       child: Icon(Icons.person))
//                                   : Image.network(
//                                       "${AppConfig.URL_IMAGES_PATH}${dataConfirmCart!.userInformation.userPhoto}",
//                                       fit: BoxFit.cover,
//                                       width: 40,
//                                       height: 40,
//                                     ),
//                         ),
//                         title: Text(
//                           dataConfirmCart!.userInformation.userName,
//                           style: const TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         subtitle: dataConfirmCart!
//                                     .userInformation.studentInformation ==
//                                 null
//                             ? null
//                             : Text(
//                                 dataConfirmCart!
//                                     .userInformation
//                                     .studentInformation!
//                                     .studyProgramInformation
//                                     .studyProgramName,
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   color: Warna.abu4,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                       ),
//                       Divider(
//                         height: 10,
//                         thickness: 1.5,
//                         color: Warna.abu,
//                       ),
//                       orderItemBox(),
//                       orderCalculateCostBox(),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       CTextField(
//                         controller: noteController,
//                         labelText: 'Catatan',
//                         borderRadius: 10,
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       selectedPaymentMethod == '' ? Container() :
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Metode Pembayaran',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.normal,
//                               color: Warna.regulerFontColor,
//                             ),
//                           ),
//                           Text(
//                             selectedPaymentMethodName,
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.normal,
//                               color: Warna.biru,
//                             ),
//                           )
//                         ],
//                       ),
//                       selectedPaymentMethod == '' ? Container() :
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       SizedBox(
//                         height: 50,
//                         width: double.infinity,
//                         child: CBlueButton(
//                             isLoading: buttonLoad,
//                             borderRadius: 60,
//                             onPressed: () {
//                               navigateTo(context, const PaymentMethodScreen())
//                                   .then((value) {
//                                 setState(() {
//                                   selectedPaymentMethodName = value['name'];
//                                   selectedPaymentMethod = value['code'];
//                                   log('payement method : $selectedPaymentMethod');
//                                 });
//                               });
//                             },
//                             text: selectedPaymentMethod != ''
//                                 ? 'Ubah Metode Pembayaran'
//                                 : 'Pilih Metode Pembayaran'),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       selectedPaymentMethod == ''
//                           ? Container()
//                           : SizedBox(
//                               height: 50,
//                               width: double.infinity,
//                               child: CBlueButton(
//                                 onPressed: () {
//                                   log('create order');
//                                   var currentTime = getCurrentDateTime();
//                                   log(currentTime);
//                                   navigateTo(
//                                     context,
//                                     OrderDetailScreen(
//                                       cartId: widget.cartId,
//                                       merchantId: widget.merchantId,
//                                       noteOrder: noteController.text,
//                                       orderNumber: '65987879867576',
//                                       orderTime: currentTime.toString(),
//                                       paymentMethod: selectedPaymentMethod,
//                                       status:
//                                           'pesanan dibuat', // pesanan dibuat, pesanan dikonfirmasi, pesanan sudah sampai
//                                     ),
//                                   );
//                                 },
//                                 isLoading: buttonLoad,
//                                 borderRadius: 60,
//                                 text: 'Buat Pesanan',
//                                 backgroundColor: Warna.kuning,
//                               ),
//                             ),
//                       const SizedBox(
//                         height: 40,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget orderItemBox({
//     // String? imgUrl,
//     int storeListIndex = 0,
//     Map<String, dynamic>? storeItem,
//     List<Map<String, dynamic>>? menuItems,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       decoration: BoxDecoration(
//         // borderRadius: BorderRadius.circular(8),
//         color: Colors.white,
//         border: Border(
//           bottom: BorderSide(
//             color: Warna.abu,
//             width: 1.5,
//           ),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Icon(
//                 dataConfirmCart!
//                             .cartInformation.merchantInformation.merchantType ==
//                         "WIRAUSAHA"
//                     ? CommunityMaterialIcons.handshake
//                     : Icons.store,
//                 color: dataConfirmCart!
//                             .cartInformation.merchantInformation.merchantType ==
//                         "WIRAUSAHA"
//                     ? Warna.kuning
//                     : Warna.biru,
//                 size: 20,
//               ),
//               const SizedBox(
//                 width: 5,
//               ),
//               Text(
//                 dataConfirmCart!
//                     .cartInformation.merchantInformation.merchantName,
//                 // 'nama toko',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const Spacer(),
//             ],
//           ),
//           ListView.builder(
//             itemCount:
//                 dataConfirmCart!.cartInformation.cartItemInformations.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, menuIdx) {
//               var item = dataConfirmCart!
//                   .cartInformation.cartItemInformations[menuIdx];
//               return Container(
//                 // height: 100,
//                 // padding: const EdgeInsets.symmetric(vertical: 20),
//                 decoration: BoxDecoration(
//                   border: Border(
//                     bottom: menuIdx ==
//                             dataConfirmCart!.cartInformation
//                                     .cartItemInformations.length -
//                                 1
//                         ? const BorderSide(
//                             color: Colors.transparent, width: 1.5)
//                         : BorderSide(color: Warna.abu, width: 1.5),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   child: ListTile(
//                     contentPadding: EdgeInsets.zero,
//                     dense: false,
//                     leading: Container(
//                       width: 60,
//                       height: 60,
//                       decoration: BoxDecoration(
//                         color: Warna.abu,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: item.menuInformation.menuPhoto == null
//                           ? const Center(
//                               child: Icon(Icons.image),
//                             )
//                           : ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.network(
//                                 "${AppConfig.URL_IMAGES_PATH}${item.menuInformation.menuPhoto}",
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Container(
//                                     width: 60,
//                                     height: 60,
//                                     decoration: BoxDecoration(
//                                       color: Warna.abu,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   );
//                                 },
//                               )),
//                     ),
//                     title: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Flexible(
//                           child: Text(
//                             item.menuInformation.menuName,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Text(
//                           '${item.quantity}x',
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         )
//                       ],
//                     ),
//                     subtitle: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(item.cartVariantInformations.isEmpty
//                             ? ''
//                             : getVariantDescription(
//                                 item.cartVariantInformations)),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Text(
//                               Constant.currencyCode +
//                                   formatNumberWithThousandsSeparator(
//                                       item.totalPriceItem),
//                               style: AppTextStyles.productPrice,
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//           //
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Text(
//                 'Subtotal ',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: Warna.regulerFontColor,
//                 ),
//               ),
//               Text(
//                   "(${dataConfirmCart!.cartInformation.totalMenu} Menu | ${dataConfirmCart!.cartInformation.totalItem} Item)",
//                   style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.normal,
//                       color: Warna.regulerFontColor)),
//               const Spacer(),
//               Text(
//                 Constant.currencyCode +
//                     formatNumberWithThousandsSeparator(
//                         dataConfirmCart!.cartInformation.subTotalPrice),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Warna.biru,
//                 ),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget orderCalculateCostBox() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       decoration: BoxDecoration(
//         // borderRadius: BorderRadius.circular(8),
//         color: Colors.white,
//         border: Border(
//           bottom: BorderSide(
//             color: Warna.abu,
//             width: 1.5,
//           ),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           dataConfirmCart!.cartInformation.merchantInformation.merchantType ==
//                   "KANTIN"
//               ? Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Biaya Pengiriman',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Warna.regulerFontColor,
//                       ),
//                     ),
//                     Text(
//                       "${Constant.currencyCode}${formatNumberWithThousandsSeparator(5000)}",
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                         color: Warna.biru,
//                       ),
//                     )
//                   ],
//                 )
//               : Container(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Biaya Layanan',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.normal,
//                   color: Warna.regulerFontColor,
//                 ),
//               ),
//               Text(
//                 "${Constant.currencyCode}${formatNumberWithThousandsSeparator(dataConfirmCart!.serviceCost)}",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.normal,
//                   color: Warna.biru,
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Text(
//                 'Total ',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: Warna.regulerFontColor,
//                 ),
//               ),
//               const Spacer(),
//               Text(
//                 Constant.currencyCode +
//                     formatNumberWithThousandsSeparator(
//                         dataConfirmCart!.totalPrice),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: Warna.biru,
//                 ),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
// >>>>>>> 3f9f3e01d190d91a8882ff0e46bacfd79ab2f602
