import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/page_item_void.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/create_order_response.dart';
import 'package:cfood/model/review_model.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/common.dart';
import 'package:cfood/utils/constant.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class ReviewScreen extends StatefulWidget {
  final int? menuId;
  final int? merchantId;
  final String? storeId;
  final String? imgUrl;
  final String? storeName;
  final String? rate;
  final String? likes;
  final String type;
  final DataOrder? dataOrder;
  const ReviewScreen({
    super.key,
    this.menuId,
    this.merchantId,
    this.storeId,
    this.imgUrl,
    this.storeName,
    this.rate,
    this.likes,
    this.type = 'WIRAUSAHA', // Wirausaha | Menu
    this.dataOrder,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String selectedTab = 'Semua';
  DataOrder? dataOrderResponse;
  ReviewsModel? reviewResponse;
  DataReview? dataReview;
  List<ReviewItem>? reviewList;
  List<Map<String, dynamic>> tabMapReview = [
    {
      'name': 'Semua',
      'data': Reviews().all,
      'total': 0,
    },
    {
      'name': '5',
      'data': Reviews().five,
      'total': 0,
    },
    {
      'name': '4',
      'data': Reviews().four,
      'total': 0,
    },
    {
      'name': '3',
      'data': Reviews().three,
      'total': 0,
    },
    {
      'name': '2',
      'data': Reviews().two,
      'total': 0,
    },
    {
      'name': '1',
      'data': Reviews().one,
      'total': 0,
    },
  ];

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 10));

    print('reload...');
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    if (widget.type == 'WIRAUSAHA' || widget.type == 'KANTIN') {
      fetchMerchantReview();
    } else {
      fetchMenuReview();
    }
  }

  Future<void> fetchMenuReview() async {
    log(widget.type);
    reviewResponse = await FetchController(
        endpoint: 'reviews/menus/${widget.menuId}',
        fromJson: (json) => ReviewsModel.fromJson(json)).getData();
    if (reviewResponse != null) {
      setState(() {
        dataReview = reviewResponse!.data;
        tabMapReview = [
          {
            'name': 'Semua',
            'data': dataReview!.reviews!.all!.list,
            'total': dataReview!.reviews!.all!.total,
          },
          {
            'name': '5',
            'data': dataReview!.reviews!.five!.list,
            'total': dataReview!.reviews!.five!.total,
          },
          {
            'name': '4',
            'data': dataReview!.reviews!.four!.list,
            'total': dataReview!.reviews!.four!.total,
          },
          {
            'name': '3',
            'data': dataReview!.reviews!.three!.list,
            'total': dataReview!.reviews!.three!.total,
          },
          {
            'name': '2',
            'data': dataReview!.reviews!.two!.list,
            'total': dataReview!.reviews!.two!.total,
          },
          {
            'name': '1',
            'data': dataReview!.reviews!.one!.list,
            'total': dataReview!.reviews!.one!.total,
          },
        ];
        reviewList = tabMapReview[0]['data'];
      });
    }
  }

  Future<void> fetchMerchantReview() async {
    log(widget.type);
    reviewResponse = await FetchController(
        endpoint: 'reviews/merchants/${widget.merchantId}',
        fromJson: (json) => ReviewsModel.fromJson(json)).getData();
    if (reviewResponse != null) {
      setState(() {
        dataReview = reviewResponse!.data;
        tabMapReview = [
          {
            'name': 'Semua',
            'data': dataReview!.reviews!.all!.list,
            'total': dataReview!.reviews!.all!.total,
          },
          {
            'name': '5',
            'data': dataReview!.reviews!.five!.list,
            'total': dataReview!.reviews!.five!.total,
          },
          {
            'name': '4',
            'data': dataReview!.reviews!.four!.list,
            'total': dataReview!.reviews!.four!.total,
          },
          {
            'name': '3',
            'data': dataReview!.reviews!.three!.list,
            'total': dataReview!.reviews!.three!.total,
          },
          {
            'name': '2',
            'data': dataReview!.reviews!.two!.list,
            'total': dataReview!.reviews!.two!.total,
          },
          {
            'name': '1',
            'data': dataReview!.reviews!.one!.list,
            'total': dataReview!.reviews!.one!.total,
          },
        ];
        reviewList = tabMapReview[0]['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: backButtonCustom(context: context),
        title: Text(
          widget.type == 'WIRAUSAHA' ? 'Ulasan Wirausaha' : 'Ulasan Menu',
          style: AppTextStyles.title,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Warna.pageBackgroundColor,
      body: reviewResponse == null ?  SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Center(
              child: pageOnLoading(context, bgColor: Colors.transparent))) : ReloadIndicatorType1(
        onRefresh: refreshPage,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  // menuCardInfo(),
                  cardInfo(),
                  bodyReviewsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          bottom: BorderSide(
            color: Warna.shadow.withOpacity(0.10),
          ),
        ),
        // borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              blurRadius: 20,
              spreadRadius: 0,
              color: Warna.shadow.withOpacity(0.12),
              offset: const Offset(0, 0))
        ],
      ),
      child: Row(
        crossAxisAlignment: widget.type == 'WIRAUSAHA' ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.type == 'WIRAUSAHA'
              ? Container(
                  // width: double.infinity,
                  height: 120,
                  width: 120,
                  constraints: const BoxConstraints(
                    minWidth: 120,
                    maxWidth: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: Warna.abu, borderRadius: BorderRadius.circular(8),
                    // borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      // '${dataOrderResponse!.orderInformation!.merchantInformation.}',
                      '${AppConfig.URL_IMAGES_PATH}${dataReview!.merchantInformation!.merchantPhoto}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          width: 120,
                          constraints: const BoxConstraints(
                            minWidth: 120,
                            maxWidth: double.infinity,
                          ),
                          decoration: BoxDecoration(
                              color: Warna.abu,
                              borderRadius: BorderRadius.circular(8)
                              // borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                              ),
                        );
                      },
                    ),
                  ),
                )
              : Container(
                  // width: double.infinity,
                  height: 120,
                  width: 120,
                  constraints: const BoxConstraints(
                    minWidth: 120,
                    maxWidth: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: Warna.abu, borderRadius: BorderRadius.circular(8),
                    // borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      // '${dataOrderResponse!.orderInformation!.merchantInformation.}',
                      '${AppConfig.URL_IMAGES_PATH}${dataReview!.menuInformation!.menuPhoto}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          width: 120,
                          constraints: const BoxConstraints(
                            minWidth: 120,
                            maxWidth: double.infinity,
                          ),
                          decoration: BoxDecoration(
                              color: Warna.abu,
                              borderRadius: BorderRadius.circular(8)
                              // borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                              ),
                        );
                      },
                    ),
                  ),
                ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.type == 'WIRAUSAHA'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              dataReview!.merchantInformation!.merchantType ==
                                      'WIRAUSAHA'
                                  ? CommunityMaterialIcons.handshake
                                  : Icons.store,
                              size: 25,
                              color: dataReview!.merchantInformation!.merchantType ==
                                      'WIRAUSAHA'
                                  ? Warna.kuning : Warna.biru,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              dataReview!.merchantInformation!.merchantName
                                  .toString(),
                              style: AppTextStyles.productName,
                            ),
                          ],
                        )
                      : Text(
                          dataReview!.menuInformation!.menuName.toString(),
                          style: AppTextStyles.productName,
                        ),
                  const SizedBox(
                    height: 5,
                  ),

                  // Info Name, rate, likes
                  // widget.type == 'Kantin'
                  //     ?
                  //     // State for Kantin
                  //     Column(
                  //         children: [
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             children: [
                  //               Container(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 6, vertical: 1),
                  //                 decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(4),
                  //                   border: Border.all(
                  //                       color: Warna.kuning, width: 1),
                  //                   color: Warna.kuning.withOpacity(0.10),
                  //                 ),
                  //                 child: Row(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     Icon(
                  //                       Icons.star,
                  //                       size: 10,
                  //                       color: Warna.kuning,
                  //                     ),
                  //                     Text(
                  //                       widget.rate!,
                  //                       style: TextStyle(
                  //                           color: Warna.kuning, fontSize: 12),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               const SizedBox(
                  //                 width: 5,
                  //               ),
                  //               Text(
                  //                 '100 Penilian',
                  //                 style: TextStyle(
                  //                   color: Warna.regulerFontColor,
                  //                   fontSize: 12,
                  //                 ),
                  //               ),
                  //               const SizedBox(
                  //                 width: 5,
                  //               ),
                  //             ],
                  //           ),
                  //           const SizedBox(
                  //             height: 5,
                  //           ),
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             children: [
                  //               Container(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 6, vertical: 1),
                  //                 decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(4),
                  //                   border: Border.all(
                  //                       color: Warna.hijau.withOpacity(0.60),
                  //                       width: 1),
                  //                   color: Warna.hijau.withOpacity(0.10),
                  //                 ),
                  //                 child: Row(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     Icon(
                  //                       Icons.location_pin,
                  //                       size: 15,
                  //                       color: Warna.hijau,
                  //                     ),
                  //                     const Text(
                  //                       'Lokasi',
                  //                       style: TextStyle(fontSize: 12),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               const SizedBox(
                  //                 width: 5,
                  //               ),
                  //               Container(
                  //                 padding: const EdgeInsets.symmetric(
                  //                     horizontal: 6, vertical: 1),
                  //                 decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(4),
                  //                     border: Border.all(
                  //                         color: Warna.like, width: 1),
                  //                     color: Warna.like.withOpacity(0.10)),
                  //                 child: Row(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     Icon(
                  //                       Icons.favorite,
                  //                       size: 10,
                  //                       color: Warna.like,
                  //                     ),
                  //                     Text(
                  //                       widget.likes!,
                  //                       style: TextStyle(
                  //                           color: Warna.like, fontSize: 12),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           )
                  //         ],
                  //       )
                  //     :
                  // State for Wirausaha
                  widget.type == 'WIRAUSAHA'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Warna.like, width: 1),
                                      color: Warna.like.withOpacity(0.10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: 10,
                                        color: Warna.like,
                                      ),
                                      Text(
                                        dataReview!.merchantInformation!
                                            .merchantFollowers
                                            .toString(),
                                        style: TextStyle(
                                            color: Warna.like, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Warna.kuning, width: 1),
                                    color: Warna.kuning.withOpacity(0.10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Warna.kuning,
                                      ),
                                      Text(
                                        roundToOneDecimal(dataReview!
                                                .merchantInformation!
                                                .merchantRating!)
                                            .toString(),
                                        style: TextStyle(
                                            color: Warna.kuning, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${dataReview!.merchantInformation!.totalMerchantReviews} Penilian',
                                  style: TextStyle(
                                    color: Warna.regulerFontColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            // const SizedBox(
                            //   height: 5,
                            // ),
                            // Text(
                            //   'Nama Mahasiswa - Prodi & Jurusan',
                            //   style: TextStyle(
                            //     color: Warna.regulerFontColor,
                            //     fontSize: 12,
                            //   ),
                            // ),
                          ],
                        )
                      :
                      // State for Menu info
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Warna.kuning, width: 1),
                                    color: Warna.kuning.withOpacity(0.10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Warna.kuning,
                                      ),
                                      Text(
                                        roundToOneDecimal(dataReview!
                                                .menuInformation!.menuRating!)
                                            .toString(),
                                        style: TextStyle(
                                            color: Warna.kuning, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${dataReview!.menuInformation!.totalMenuReviews} Penilian',
                                  style: TextStyle(
                                    color: Warna.regulerFontColor,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color: Warna.like, width: 1),
                                      color: Warna.like.withOpacity(0.10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: 10,
                                        color: Warna.like,
                                      ),
                                      Text(
                                        dataReview!.menuInformation!.menuLikes
                                            .toString(),
                                        style: TextStyle(
                                            color: Warna.like, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${dataReview!.menuInformation!.menuSolds} Terjual',
                                  style: TextStyle(
                                    color: Warna.regulerFontColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${Constant.currencyCode}${formatNumberWithThousandsSeparator(dataReview!.menuInformation!.menuPrice!)}',
                              style: AppTextStyles.productPrice,
                            ),
                            // widget.type == 'Menu'
                            //     ? Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           Text(
                            //             '[Deskripsi menu satu baris]',
                            //             style: TextStyle(
                            //               color: Warna.regulerFontColor,
                            //               fontSize: 12,
                            //             ),
                            //           ),
                            //           Text(
                            //             '${Constant.currencyCode}10.000',
                            //             style: AppTextStyles.productPrice,
                            //           ),
                            //         ],
                            //       )
                            //     : Container(),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                ],
              ),
            ),
          )
        ],
      ),
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

  Widget bodyReviewsList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 60,
          width: double.infinity,
          color: Colors.white,
          child: ListView.builder(
            itemCount: tabMapReview.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            itemBuilder: (context, index) {
              var key = tabMapReview[index]['name'];
              var total = tabMapReview[index]['total'];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 0),
                decoration: BoxDecoration(
                  border: key == selectedTab
                      ? Border(
                          bottom: BorderSide(
                              color: Warna.kuning,
                              width: 2,
                              style: BorderStyle.solid),
                        )
                      : null,
                ),
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedTab = key;
                      reviewList = tabMapReview[index]['data'];
                    });
                    log('Tab : $selectedTab');
                  },
                  child: key == 'Semua'
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Semua',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: selectedTab == key
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                  color: selectedTab == key
                                      ? Warna.regulerFontColor
                                      : Warna.abu6,
                                ),
                              ),
                              Text(
                                '($total)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: selectedTab == key
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                                  color: selectedTab == key
                                      ? Warna.regulerFontColor
                                      : Warna.abu6,
                                ),
                              )
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              starIconBuilder(
                                starColor: Warna.kuning,
                                starCount: int.parse(key),
                                starSize: 16.0,
                              ),
                              Text(
                                '($total)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: selectedTab == key
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                                  color: selectedTab == key
                                      ? Warna.regulerFontColor
                                      : Warna.abu6,
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              );
            },
            // children: reviewsMaps.keys.map((String key) {
            //   return AnimatedContainer(
            //     duration: const Duration(milliseconds: 0),
            //     decoration: BoxDecoration(
            //       border: key == selectedTab
            //           ? Border(
            //               bottom: BorderSide(
            //                   color: Warna.kuning,
            //                   width: 2,
            //                   style: BorderStyle.solid),
            //             )
            //           : null,
            //     ),
            //     padding: const EdgeInsets.only(top: 10),
            //     child: InkWell(
            //       onTap: () {
            //         setState(() {
            //           selectedTab = key;
            //         });
            //         log('Tab : $selectedTab');
            //       },
            //       child: key == 'Semua'
            //           ? Padding(
            //               padding: const EdgeInsets.symmetric(horizontal: 10),
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 children: [
            //                   Text(
            //                     'Semua',
            //                     style: TextStyle(
            //                       fontSize: 15,
            //                       fontWeight: selectedTab == key
            //                           ? FontWeight.w500
            //                           : FontWeight.normal,
            //                       color: selectedTab == key
            //                           ? Warna.regulerFontColor
            //                           : Warna.abu6,
            //                     ),
            //                   ),
            //                   Text(
            //                     '(0)',
            //                     style: TextStyle(
            //                       fontSize: 13,
            //                       fontWeight: selectedTab == key
            //                           ? FontWeight.w700
            //                           : FontWeight.normal,
            //                       color: selectedTab == key
            //                           ? Warna.regulerFontColor
            //                           : Warna.abu6,
            //                     ),
            //                   )
            //                 ],
            //               ),
            //             )
            //           : Padding(
            //               padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 children: [
            //                   starIconBuilder(
            //                     starColor: Warna.kuning,
            //                     starCount: int.parse(key),
            //                     starSize: 16.0,
            //                   ),
            //                   Text(
            //                     '(0)',
            //                     style: TextStyle(
            //                       fontSize: 13,
            //                       fontWeight: selectedTab == key
            //                           ? FontWeight.w700
            //                           : FontWeight.normal,
            //                       color: selectedTab == key
            //                           ? Warna.regulerFontColor
            //                           : Warna.abu6,
            //                     ),
            //                   )
            //                 ],
            //               ),
            //             ),
            //     ),
            //   );
            // }).toList(),
          ),
        ),
        reviewList == null
            ? Container() : reviewList == []
            ? itemsEmptyBody(context,
                bgcolors: Colors.transparent,
                icons: UIcons.solidRounded.star,
                iconsColor: Warna.kuning,
                text: 'Belum ada Review')
            : ListView.builder(
                // itemCount: reviewsMaps[selectedTab]?.length,
                itemCount: reviewList!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // Map<String, dynamic> reviewsItem = reviewsMaps[selectedTab]!;
                  // String reviewKey = reviewsItem.keys.elementAt(index);
                  // var item = reviewsItem[reviewKey];
                  ReviewItem item = reviewList![index];
                  // double rating = roundToOneDecimal(item!.rating);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Warna.abu, width: 1.5),
                      ),
                    ),
                    child: reviewItemBox(
                      photoProfile: item.userPhoto,
                      name: item.userName,
                      rate: item.rating.toString(),
                      reviewsText: item.reviewText,
                      image: null,
                      menuList: item.menus,
                      dateTime: item.reviewCreated,
                      respond:
                          item.responseText != '' ? item.responseText : null,
                      responseCreated: item.responseCreated,
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget reviewItemBox({
    final String? photoProfile,
    final String? name,
    final String? rate,
    final String? reviewsText,
    final String? image,
    final String? menuList,
    final String? dateTime,
    final String? respond,
    final String? responseCreated,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  '${AppConfig.URL_IMAGES_PATH}${photoProfile!}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Warna.abu2,
                      ),
                    );
                  },
                ),
              ),
            ),
            title: Text(
              name ?? '----',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: starIconBuilder(
              starColor: Warna.kuning,
              starCount: int.parse(rate!),
              starSize: 16.0,
            ),
          ),
          reviewsText == ''
              ? Container()
              : const SizedBox(
                  height: 5,
                ),
          reviewsText == ''
              ? Container()
              : Text(
                  reviewsText!,
                  style: AppTextStyles.textRegular,
                ),
          // MENULIST
          menuList != null
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Warna.abu5,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.fastfood_rounded,
                        size: 18,
                        color: Warna.oranye2,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          menuList,
                          style: AppTextStyles.textRegular,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
          // IMAGE REVIEWS
          image != null
              ? Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Warna.abu5,
                  ),
                  child: Image.network(
                    image,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        width: 100,
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Warna.abu5,
                        ),
                      );
                    },
                  ),
                )
              : Container(),
          const SizedBox(
            height: 5,
          ),
          Text(
            dateTime!,
            style: AppTextStyles.textRegular,
          ),

          const SizedBox(
            height: 5,
          ),
          respond != null
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Warna.abu5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Respon Penjual',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            responseCreated.toString(),
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Text(
                        respond,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

Map<String, Map<String, Map<String, dynamic>>> reviewsMaps = {
  'Semua': {
    'ulasan 1': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '5',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 2': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '5',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 3': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '4',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 4': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '3',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 5': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '4',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 6': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '4',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
  },
  '5': {
    'ulasan 1': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '5',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 2': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '5',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 3': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '5',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 4': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '5',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
  },
  '4': {
    'ulasan 1': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '4',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 2': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '4',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 3': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '4',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 4': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '4',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
  },
  '3': {
    'ulasan 1': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '3',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 2': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '3',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 3': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '3',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 4': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '3',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
  },
  '2': {
    'ulasan 1': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '2',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 2': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '2',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 3': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '2',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 4': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '2',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
  },
  '1': {
    'ulasan 1': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '1',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 2': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '1',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 3': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '1',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
    'ulasan 4': {
      'id': '1',
      'nama': 'nama pengguna',
      'rate': '1',
      'ulasan': '100',
      'dateTime': '17 Juli 2024',
      'image': '',
      'respon': '',
    },
  },
};
