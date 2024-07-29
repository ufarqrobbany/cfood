import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/screens/reviews.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

Future menuFrameSheet(
  BuildContext? context, {
  final String? imgUrl,
  final String? productName,
  final String? description,
  final String? price,
  final String? rate,
  final String? likes,
  final String? count,
  final int? sold,
  final VoidCallback? onPressed,
  final VoidCallback? onTapAdd,
  final VoidCallback? onTapRemove,
  final double? innerContentSize,
}) {
  bool itsFavorite = false;
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
                      '/.jpg',
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
                  const Text(
                    '[Nama Menu]',
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // MENU REVIEW
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: Warna.hijau.withOpacity(0.60), width: 1),
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
                      ),
                      const SizedBox(
                        width: 8,
                      ),
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
                            const Text(
                              '100',
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
                            const Text(
                              '4.1',
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
                            const ReviewScreen(
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
                  const SizedBox(
                    height: 40,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Text(
                        '''Nasi Goreng Spesial kami adalah perpaduan sempurna antara rasa dan aroma yang menggugah selera. Dibuat dari nasi putih berkualitas, kami menggorengnya dengan bumbu pilihan seperti bawang putih, bawang merah, dan cabai merah yang dihaluskan. Ditambah dengan potongan ayam, udang segar, dan sayuran seperti wortel, kacang polong, serta irisan daun bawang, menciptakan tekstur yang beragam dalam setiap suapan. Tak lupa, tambahan kecap manis dan saus tiram memberikan sentuhan manis dan gurih yang seimbang. Disajikan dengan telur mata sapi setengah matang di atasnya, serta kerupuk udang yang renyah, membuat hidangan ini semakin istimewa. Sebagai pelengkap, acar mentimun dan tomat segar memberikan kesegaran yang kontras dengan rasa gurih nasi goreng. Cocok dinikmati kapan saja, baik untuk sarapan, makan siang, maupun makan malam. Nikmati kelezatan Nasi Goreng Spesial yang akan memanjakan lidah Anda dan memberikan pengalaman kuliner yang tak terlupakan.''',
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
                    'Rp10.000',
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
                        onPressed: () {
                          setState(() {
                            itsFavorite = !itsFavorite;
                          });
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: itsFavorite ? Colors.white : Warna.abu4,
                          size: 20,
                        ),
                        label: Text(
                          'Favorit',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: itsFavorite
                                ? Colors.white
                                : Warna.regulerFontColor,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              itsFavorite ? Warna.like : Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(53)),
                          side: BorderSide(
                              color: itsFavorite ? Warna.like : Warna.abu4,
                              width: 1),
                        ),
                      ),
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
                      onPressed: () {},
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
  BuildContext? context, {
  final String? imgUrl,
  final String? productName,
  final String? description,
  final String? price,
  final String? rate,
  final String? likes,
  final String? count,
  final int sold = 0,
  final VoidCallback? onPressed,
  final VoidCallback? onTapAdd,
  final VoidCallback? onTapRemove,
  final double? innerContentSize,
  final List<Map<String, dynamic>>? variantTypeList,
  final VoidCallback? onPressedAddOrder,
}) {
  return showModalBottomSheet(
    context: context!,
    // barrierColor: Colors.transparent,
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
          return SingleChildScrollView(
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
                    count: count!,
                    description: description!,
                    isCustom: false,
                    // productId: product,
                    onTapAdd: onTapAdd,
                    onTapRemove: onTapRemove,
                    innerContentSize: innerContentSize,
                    hideBorder: true,
                  ),
                  ListView.builder(
                    itemCount: variantTypeList!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    // padding: const EdgeInsets.symmetric(horizontal: 25),
                    itemBuilder: (context, indexType) {
                      List<Map<String, dynamic>> variantItems =
                          variantTypeList[indexType]['variants'];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Variant TYpe Title
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Warna.abu,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              variantTypeList[indexType]['name'].toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          ListView.builder(
                            itemCount: variantItems.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, indexVariant) {
                              var variant = variantItems[indexVariant];
                              return ListTile(
                                title: Text(variant['name'].toString()),
                                subtitle: Text(Constant.currencyCode +
                                    variant['cost'].toString()),
                                trailing: const Icon(
                                  Icons.check_box_outline_blank,
                                ),
                                shape: indexVariant == variantItems.length - 1
                                    ? null
                                    : Border(
                                        bottom: BorderSide(
                                            color: Warna.abu, width: 1.5)),
                              );
                            },
                          )
                        ],
                      );
                    },
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 25),
                    child: CBlueButton(
                      onPressed: onPressedAddOrder!,
                      text: 'Tambah Pesanan - Rp0',
                      borderRadius: 54.0,
                    ),
                  )
                ],
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
    isDismissible: false,
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
      return DraggableScrollableSheet(
        initialChildSize: 0.45, // Initial height when sheet is first opened
        minChildSize: 0.1, // Minimum height when sheet is collapsed
        maxChildSize: 0.6, // Maximum height when sheet is fully expanded
        expand: false, // Set to false to prevent full expansion
        builder: (context, scrollController) {
          return StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
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
                        height: 50,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5),
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
                          notifCount: driverInfo['rate'].toString(),
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
                            orderInfo!['store'],
                          )
                        ],
                      ),
                      Text(
                          '${Constant.currencyCode}${orderInfo['price']} - ${orderInfo['method']}',
                          style: AppTextStyles.textRegular),
                      Text(
                        '${orderInfo['menu_count']} Menu | ${orderInfo['items_count']}',
                        style: AppTextStyles.textRegular,
                      ),
                      Text('${orderInfo['location']}',
                          style: AppTextStyles.textRegular),
          
                      Container(
                        height: 50,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: CBlueButton(
                          onPressed: onPressedSeeDetail!,
                          text: 'Lihat Detail',
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      );
    },
  );
}
