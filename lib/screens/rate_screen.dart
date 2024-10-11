import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/custom/page_item_void.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/create_order_response.dart';
import 'package:cfood/model/reponse_handler.dart';
import 'package:cfood/model/review_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/order_confirm.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/common.dart';
import 'package:cfood/utils/constant.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class RateScreen extends StatefulWidget {
  final DataOrder? dataOrder;
  bool isOwner;
  bool isRated;
  RateScreen(
      {super.key, this.dataOrder, this.isOwner = false, this.isRated = false});

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  TextEditingController reviewsTextController = TextEditingController();
  TextEditingController responseTextController = TextEditingController();
  int selectedStarIndex = 4;
  String type = 'WIRAUSAHA';
  DataOrder? dataOrderResponse;
  DataReview? dataReviews;
  bool isLoading = false;
  bool buttonLoading = false;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    if (widget.dataOrder != null) {
      setState(() {
        dataOrderResponse = widget.dataOrder;
        type = dataOrderResponse!
            .orderInformation!.merchantInformation!.merchantType!;
        log(dataOrderResponse!.id.toString());
        log(dataOrderResponse.toString());
        log('owner : ${widget.isOwner}');
      });
      if (dataOrderResponse!.status == 'SUDAH_RATING') {
        getReviews();
      }
    }
  }

  Future<void> refreshPage() async {
    // await Future.delayed(const Duration(seconds: 10));

    print('reload...');
    fetchData();
  }

  void postRate(BuildContext context) async {
    setState(() {
      buttonLoading = true;
    });
    try {
      ResponseHendler response = await FetchController(
          endpoint: 'orders/rate',
          fromJson: (json) => ResponseHendler.fromJson(json)).postData({
        'orderId': dataOrderResponse!.id,
        'userId': AppConfig.USER_ID,
        'merchantId': dataOrderResponse!
            .orderInformation!.merchantInformation!.merchantId,
        'rate': selectedStarIndex + 1,
        'reviewText': reviewsTextController.text,
      });
      if (response.statusCode == 200) {
        setState(() {
          buttonLoading = false;
        });
        log('berhasil');
        showToast('Berhasil Memberikan Penilaian');
        // refreshPage();
        navigateBack(context, result: 'SUDAH_RATING');
      } else {
        setState(() {
          buttonLoading = false;
        });
      }
    } on Exception catch (e) {
      setState(() {
        buttonLoading = false;
      });
    }
  }

  void postResponse(BuildContext context) async {
    try {
      setState(() {
        buttonLoading = true;
      });
      ResponseHendler response = await FetchController(
        endpoint: 'reviews/response',
        fromJson: (json) => ResponseHendler.fromJson(json),
        enableToast: false,
      ).putData({
        'reviewId': dataReviews!.reviewId,
        'responseText': responseTextController.text,
      });
      if (response.statusCode == 200) {
        setState(() {
          buttonLoading = false;
        });
        log('berhasil');
        refreshPage();
        // fetchData();
        // showToast('Berhasil Memberikan Penilaian');
      } else {
        setState(() {
          buttonLoading = false;
        });
      }
    } on Exception catch (e) {
      setState(() {
        buttonLoading = false;
      });
    }
  }

  void getReviews() async {
    log('get reviews');
    ReviewResponseModel response = await FetchController(
      endpoint: 'reviews/detail/${dataOrderResponse!.id}',
      fromJson: (json) => ReviewResponseModel.fromJson(json),
    ).getData();

    if (response.statusCode == 200) {
      setState(() {
        dataReviews = response.data;
        selectedStarIndex = (dataReviews!.rating! - 1);
        log('rating : $selectedStarIndex');
      });
    }
  }

  Widget loadingBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backButtonCustom(context: context),
        leadingWidth: 90,
        title: Text(
          widget.isRated == true ? 'Detail Penilaian' : 'Beri Penilaian',
          // 'Detail Penilaian',
          style: AppTextStyles.appBarTitle,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Center(
              child: pageOnLoading(context, bgColor: Colors.transparent))),
    );
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return dataOrderResponse == null
        ? loadingBody(context)
        : Scaffold(
            appBar: AppBar(
              leading: backButtonCustom(context: context),
              leadingWidth: 90,
              title: Text(
                widget.isRated == true ? 'Detail Penilaian' : 'Beri Penilaian',
                // 'Detail Penilaian',
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
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      productBoxRate(),
                      const SizedBox(height: 10),
                      widget.isOwner ? userInfoBox() : Container(),
                      widget.isRated
                          ? dataReviews == null
                              ? SizedBox(
                                  width: double.infinity,
                                  height: 150,
                                  child: Center(
                                    child: pageOnLoading(context,
                                        bgColor: Colors.transparent),
                                  ),
                                )
                              : reviewsBox()
                          : Container(),
                      widget.isOwner
                          ? const SizedBox(
                              height: 20,
                            )
                          : Container(),
                      widget.isOwner
                          ? dataReviews!.responseCreated == ''
                              ? CTextField(
                                  labelText: 'Respon Penjual',
                                  controller: responseTextController,
                                  minLines: 3,
                                )
                              : Container()
                          : dataOrderResponse!.status == 'SUDAH_RATING'
                              ? Container()
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Divider(
                                      color: Warna.abu5,
                                      height: 40,
                                      thickness: 1.8,
                                    ),
                                    CTextField(
                                      labelText: 'Ulasan',
                                      controller: reviewsTextController,
                                      minLines: 3,
                                    ),
                                    Divider(
                                      color: Warna.abu5,
                                      height: 40,
                                      thickness: 1.8,
                                    ),
                                  ],
                                ),
                      const SizedBox(
                        height: 10,
                      ),
                      boxOrderInfoDetail(),
                      widget.isOwner
                          ? dataReviews!.responseCreated == ''
                              ? Container(
                                  height: 50,
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: DynamicColorButton(
                                    onPressed: () {
                                      postResponse(context);
                                    },
                                    isLoading: buttonLoading,
                                    text: 'Respon Penilaian',
                                    backgroundColor: Warna.biru,
                                    borderRadius: 54,
                                  ),
                                )
                              : Container()
                          : dataOrderResponse!.status == 'SUDAH_RATING'
                              ? Container()
                              : Container(
                                  height: 50,
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: DynamicColorButton(
                                    onPressed: () {
                                      postRate(context);
                                    },
                                    isLoading: buttonLoading,
                                    text: 'Konfirmasi Penilaian',
                                    backgroundColor: Warna.biru,
                                    borderRadius: 54,
                                  ),
                                ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget reviewsBox() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.isOwner
            ? Container()
            : const SizedBox(
                height: 20,
              ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          shape: Border(
            top: widget.isOwner
                ? const BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  )
                : BorderSide(
                    color: Warna.abu5,
                    width: 1,
                  ),
            bottom: BorderSide(
              color: Warna.abu5,
              width: 1,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ulasan',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${dataReviews!.reviewCreated}',
                style: TextStyle(
                  fontSize: 14,
                  color: Warna.abu6,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          subtitle: Text(
            dataReviews!.reviewText == ''
                ? '---'
                : '${dataReviews!.reviewText}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        dataReviews!.responseCreated != ''
            ? ListTile(
                contentPadding: EdgeInsets.zero,
                shape: Border(
                  bottom: BorderSide(
                    color: Warna.abu5,
                    width: 1,
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Respon Penjual',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${dataReviews!.responseCreated}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Warna.abu6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  dataReviews!.responseText == ''
                      ? '---'
                      : '${dataReviews!.responseText}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget userInfoBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        dense: false,
        shape: Border(
          bottom: BorderSide(color: Warna.abu, width: 1.5),
          top: BorderSide(color: Warna.abu, width: 1.5),
        ),
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Warna.abu,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              '${AppConfig.URL_IMAGES_PATH}${dataOrderResponse!.userInformation!.userPhoto}',
              fit: BoxFit.cover,
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
        ),
        title: Text(
          '${dataOrderResponse!.userInformation!.userName}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${dataOrderResponse!.userInformation!.studentInformation!.studyProgramInformation!.studyProgramName}',
          style: TextStyle(
            fontSize: 13,
            color: Warna.abu4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget productBoxRate() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // const SizedBox(
        //   height: 25,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type == 'WIRAUSAHA'
                  ? CommunityMaterialIcons.handshake
                  : Icons.store,
              size: 20,
              color: type == 'WIRAUSAHA' ? Warna.kuning : Warna.biru,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              dataOrderResponse!
                  .orderInformation!.merchantInformation!.merchantName
                  .toString(),
              style: AppTextStyles.canteenName,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
          itemCount: dataOrderResponse!
              .orderInformation!.orderItemInformations!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, menuIdx) {
            var item = dataOrderResponse!
                .orderInformation!.orderItemInformations![menuIdx];
            return Container(
              // height: 100,
              // padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: menuIdx ==
                          dataOrderResponse!.orderInformation!
                                  .orderItemInformations!.length -
                              1
                      ? const BorderSide(color: Colors.transparent, width: 1.5)
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
        const SizedBox(
          height: 20,
        ),
        widget.isRated
            ? dataReviews == null
                ? Container()
                : SizedBox(
                    width: 200,
                    child: starIconBuilder(
                      starColor: Warna.kuning,
                      starCount: 5,
                      starSize: 30,
                    ),
                  )
            : SizedBox(
                width: 200,
                child: starIconBuilder(
                  starColor: Warna.kuning,
                  starCount: 5,
                  starSize: 30,
                ),
              ),
        // SizedBox(
        //   width: 200,
        //   child: starIconBuilder(
        //     starColor: Warna.kuning,
        //     starCount: 5,
        //     starSize: 30,
        //   ),
        // ),
      ],
    );
  }

  Widget starIconBuilder({
    final int starCount = 5,
    final double starSize = 24.0,
    final Color starColor = Colors.yellow,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        starCount,
        (index) {
          return GestureDetector(
            onTap: dataReviews != null
                ? () {}
                : () {
                    setState(() {
                      selectedStarIndex = index;
                    });
                    log(selectedStarIndex.toString());
                  },
            child: Icon(
              Icons.star,
              size: starSize,
              color: index <= selectedStarIndex
                  ? Warna.kuning
                  : (index > selectedStarIndex ? Colors.grey : Colors.grey),
            ),
          );
        },
      ),
    );
  }

  Widget boxOrderInfoDetail() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
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
                dataOrderResponse!.note != ''
                    ? dataOrderResponse!.note.toString()
                    : 'Tidak ada',
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
                    dataOrderResponse!.orderNumber!.toString(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: dataOrderResponse!.orderNumber!),
                      );
                      showToast('Copied');
                    },
                    child: Text(
                      'SALIN',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Warna.kuning,
                      ),
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
                dataOrderResponse!.orderDate.toString(),
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
                dataOrderResponse!.paymentMethod.toString(),
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
