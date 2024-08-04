import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/custom/order_status_timeline_tile.dart';
import 'package:cfood/model/get_detail_merchant_response.dart';
import 'package:cfood/model/get_specific_menu_response.dart';
import 'package:cfood/screens/reviews.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/common.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:uicons/uicons.dart';

String getMinMax(int minimal, int maximal, int length, bool required) {
  String isMinMax = "";
  if (required) {
    // asumsikan minimal tidak akan 0
    if (minimal < maximal) {
      isMinMax = (maximal == length)
          ? 'Minimal $minimal'
          : 'Minimal $minimal, maksimal $maximal';
    } else if (minimal == maximal) {
      isMinMax = 'Pilih $maximal';
    }
  } else {
    // asumsikan minimal adalah 0
    if (minimal < maximal) {
      isMinMax = (maximal == length) ? '' : 'Maksimal $maximal';
    }
  }
  return isMinMax;
}

Future menuFrameSheet(
  BuildContext? context, {
  final int? menuId,
  final int? merchantId,
  final String? imgUrl,
  final String? productName,
  final String? description,
  final String? location,
  final int? price,
  final String? rate,
  final String? likes,
  bool isLike = false,
  final String? count,
  final int? sold,
  final Function? onTapLike,
  final VoidCallback? onPressed,
  final VoidCallback? onTapAdd,
  final VoidCallback? onTapRemove,
  final double? innerContentSize,
}) {
  // bool itsFavorite = false;
  return showModalBottomSheet(
    context: context!,
    // barrierColor: Colors.transparent,
    backgroundColor: Colors.white,
    enableDrag: true,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menu Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imgUrl!,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Warna.abu2,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // MENU NAME
                  Text(
                    productName!,
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // MENU REVIEW
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      location != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: Warna.hijau.withOpacity(0.60),
                                    width: 1),
                                color: Warna.hijau.withOpacity(0.10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    size: 15,
                                    color: Warna.hijau,
                                  ),
                                  const Text(
                                    'Lokasi',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      location != null
                          ? const SizedBox(
                              width: 8,
                            )
                          : Container(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Warna.like, width: 1),
                          color: Warna.like.withOpacity(0.10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 15,
                              color: Warna.like,
                            ),
                            Text(
                              likes!,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Warna.kuning, width: 1),
                          color: Warna.kuning.withOpacity(0.10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              size: 15,
                              color: Warna.kuning,
                            ),
                            Text(
                              rate!,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      CYellowMoreButton(
                        onPressed: () {
                          navigateTo(
                            context,
                            ReviewScreen(
                              menuId: menuId,
                              merchantId: merchantId,
                              storeName: 'Nama Toko',
                              likes: '100',
                              rate: '4.4',
                              imgUrl: '/.jpg',
                              storeId: '000',
                              type: 'Menu',
                            ),
                          );
                        },
                        height: 30,
                        textStyle: TextStyle(
                          fontSize: 13,
                          color: Warna.regulerFontColor,
                          fontWeight: FontWeight.w600,
                        ),
                        text: 'Lihat Ulasan >',
                      ),
                      // const SizedBox(
                      //   width: 8,
                      // ),

                      // const Text(
                      //   '100 Penilaian',
                      //   style: AppTextStyles.textRegular,
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // MENU DESCRIPTION
                  SizedBox(
                    height: 40,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Text(
                        '''$description!''',
                        style: AppTextStyles.textRegular,
                        // maxLines: 5,
                        // maxLines: 5,
                        // softWrap: true,
                        // overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // PRICE
                  Text(
                    '${Constant.currencyCode}${formatNumberWithThousandsSeparator(price!)}',
                    style: TextStyle(
                        color: Warna.biru,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () => onTapLike!(setState(
                          () {
                            isLike = !isLike;
                          },
                        )),
                        // onPressed: () {
                        //   setState(() {
                        //     // itsFavorite = !itsFavorite;
                        //     isLike = !isLike;
                        //   });
                        // },
                        icon: Icon(
                          Icons.favorite,
                          color: isLike ? Colors.white : Warna.abu4,
                          size: 20,
                        ),
                        label: Text(
                          'Favorit',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color:
                                isLike ? Colors.white : Warna.regulerFontColor,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: isLike ? Warna.like : Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(53)),
                          side: BorderSide(
                              color: isLike ? Warna.like : Warna.abu4,
                              width: 1),
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.share,
                          color: Warna.abu4,
                          size: 20,
                        ),
                        label: Text(
                          'Bagikan',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Warna.regulerFontColor,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(53)),
                          side: BorderSide(color: Warna.abu4, width: 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: CBlueButton(
                      onPressed: onPressed!,
                      borderRadius: 55,
                      text: 'Tambah Pesanan',
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // const SizedBox(
                  //   height: 250,
                  // ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future menuCustomeFrameSheet(
  BuildContext context, {
  required String imgUrl,
  required String productName,
  required String description,
  required int price,
  required String rate,
  required String likes,
  required int count,
  required int subTotal,
  int sold = 0,
  required VoidCallback onPressed,
  required Function(int, int, List<VariantOption>) onTapAddOrder,
  required Function(Function) onTapAdd,
  required Function(Function) onTapRemove,
  required double innerContentSize,
  required List<Variant> variantTypeList,
  required VariantOption? variantSelected,
  required int total,
}) {
  int variantSelectedList = 0;
  int selectedCount = 0;
  int optionPrice = 0;
  int calculatedTotal = 0;
  bool isLoading = false;

  int validVariant = variantTypeList.length;

  ToastContext().init(context);
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    enableDrag: true,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return PopScope(
            canPop: true,
            onPopInvoked: (didPop) {
              setState(() {
                isLoading = false;
                selectedCount = 0;
                optionPrice = 0;
                calculatedTotal = 0;
                variantSelected = null;
                variantSelectedList = 0;

                for (var variantType in variantTypeList) {
                  variantType.selected = false;
                  for (var option in variantType.variantOptions!) {
                    option.selected = false;
                  }
                }
              });
            },
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductCardBoxHorizontal(
                      imgUrl: imgUrl,
                      productName: productName,
                      price: price,
                      rate: rate,
                      likes: likes,
                      sold: sold,
                      count: selectedCount.toString(),
                      description: description,
                      isCustom: false,
                      onTapAdd: () {
                        setState(() {
                          selectedCount++;
                          calculatedTotal =
                              (price + optionPrice) * selectedCount;
                        });
                      },
                      onTapRemove: () {
                        if (selectedCount > 0) {
                          setState(() {
                            selectedCount--;
                            calculatedTotal =
                                (price + optionPrice) * selectedCount;
                          });
                        }
                      },
                      innerContentSize: innerContentSize,
                      hideBorder: true,
                    ),
                    ListView.builder(
                      itemCount: variantTypeList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, indexType) {
                        List<dynamic> variantItems =
                            variantTypeList[indexType].variantOptions!;

                        int optionSelected = variantItems
                            .where((option) => option.selected == true)
                            .length;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Warna.abu,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        variantTypeList[indexType]
                                            .variantName
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                        (variantTypeList[indexType].isRequired!
                                            ? "Wajib (${getMinMax(variantTypeList[indexType].minimal!, variantTypeList[indexType].maximal!, variantTypeList[indexType].variantOptions!.length, variantTypeList[indexType].isRequired!)})"
                                            : "Opsional (${getMinMax(variantTypeList[indexType].minimal!, variantTypeList[indexType].maximal!, variantTypeList[indexType].variantOptions!.length, variantTypeList[indexType].isRequired!)})"),
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500))
                                  ],
                                )),
                            ListView.builder(
                              itemCount: variantItems?.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, indexVariant) {
                                VariantOption option =
                                    variantItems![indexVariant];

                                variantSelectedList = variantTypeList
                                    .where(
                                        (selected) => selected.selected == true)
                                    .length;

                                return CheckboxListTile(
                                  value: option.selected,
                                  onChanged: (value) {
                                    setState(() {
                                      if (selectedCount != 0) {
                                        log('${option.variantOptionName} - $option.selected');
                                        if (value!) {
                                          if (optionSelected <
                                              variantTypeList[indexType]
                                                  .maximal!) {
                                            option.selected = value!;
                                            optionPrice +=
                                                option.variantOptionPrice!;
                                            calculatedTotal =
                                                (price + optionPrice) *
                                                    selectedCount;
                                            optionSelected++;
                                            log('optionSelected: $optionSelected');
                                            variantSelected = option;
                                          }
                                        } else {
                                          option.selected = value!;
                                          optionPrice -=
                                              option.variantOptionPrice!;
                                          calculatedTotal =
                                              (price + optionPrice) *
                                                  selectedCount;
                                          optionSelected--;
                                          log('optionSelected: $optionSelected');
                                          variantSelected = null;
                                        }

                                        if (optionSelected >=
                                                variantTypeList[indexType]
                                                    .minimal! &&
                                            optionSelected <=
                                                variantTypeList[indexType]
                                                    .maximal!) {
                                          variantTypeList[indexType].selected =
                                              true;

                                          log('variantSelected: $variantSelectedList');
                                        } else {
                                          variantTypeList[indexType].selected =
                                              false;
                                          log('variantSelected: $variantSelectedList');
                                        }
                                      } else {
                                        showToast("Masukan jumlah menu");
                                      }
                                    });
                                  },
                                  title:
                                      Text(option.variantOptionName.toString()),
                                  subtitle: Text(Constant.currencyCode +
                                      formatNumberWithThousandsSeparator(
                                              option.variantOptionPrice!)
                                          .toString()),
                                  shape: indexVariant == variantItems.length - 1
                                      ? null
                                      : Border(
                                          bottom: BorderSide(
                                              color: Warna.abu, width: 1.5)),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      child: CBlueButton(
                        isLoading: isLoading,
                        onPressed: () async {
                          if (calculatedTotal == 0) {
                            showToast('Masukan jumlah menu');
                            return;
                          }

                          if (variantSelectedList < validVariant) {
                            showToast('Pilih Varian');
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          await onTapAddOrder(
                              selectedCount,
                              calculatedTotal,
                              variantTypeList
                                  .expand((v) => v.variantOptions!)
                                  .where((v) => v.selected!)
                                  .toList());
                          setState(() {
                            isLoading = false;
                            selectedCount = count;
                            // calculatedSubTotal = subTotal;
                            // calculatedTotal = total;
                            variantSelected = null;
                          });
                          Navigator.pop(context);
                        },
                        text:
                            'Tambah Pesanan - ${Constant.currencyCode}${formatNumberWithThousandsSeparator(calculatedTotal)}',
                        borderRadius: 54.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future statusOrderSheet(
  BuildContext? context, {
  final int? orderId,
  final String? status,
  final bool isCashless = true,
  Map<String, dynamic>? orderInfo,
  Map<String, dynamic>? driverInfo,
  final VoidCallback? onPressedStatusButton,
  final VoidCallback? onPressedSeeDetail,
  final VoidCallback? onPressedPay,
}) {
  return showModalBottomSheet(
    context: context!,
    barrierColor: Colors.transparent,
    backgroundColor: Colors.white,
    // isDismissible: false,
    // enableDrag: false,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      final DraggableScrollableController scrollController =
          DraggableScrollableController();
      return StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta! > 0) {
                // Dragging down
                scrollController
                    .jumpTo(0.1); // Set to minimum size (10% of screen height)
              } else if (details.primaryDelta! < 0) {
                // Dragging up
                scrollController
                    .jumpTo(0.45); // Set to initial size (45% of screen height)
              }
            },
            child: DraggableScrollableSheet(
                shouldCloseOnMinExtent: false,
                controller: scrollController,
                initialChildSize:
                    0.5, // Initial height when sheet is first opened
                minChildSize: 0.2, // Minimum height when sheet is collapsed
                maxChildSize:
                    0.5, // Maximum height when sheet is fully expanded
                expand: false, // Set to false to prevent full expansion
                builder: (context, scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          status == 'Belum Bayar'
                              ? const Center(
                                  child: Text(
                                    'Menunggu Pembayaran',
                                    style: AppTextStyles.title,
                                  ),
                                )
                              : Container(),

                          Container(
                            // height: 50,
                            width: double.infinity,
                            // padding: const EdgeInsets.symmetric(vertical: 5),
                            child: DynamicColorButton(
                              onPressed: onPressedStatusButton!,
                              borderRadius: 54,
                              text: status == 'Belum Bayar'
                                  ? 'Batalkan Pesanan'
                                  : status == 'Selesai'
                                      ? 'Konfirmasi Pesanan'
                                      : '',
                              backgroundColor: status == 'Belum Bayar'
                                  ? Warna.like
                                  : status == 'Selesai'
                                      ? Warna.hijau
                                      : Warna.abu2,
                            ),
                          ),

                          // Divider(
                          //   height: 5,
                          //   thickness: 5,
                          //   color: Warna.abu,
                          // ),

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
                            title: Text(
                              driverInfo!['name'].toString(),
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

                          !isCashless
                              ? SizedBox(
                                  height: 50,
                                  width: double.infinity,
                                  child: DynamicColorButton(
                                    onPressed: onPressedPay!,
                                    text: 'Bayar',
                                    backgroundColor: Warna.kuning,
                                  ),
                                )
                              : const SizedBox(),

                          const SizedBox(
                            height: 10,
                          ),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.store,
                                color: Warna.biru1,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                orderInfo?['store_name'],
                              )
                            ],
                          ),

                          Text(
                              '${Constant.currencyCode}${orderInfo?['price']} - ${orderInfo?['method']}',
                              style: AppTextStyles.textRegular),
                          Text(
                            '${orderInfo?['menu_count']} Menu | ${orderInfo?['items_count']}',
                            style: AppTextStyles.textRegular,
                          ),
                          Text('${orderInfo?['location']}',
                              style: AppTextStyles.textRegular),

                          const SizedBox(
                            height: 10,
                          ),

                          Container(
                            height: 50,
                            width: double.infinity,
                            child: CBlueButton(
                              onPressed: onPressedSeeDetail!,
                              text: 'Lihat Detail',
                              backgroundColor: Warna.biru,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        },
      );
    },
  );
}

Future statusDeliverySheet(
  BuildContext? context, {
  final int? orderId,
  final String? status,
  final int? orderStatusIndex,
  final bool isCashless = true,
  Map<String, dynamic>? orderInfo,
  Map<String, dynamic>? driverInfo,
  List<Map<String, dynamic>>? orderStatusProses,
  final VoidCallback? onPressedStatusButton,
  final VoidCallback? onPressedSeeDetail,
  final VoidCallback? onPressedPay,
}) {
  return showModalBottomSheet(
    context: context!,
    barrierColor: Colors.transparent,
    backgroundColor: Colors.white,
    // isDismissible: false,
    // enableDrag: false,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      final DraggableScrollableController scrollController =
          DraggableScrollableController();
      return StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta! > 0) {
                // Dragging down
                scrollController
                    .jumpTo(0.1); // Set to minimum size (10% of screen height)
              } else if (details.primaryDelta! < 0) {
                // Dragging up
                scrollController
                    .jumpTo(0.45); // Set to initial size (45% of screen height)
              }
            },
            child: DraggableScrollableSheet(
                shouldCloseOnMinExtent: false,
                controller: scrollController,
                initialChildSize:
                    0.5, // Initial height when sheet is first opened
                minChildSize: 0.2, // Minimum height when sheet is collapsed
                maxChildSize:
                    0.5, // Maximum height when sheet is fully expanded
                expand: false, // Set to false to prevent full expansion
                builder: (context, scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 130,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: StatusOrderTimeLineTileWidget(
                              processIndex: 0,
                              status: status,
                              statusListMapData: orderStatusProses!,
                            ),
                          ),

                          Container(
                            // height: 50,
                            width: double.infinity,
                            // padding: const EdgeInsets.symmetric(vertical: 5),
                            child: DynamicColorButton(
                              onPressed: onPressedStatusButton!,
                              borderRadius: 54,
                              text: 'Konfirmasi Pesanan Diterima Pelanggan',
                              backgroundColor: Warna.hijau,
                            ),
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          // Divider(
                          //   height: 5,
                          //   thickness: 5,
                          //   color: Warna.abu,
                          // ),

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
                                borderRadius: BorderRadius.circular(40),
                                color: Warna.abu,
                              ),
                              child: Image.asset(
                                '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: Warna.abu,
                                    ),
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              driverInfo!['name'].toString(),
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

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.store,
                                color: Warna.biru1,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                orderInfo?['store_name'],
                              )
                            ],
                          ),

                          Text(
                              '${Constant.currencyCode}${orderInfo?['price']} - ${orderInfo?['method']}',
                              style: AppTextStyles.textRegular),
                          Text(
                            '${orderInfo?['menu_count']} Menu | ${orderInfo?['items_count']}',
                            style: AppTextStyles.textRegular,
                          ),
                          Text('${orderInfo?['location']}',
                              style: AppTextStyles.textRegular),

                          const SizedBox(
                            height: 10,
                          ),

                          Container(
                            height: 50,
                            width: double.infinity,
                            child: CBlueButton(
                              onPressed: onPressedSeeDetail!,
                              text: 'Lihat Detail',
                              backgroundColor: Warna.biru,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        },
      );
    },
  );
}
