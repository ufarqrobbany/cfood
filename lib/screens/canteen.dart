import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cfood/custom/CBottomSheet.dart';
import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/custom/popup_dialog.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/add_merchants_response.dart';
import 'package:cfood/model/error_response.dart';
import 'package:cfood/model/follow_merchant_response.dart';
import 'package:cfood/model/get_detail_merchant_response.dart';
import 'package:cfood/model/post_menu_like_response.dart';
import 'package:cfood/model/post_menu_unlike_response.dart';
import 'package:cfood/model/reponse_handler.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/organization.dart';
import 'package:cfood/screens/reviews.dart';
import 'package:cfood/screens/wirausaha_pages/menu_add_edit.dart';
import 'package:cfood/screens/wirausaha_pages/signup_danus.dart';
import 'package:cfood/screens/wirausaha_pages/update_merchant.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:toast/toast.dart';
import 'package:uicons/uicons.dart';

class CanteenScreen extends StatefulWidget {
  final int? merchantId;
  final String? menuId;
  final String merchantType;
  final bool? itsDanusan;
  final bool? isOwner;
  const CanteenScreen({
    super.key,
    this.merchantId,
    this.menuId,
    this.merchantType = 'WIRAUSAHA',
    this.itsDanusan = false,
    this.isOwner = false,
  });

  @override
  State<CanteenScreen> createState() => _CanteenScreenState();
}

class _CanteenScreenState extends State<CanteenScreen>
    with SingleTickerProviderStateMixin {
  bool favorited = false;
  bool goSeacrhMenu = false;
  bool menuOrderCountInfo = false;
  int orderCount = 0;
  String selectedTab = 'Semua';
  late TabController categoryTabController;
  TextEditingController searchTextController = TextEditingController();
  List<Map<String, dynamic>> orderMenuCount = [];
  Map<String, dynamic> organizationMaps = {};

  GetDetailMerchantResponse? merchantDataResponse;
  DataDetailMerchant? dataMerchant;
  String? photoMerchant;
  List<MenusMerchant>? menusMerchant;
  Map<String, List<Menu>> menuMaps = {};

  @override
  void initState() {
    super.initState();
    // categoryTabController = TabController(length: menuMaps.length, vsync: this);
    onEnterPage();
  }

  Future<void> onEnterPage() async {
    fetchDetailDataMerchant();
    if (widget.menuId != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          menuFrameSheet(context);
        },
      );
    }
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 1));
    fetchDetailDataMerchant();
    print('reload...');
  }

  Future<void> fetchDetailDataMerchant() async {
    log(widget.isOwner.toString());
    log(widget.merchantId.toString());
    int merchId = 0;
    if (widget.isOwner!) {
      setState(() {
        merchId = AppConfig.MERCHANT_ID;
      });
    } else {
      setState(() {
        merchId = widget.merchantId!;
      });
    }
    merchantDataResponse = await FetchController(
      endpoint: 'merchants/$merchId/detail?userId=${AppConfig.USER_ID}',
      fromJson: (json) => GetDetailMerchantResponse.fromJson(json),
    ).getData();

    setState(() {
      dataMerchant = merchantDataResponse!.data;
      favorited = merchantDataResponse!.data!.follow!;
      menusMerchant = merchantDataResponse!.data!.menusMerchant!;

      menusMerchant!.forEach((category) {
        menuMaps[category.categoryMenuName!] = category.menus!;
      });

      photoMerchant = AppConfig.URL_IMAGES_PATH +
          merchantDataResponse!.data!.merchantPhoto!;
    });
    log("$dataMerchant");
    log("data menu -> ${json.encode(menusMerchant)}");
  }

  void tapFollow(BuildContext context) {
    if (favorited) {
      log('tap unfollow merchnat');
      unFollowMerchants(context);
    } else {
      log('tap follow merchant');
      followMerchants(context);
    }
  }

  Future<void> followMerchants(BuildContext context) async {
    FollowMerchantResponse response = await FetchController(
      endpoint:
          'merchants/${widget.merchantId}/follow?userId=${AppConfig.USER_ID}',
      fromJson: (json) => FollowMerchantResponse.fromJson(json),
    ).postData({});

    if (response.statusCode == 201 || response.status == 'success') {
      setState(() {
        favorited = true;
      });
      log('tap follow merchant');
    } else {
      // Handle error here
      log('Failed to follow merchant');
      showToast('Gagal Follow ${dataMerchant!.merchantName}');
    }
  }

  Future<void> unFollowMerchants(BuildContext context) async {
    UnfollowMerchantResponse response = await FetchController(
      endpoint:
          'merchants/${widget.merchantId}/unfollow?userId=${AppConfig.USER_ID}',
      fromJson: (json) => UnfollowMerchantResponse.fromJson(json),
    ).deleteData();

    if (response.statusCode == 200 || response.status == 'success') {
      setState(() {
        favorited = false;
      });
      log('tap unfollow merchant');
    } else {
      // Handle error here
      log('Failed to unfollow merchant');
      showToast('Gagal Unfollow ${dataMerchant!.merchantName}');
    }
  }

  Future<void> isFollowMerchants(BuildContext context) async {
    await FetchController(
      endpoint:
          'merchants/${widget.merchantId}/is-follow?userId=${AppConfig.USER_ID}',
      fromJson: (json) => IsFollowMerchantResponse.fromJson(json),
    ).postData({});
  }

  void tapLikeMenu(
    BuildContext context, {
    bool isLike = false,
    int menuId = 0,
    Function? updateState,
    Menu? menuItem,
  }) {
    if (isLike) {
      unLikeMenu(context,
          isLike: isLike, menuId: menuId, updateState: updateState, menuItem: menuItem);
    } else {
      likeMenu(context,
          isLike: isLike, menuId: menuId, updateState: updateState, menuItem: menuItem);
    }
  }

  Future<void> likeMenu(BuildContext context,
      {bool isLike = false, int menuId = 0, Function? updateState, Menu? menuItem}) async {
    PostMenuLikeResponse response = await FetchController(
      endpoint: 'menus/$menuId/like?userId=${AppConfig.USER_ID}',
      fromJson: (json) => PostMenuLikeResponse.fromJson(json),
    ).postData({});

    if (response.statusCode == 201 || response.status == 'success') {
      setState(() {
        isLike = true;
        menuItem!.isLike = isLike;
      });
      updateState!(() {
        isLike = true;
        menuItem!.isLike = isLike;
      });
      log('tap like menu');
    } else {
      // Handle error here
      log('Failed to like menu');
      showToast('Gagal Menyukai Menu');
    }
  }

  Future<void> unLikeMenu(BuildContext context,
      {bool isLike = false, int menuId = 0, Function? updateState, Menu? menuItem}) async {
    PostMenuUnlikeResponse response = await FetchController(
      endpoint: 'menus/$menuId/unlike?userId=${AppConfig.USER_ID}',
      fromJson: (json) => PostMenuUnlikeResponse.fromJson(json),
    ).deleteData();

    if (response.statusCode == 201 || response.status == 'success') {
      setState(() {
        isLike = false;
        menuItem!.isLike = isLike;
      });
      updateState!(() {
        isLike = false;
        menuItem!.isLike = isLike;
      });
      log('tap unlike menu');
    } else {
      // Handle error here
      log('Failed to unlike menu');
      showToast('Gagal Tidak Menyukai Menu');
    }
  }

  // void tapLikeMenu(BuildContext context, {bool isLike = false, int menuId = 0}) {
  //   if(isLike){
  //     unLikeMenu(context, isLike: isLike, menuId: menuId);
  //   } else {
  //     likeMenu(context, isLike: isLike, menuId: menuId);
  //   }
  // }

  // Future<void> likeMenu(BuildContext context, {bool isLike = false, int menuId = 0}) async {
  //   PostMenuLikeResponse response = await FetchController(
  //     endpoint:
  //         'menus/$menuId/like?userId=${AppConfig.USER_ID}',
  //     fromJson: (json) => PostMenuLikeResponse.fromJson(json),
  //   ).postData({});

  //   if (response.statusCode == 201 || response.status == 'success') {
  //     setState(() {
  //       isLike = true;
  //     });
  //     log('tap like menu');
  //   } else {
  //     // Handle error here
  //     log('Failed to like menu');
  //     showToast('Gagal Menyukai Menu');
  //   }
  // }

  // Future<void> unLikeMenu(BuildContext context, {bool isLike = false, int menuId = 0}) async {
  //   PostMenuUnlikeResponse response = await FetchController(
  //     endpoint:
  //         'menus/$menuId/unlike?userId=${AppConfig.USER_ID}',
  //     fromJson: (json) => PostMenuUnlikeResponse.fromJson(json),
  //   ).deleteData();

  //   if (response.statusCode == 201 || response.status == 'success') {
  //     setState(() {
  //       isLike = true;
  //     });
  //     log('tap like menu');
  //   } else {
  //     // Handle error here
  //     log('Failed to like menu');
  //     showToast('Gagal Follow tidak Menyukai Menu');
  //   }
  // }

  Future<void> finishDanus(BuildContext context) async {
    try {
      ResponseHendler response = await FetchController(
          endpoint:
              'organizations/merchants_danus?merchantId=${AppConfig.MERCHANT_ID}',
          fromJson: (json) => ResponseHendler.fromJson(json)).deleteData();
      if (response.status == 'success') {
        refreshPage();
      }
    } on Exception catch (e) {
      // TODO
      log(e.toString());
      showToast(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> addOrderMenu({
    int? menuId,
    String? menuName,
    int? price,
    int? menuCount,
  }) async {
    orderMenuCount.add(
      {
        'id': menuId,
        'nama': menuName,
        'price': price,
        'count': menuCount,
      },
    );

    orderCount = orderMenuCount.length;
    // var priceTotal = orderMenuCount['price'].;
    setState(() {
      menuOrderCountInfo = true;
    });

    log(orderMenuCount.toString());
  }

  Future<void> deleteOrderMenu({
    int? menuId,
    String? menuName,
    int? price,
    int? menuCount,
  }) async {
    orderMenuCount.removeWhere((element) =>
        element['id'] == menuId &&
        element['nama'] == menuName &&
        element['price'] == price &&
        element['count'] == menuCount);

    if (orderMenuCount.isEmpty) {
      setState(() {
        menuOrderCountInfo = false;
      });
    }

    log(orderMenuCount.toString());
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: widget.isOwner!
          ? null
          : AppBar(
              leadingWidth: 90,
              leading: backButtonCustom(
                context: context,
                customTap: () {
                  if (goSeacrhMenu) {
                    setState(
                      () {
                        goSeacrhMenu = !goSeacrhMenu;
                      },
                    );
                  } else {
                    navigateBack(context);
                  }
                },
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              scrolledUnderElevation: 0,
              // forceElevated: true,
              actions: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 80,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      goSeacrhMenu
                          ? Expanded(
                              child: searchBarStore(),
                            )
                          : const SizedBox(
                              width: 0,
                            ),
                      Row(
                        children: [
                          goSeacrhMenu
                              ? const SizedBox(
                                  width: 0,
                                )
                              : actionButtonCustom(
                                  icons: Icons.search,
                                  onPressed: () {
                                    setState(
                                      () {
                                        goSeacrhMenu = !goSeacrhMenu;
                                      },
                                    );
                                  },
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          actionButtonCustom(
                            icons: UIcons.solidRounded.share,
                            onPressed: () {},
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
      backgroundColor: Warna.pageBackgroundColor,
      body: goSeacrhMenu
          ? searchMenuBody()
          : ReloadIndicatorType1(
              onRefresh: refreshPage,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: dataMerchant == null
                    ? Container()
                    : CustomScrollView(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        slivers: [
                          // SliverAppBar(
                          //   pinned: true,

                          // ),
                          SliverList(
                              delegate: SliverChildListDelegate([
                            Container(
                              height: 225,
                              width: double.infinity,
                              color: Warna.pageBackgroundColor,
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 225,
                                    padding: const EdgeInsets.only(bottom: 25),
                                    child: Image.network(
                                      photoMerchant!,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          // Jika loadingProgress null, itu berarti gambar sudah selesai dimuat
                                          return child;
                                        } else {
                                          // Tampilkan loading indicator selama gambar belum selesai dimuat
                                          return Container(
                                            height: 200,
                                            width: double.infinity,
                                            color: Warna.abu2,
                                            child: Center(
                                              child: SizedBox(
                                                width: 50,
                                                child: LoadingAnimationWidget
                                                    .staggeredDotsWave(
                                                        color: Warna.biru,
                                                        size: 30),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        height: 200,
                                        width: double.infinity,
                                        color: Warna.abu2,
                                      ),
                                    ),
                                  ),
                                  widget.isOwner!
                                      ? Container()
                                      : Positioned(
                                          bottom: 0,
                                          right: 25,
                                          child: Container(
                                            width: 62,
                                            height: 62,
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(60),
                                                topRight: Radius.circular(60),
                                              ),
                                              color: Warna.pageBackgroundColor,
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                tapFollow(context);
                                                // setState(() {
                                                //   favorited = !favorited;
                                                // });
                                              },
                                              icon: Icon(
                                                Icons.favorite,
                                                color: Warna.abu2,
                                              ),
                                              selectedIcon: const Icon(
                                                Icons.favorite,
                                                color: Colors.white,
                                              ),
                                              iconSize: 20,
                                              isSelected: favorited,
                                              style: IconButton.styleFrom(
                                                backgroundColor: favorited
                                                    ? Warna.like
                                                    : Colors.white,
                                                shadowColor: Warna.shadow,
                                                elevation: 2.5,
                                              ),
                                              disabledColor: Warna.abu2,
                                              focusColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ])),
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                bodyCanteenInfo(),
                                (widget.isOwner!
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: ListTile(
                                          // contentPadding: EdgeInsets.zero,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 25, vertical: 10),
                                          tileColor:
                                              Warna.hijau.withOpacity(0.10),

                                          title: const Text(
                                            // dataMerchant!
                                            //     .danusInformation!.organizationName!
                                            //     .toString(),
                                            "Edit Informasi Wirausaha",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),

                                          trailing: IconButton(
                                            onPressed: () {
                                              navigateTo(
                                                  context,
                                                  UpdateMerchantScreen(
                                                    merchantId: dataMerchant
                                                        ?.merchantId,
                                                  ));
                                            },
                                            icon: const Icon(Icons.edit,
                                                color: Colors.white),
                                            iconSize: 18,
                                            style: IconButton.styleFrom(
                                              backgroundColor: Warna.hijau,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()),
                                dataMerchant?.danusInformation == null
                                    ? (widget.isOwner!
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: ListTile(
                                              // contentPadding: EdgeInsets.zero,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 10),
                                              tileColor: Warna.kuning
                                                  .withOpacity(0.10),

                                              title: const Text(
                                                // dataMerchant!
                                                //     .danusInformation!.organizationName!
                                                //     .toString(),
                                                "Lagi Danusan?",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              subtitle: const Text(
                                                'Prioritaskan menu kamu agar mudah ditemukan pembeli',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              trailing: IconButton(
                                                onPressed: () {
                                                  navigateTo(
                                                    context,
                                                    SignUpDanusScreen(
                                                      campusId: dataMerchant!
                                                          .studentInformation!
                                                          .campusId!,
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons
                                                    .arrow_forward_ios_rounded),
                                                iconSize: 18,
                                                style: IconButton.styleFrom(
                                                  backgroundColor: Warna.kuning,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container())
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: ListTile(
                                          // contentPadding: EdgeInsets.zero,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 25, vertical: 10),
                                          tileColor:
                                              Warna.kuning.withOpacity(0.10),
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Warna.abu2,
                                              ),
                                              child: Image.network(
                                                '${AppConfig.URL_IMAGES_PATH}${dataMerchant?.danusInformation?.organizationPhoto}',
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      color: Warna.abu2,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          title: const Text(
                                            "Sedang Danusan",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                          subtitle: Text(
                                            'Kegiatan ${dataMerchant?.danusInformation?.activityName}\n${dataMerchant?.danusInformation?.organizationName}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                          trailing: widget.isOwner!
                                              ? InkWell(
                                                  onTap: () {
                                                    log('finish danush?');
                                                    showMyCustomDialog(
                                                      context,
                                                      text:
                                                          'Apakah anda yakin ingin menyelesaikan kegiatan danus?\nProduk danus tidak akan dihapus.',
                                                      colorYes: Warna.like,
                                                      onTapYes: () {
                                                        finishDanus(context);
                                                        navigateBack(context);
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    // height: 30,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15,
                                                        vertical: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      color: Warna.like,
                                                    ),
                                                    child: const Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Selesai  ',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios_rounded,
                                                          size: 15,
                                                          color: Colors.white,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : IconButton(
                                                  onPressed: () => navigateTo(
                                                    context,
                                                    OrganizationScreen(
                                                        id: dataMerchant!
                                                            .danusInformation!
                                                            .organizationId!),
                                                  ),
                                                  icon: const Icon(Icons
                                                      .arrow_forward_ios_rounded),
                                                  iconSize: 18,
                                                  style: IconButton.styleFrom(
                                                      backgroundColor:
                                                          Warna.kuning,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50))),
                                                ),
                                        ),
                                      ),
                                const SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                bodyProductList(),
                              ],
                            ),
                          )
                        ],
                      ),
              ),
            ),
      floatingActionButton: widget.isOwner!
          ? Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: IconButton(
                onPressed: () {
                  navigateTo(
                      context,
                      const AddEditMenuScreen(
                        isEdit: false,
                      ));
                },
                icon: Icon(
                  UIcons.solidRounded.plus_small,
                ),
                iconSize: 40,
                color: Colors.white,
                style: IconButton.styleFrom(
                  backgroundColor: Warna.biru,
                ),
              ),
            )
          : storeMenuCountInfo(),
      floatingActionButtonLocation: widget.isOwner!
          ? FloatingActionButtonLocation.endDocked
          : FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  Widget bodyCanteenInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              dataMerchant!.merchantType! == 'WIRAUSAHA'
                  ? Icon(
                      CommunityMaterialIcons.handshake,
                      color: Warna.kuning,
                      size: 35,
                    )
                  : Icon(
                      Icons.store,
                      color: Warna.biru.withOpacity(0.70),
                      size: 35,
                    ),
              const SizedBox(
                width: 15,
              ),
              Flexible(
                child: Text(
                  dataMerchant!.merchantName!,
                  style: AppTextStyles.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // const Text(
          //   '[List Kategori Kantin]',
          //   style: AppTextStyles.textRegular,
          // ),
          const SizedBox(
            height: 16,
          ),
          storeReviewContainer(),
          const SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Warna.abu2,
                  ),
                  child: Image.network(
                    '${AppConfig.URL_IMAGES_PATH}${dataMerchant?.studentInformation?.userPhoto}', // userPhoto
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Warna.abu2,
                        ),
                      );
                    },
                  ),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${dataMerchant?.studentInformation?.userName}',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text('${dataMerchant?.studentInformation?.studyProgramName}',
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            '${dataMerchant!.merchantDesc}',
            style: AppTextStyles.textRegular,
          ),
          const SizedBox(
            height: 8,
          ),
        ],
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
            ? Border(bottom: BorderSide(color: activeColor!, width: 2))
            : null,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text!,
              style: TextStyle(
                color: menuName == selectedTab
                    ? Warna.regulerFontColor
                    : Warna.abu6,
                fontSize: 15,
                fontWeight: menuName == selectedTab
                    ? FontWeight.w700
                    : FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bodyProductList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 60,
          width: double.infinity,
          color: Colors.white,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            children: menuMaps.keys.map((String key) {
              return tabMenuItem(
                onPressed: () {
                  setState(() {
                    selectedTab = key;
                  });
                },
                text: key,
                menuName: key,
                activeColor: Warna.kuning,
              );
            }).toList(),
          ),
        ),
        ListView.builder(
          itemCount: menuMaps[selectedTab]?.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            List<Menu> menuItems = menuMaps[selectedTab]!;
            Menu item = menuItems[index];
            log('menu photo -> ${item.menuPhoto}');
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: widget.isOwner!
                  ? ProductCardBoxHorizontal(
                      onPressed: () {
                        log('product: ${item.menuName}');
                        // storeMenuCountSheet();
                        menuFrameSheet(
                          context,
                          menuId: item.id!,
                          merchantId: dataMerchant?.merchantId!,
                          imgUrl:
                              "${AppConfig.URL_IMAGES_PATH}${item.menuPhoto}",
                          productName: item.menuName!,
                          description: item.menuDesc!,
                          price: item.menuPrice!.toString(),
                          likes: item.menuLikes!.toString(),
                          count: item.menuStock!.toString(),
                          sold: item.menuSolds ?? 0,
                          rate: item.menuRate.toString(),
                          innerContentSize: 110,
                          isLike: item.isLike!,
                          onTapLike: (updateState) {
                            tapLikeMenu(context,
                                isLike: item.isLike!,
                                menuId: item.id!,
                                updateState: updateState,
                                menuItem: item);
                          },
                          onPressed: () {},
                          onTapAdd: () {},
                          onTapRemove: () {},
                        );
                      },
                      imgUrl: "${AppConfig.URL_IMAGES_PATH}${item.menuPhoto}",
                      productName: item.menuName!,
                      description: item.menuDesc ?? 'deskripsi menu',
                      price: item.menuPrice,
                      likes: item.menuLikes.toString(),
                      rate: item.menuRate.toString(),
                      count: item.menuStock.toString(),
                      // isCustom: item.isDanus!,
                      isCustom: item.variants != null ? true : false,
                      isOwner: widget.isOwner!,
                      onTapEditProduct: () {},
                    )
                  : ProductCardBoxHorizontal(
                      onPressed: () {
                        log('product: ${item.menuName}');
                        // storeMenuCountSheet();
                        menuFrameSheet(
                          context,
                          menuId: item.id!,
                          merchantId: dataMerchant?.merchantId!,
                          imgUrl:
                              "${AppConfig.URL_IMAGES_PATH}${item.menuPhoto}",
                          productName: item.menuName!,
                          description: item.menuDesc!,
                          price: item.menuPrice!.toString(),
                          likes: item.menuLikes!.toString(),
                          count: item.menuStock!.toString(),
                          sold: item.menuSolds ?? 0,
                          rate: item.menuRate.toString(),
                          innerContentSize: 110,
                          isLike: item.isLike!,
                          onTapLike: (updateState) {
                            tapLikeMenu(context,
                                isLike: item.isLike!,
                                menuId: item.id!,
                                updateState: updateState,
                                menuItem: item);
                          },
                          onPressed: () {},
                          onTapAdd: () {},
                          onTapRemove: () {},
                        );
                      },
                      imgUrl: "${AppConfig.URL_IMAGES_PATH}${item.menuPhoto}",
                      productName: item.menuName!,
                      description: item.menuDesc ?? 'deskripsi menu',
                      price: item.menuPrice,
                      likes: item.menuLikes.toString(),
                      rate: item.menuRate.toString(),
                      count: item.menuStock.toString(),
                      // isCustom: item.isDanus!,
                      isCustom: item.variants != null ? true : false,
                      onTapAdd: () {
                        if (item.isDanus!) {
                          menuCustomeFrameSheet(
                            context,
                            productName: item.menuName!,
                            description: item.menuDesc ?? '',
                            price: item.menuPrice,
                            likes: item.menuLikes.toString(),
                            rate: item.menuRate.toString(),
                            count: item.menuStock.toString(),
                            sold: item.menuSolds ?? 0,
                            innerContentSize: 110,
                            variantTypeList: variantMenuTypeList,
                            onTapAdd: () {},
                            onTapRemove: () {},
                            onPressedAddOrder: () {},
                          );
                        } else {
                          // menuFrameSheet(context);
                          setState(() {
                            item.menuStock = item.menuStock! + 1;
                          });
                          addOrderMenu(
                              menuId: item.id!,
                              menuName: item.menuName!,
                              price: item.menuPrice!,
                              menuCount: item.menuStock!);
                          // print(menuItem[index]['count']);
                        }
                      },
                      onTapRemove: () {
                        setState(() {
                          item.menuStock = item.menuStock! - 1;
                        });
                        deleteOrderMenu(
                            menuId: item.id!,
                            menuName: item.menuName!,
                            price: item.menuPrice!,
                            menuCount: item.menuStock!);
                        // print(orderCount);
                      },
                    ),
            );
          },
        ),
        const SizedBox(
          height: 150,
        )
      ],
    );
  }

  Widget searchBarStore() {
    return Container(
        // height: 50,
        // width: double.infinity,
        // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        child: CTextField(
          controller: searchTextController,
          hintText: 'Jajan Apa hari ini?',
          borderColor: Warna.abu4,
          borderRadius: 58,
          maxLines: 1,
          textInputAction: TextInputAction.done,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
          onSubmitted: (p0) {
            // setState(() {
            //   searchDone = true;
            // });
          },
          onChanged: (p0) {
            // _filterSearch();
            // setState(() {
            //   searchDone = true;
            // });
            // if(searchTextController.text.isNotEmpty) {
            //   setState(() {
            //     _showSuggestions = !_showSuggestions;
            //   });
            // }
          },
          prefixIcon: IconButton(
              onPressed: () {
                // setState(() {
                //   searchDone = !searchDone;
                // });
                // setState(() {
                //   // searchDone = !searchDone;
                //   _showSuggestions = !_showSuggestions;
                // });
              },
              padding: EdgeInsets.zero,
              iconSize: 15,
              color: Warna.biru,
              icon: const Icon(
                Icons.search,
              )),
        ));
  }

  Widget actionButtonCustom({VoidCallback? onPressed, IconData? icons}) {
    // leadingWidth: 90,
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icons,
        color: Warna.biru,
      ),
      padding: const EdgeInsets.all(5),
      iconSize: 18,
      style: IconButton.styleFrom(
          backgroundColor: Warna.abu, shape: const CircleBorder()),
    );
  }

  Widget storeReviewContainer() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        dataMerchant!.open == true
            ? Container()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Warna.like, width: 1),
                    color: Warna.like.withOpacity(0.10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      UIcons.solidRounded.time_oclock,
                      size: 13,
                      color: Warna.like,
                    ),
                    const Text(
                      ' Tutup',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
        dataMerchant!.open == true
            ? Container()
            : const SizedBox(
                width: 8,
              ),
        dataMerchant!.location == null
            ? Container()
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
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
                    Text(
                      dataMerchant!.location!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
        dataMerchant!.location == null
            ? Container()
            : const SizedBox(
                width: 8,
              ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
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
                dataMerchant!.followers!.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
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
                dataMerchant!.rating!.toString(),
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
    );
  }

  // Future menuFrameSheet() {
  //   bool itsFavorite = false;
  //   return showModalBottomSheet(
  //     context: context,
  //     // barrierColor: Colors.transparent,
  //     backgroundColor: Colors.white,
  //     enableDrag: true,
  //     showDragHandle: true,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(20), topRight: Radius.circular(20))),
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return SingleChildScrollView(
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 25),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // Menu Image
  //                   ClipRRect(
  //                     borderRadius: BorderRadius.circular(8),
  //                     child: Image.network(
  //                       '/.jpg',
  //                       width: double.infinity,
  //                       height: 300,
  //                       fit: BoxFit.cover,
  //                       errorBuilder: (context, error, stackTrace) {
  //                         return Container(
  //                           width: double.infinity,
  //                           height: 300,
  //                           decoration: BoxDecoration(
  //                             color: Warna.abu2,
  //                             borderRadius: BorderRadius.circular(8),
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 20,
  //                   ),
  //                   // MENU NAME
  //                   const Text(
  //                     '[Nama Menu]',
  //                     style: AppTextStyles.title,
  //                   ),
  //                   const SizedBox(
  //                     height: 8,
  //                   ),
  //                   // MENU REVIEW
  //                   storeReviewContainer(),
  //                   const SizedBox(
  //                     height: 8,
  //                   ),
  //                   // MENU DESCRIPTION
  //                   const SizedBox(
  //                     height: 40,
  //                     child: SingleChildScrollView(
  //                       scrollDirection: Axis.vertical,
  //                       physics: AlwaysScrollableScrollPhysics(),
  //                       child: Text(
  //                         '''Nasi Goreng Spesial kami adalah perpaduan sempurna antara rasa dan aroma yang menggugah selera. Dibuat dari nasi putih berkualitas, kami menggorengnya dengan bumbu pilihan seperti bawang putih, bawang merah, dan cabai merah yang dihaluskan. Ditambah dengan potongan ayam, udang segar, dan sayuran seperti wortel, kacang polong, serta irisan daun bawang, menciptakan tekstur yang beragam dalam setiap suapan. Tak lupa, tambahan kecap manis dan saus tiram memberikan sentuhan manis dan gurih yang seimbang. Disajikan dengan telur mata sapi setengah matang di atasnya, serta kerupuk udang yang renyah, membuat hidangan ini semakin istimewa. Sebagai pelengkap, acar mentimun dan tomat segar memberikan kesegaran yang kontras dengan rasa gurih nasi goreng. Cocok dinikmati kapan saja, baik untuk sarapan, makan siang, maupun makan malam. Nikmati kelezatan Nasi Goreng Spesial yang akan memanjakan lidah Anda dan memberikan pengalaman kuliner yang tak terlupakan.''',
  //                         style: AppTextStyles.textRegular,
  //                         // maxLines: 5,
  //                         // maxLines: 5,
  //                         // softWrap: true,
  //                         // overflow: TextOverflow.visible,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 8,
  //                   ),
  //                   // PRICE
  //                   Text(
  //                     'Rp10.000',
  //                     style: TextStyle(
  //                         color: Warna.biru,
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.w700),
  //                   ),
  //                   const SizedBox(
  //                     height: 15,
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       TextButton.icon(
  //                         onPressed: () {
  //                           setState(() {
  //                             itsFavorite = !itsFavorite;
  //                           });
  //                         },
  //                         icon: Icon(
  //                           Icons.favorite,
  //                           color: itsFavorite ? Colors.white : Warna.abu4,
  //                           size: 20,
  //                         ),
  //                         label: Text(
  //                           'Favorit',
  //                           style: TextStyle(
  //                             fontSize: 13,
  //                             fontWeight: FontWeight.w600,
  //                             color: itsFavorite
  //                                 ? Colors.white
  //                                 : Warna.regulerFontColor,
  //                           ),
  //                         ),
  //                         style: TextButton.styleFrom(
  //                           backgroundColor:
  //                               itsFavorite ? Warna.like : Colors.white,
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(53)),
  //                           side: BorderSide(
  //                               color: itsFavorite ? Warna.like : Warna.abu4,
  //                               width: 1),
  //                         ),
  //                       ),
  //                       TextButton.icon(
  //                         onPressed: () {},
  //                         icon: Icon(
  //                           Icons.share,
  //                           color: Warna.abu4,
  //                           size: 20,
  //                         ),
  //                         label: Text(
  //                           'Bagikan',
  //                           style: TextStyle(
  //                             fontSize: 13,
  //                             fontWeight: FontWeight.w600,
  //                             color: Warna.regulerFontColor,
  //                           ),
  //                         ),
  //                         style: TextButton.styleFrom(
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(53)),
  //                           side: BorderSide(color: Warna.abu4, width: 1),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(
  //                     height: 15,
  //                   ),
  //                   SizedBox(
  //                     width: double.infinity,
  //                     height: 55,
  //                     child: CBlueButton(
  //                       onPressed: () {},
  //                       borderRadius: 55,
  //                       text: 'Tambah Pesanan',
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 25,
  //                   ),
  //                   // const SizedBox(
  //                   //   height: 250,
  //                   // ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Future storeMenuCountSheet() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      elevation: 0,
      // isDismissible: orderCount != 0 ? false : true,
      constraints: const BoxConstraints(
        minHeight: 114,
        maxHeight: 114,
      ),
      isScrollControlled: false,
      builder: (context) {
        return Container(
          height: 66,
          width: double.infinity,
          margin: const EdgeInsets.all(25),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(60)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Warna.kuning,
                    child: Center(
                      child: Icon(
                        UIcons.solidRounded.comment,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    color: Warna.biru,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListTile(
                          // contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          leading: Icon(
                            UIcons.solidRounded.shopping_cart,
                            size: 25,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Pesan Sekarang',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800),
                          ),
                          subtitle: const Text(
                            '2 Menu | 7 Item',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: const SizedBox(
                            width: 85,
                            child: FittedBox(
                              child: Text(
                                'Rp100.000',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget storeMenuCountInfo() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      height: menuOrderCountInfo ? 116 : 0,
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(60),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Warna.kuning,
                child: Center(
                  child: Icon(
                    UIcons.solidRounded.comment,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                color: Warna.biru,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListTile(
                      // contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: Icon(
                        UIcons.solidRounded.shopping_cart,
                        size: 25,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Pesan Sekarang',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800),
                      ),
                      subtitle: const Text(
                        '2 Menu | 7 Item',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: const SizedBox(
                        width: 85,
                        child: FittedBox(
                          child: Text(
                            'Rp100.000',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchMenuBody() {
    return ReloadIndicatorType1(
      onRefresh: refreshPage,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ListView.builder(
          itemCount: menuMaps['Semua']?.length ?? 0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            List<Menu> menuItems = menuMaps['Semua']!;
            Menu item = menuItems[index];
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ProductCardBoxHorizontal(
                onPressed: () {
                  log('product: ${item.menuName}');
                  // storeMenuCountSheet();
                  menuFrameSheet(context);
                },
                productName: item.menuName!,
                description: item.menuDesc ?? 'deskripsi menu',
                price: item.menuPrice,
                likes: item.menuLikes.toString(),
                rate: item.menuRate.toString(),
                count: item.menuStock.toString(),
                onTapAdd: () {
                  setState(() {
                    item.menuStock = item.menuStock! + 1;
                  });
                  // print(menuItem[index]['count']);
                },
                onTapRemove: () {
                  setState(() {
                    item.menuStock = item.menuStock! - 1;
                  });
                  // print(orderCount);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget searchMenuBody() {
  //   return ReloadIndicatorType1(
  //     onRefresh: refreshPage,
  //     child: SingleChildScrollView(
  //       physics: const BouncingScrollPhysics(),
  //       child: ListView.builder(
  //         itemCount: menuMaps['Semua']?.length,
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         itemBuilder: (context, index) {
  //           Map<String, dynamic> menuItems = menuMaps['Semua']!;
  //           String menuKey = menuItems.keys.elementAt(index);
  //           var item = menuItems[menuKey];
  //           return Container(
  //             color: Colors.white,
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 25,
  //             ),
  //             child: ProductCardBoxHorizontal(
  //               onPressed: () {
  //                 log('product: ${item['nama']}');
  //                 // storeMenuCountSheet();
  //                 menuFrameSheet(context);
  //               },
  //               productName: item['nama'],
  //               // description: menuItem[index]['desc'],
  //               description: 'deskripsi menu',
  //               price: item['price'].toString(),
  //               likes: item['likes'],
  //               rate: item['rate'],
  //               count: item['count'].toString(),
  //               onTapAdd: () {
  //                 setState(() {
  //                   item['count'] += 1;
  //                 });
  //                 // print(menuItem[index]['count']);
  //               },
  //               onTapRemove: () {
  //                 setState(() {
  //                   item['count'] -= 1;
  //                 });
  //                 // print(orderCount);
  //               },
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Map<String, Map<String, Map<String, dynamic>>> menuMaps = {
  //   'Semua': {
  //     'menu 1': {
  //       'id': '1',
  //       'nama': 'nama menu',
  //       'rate': '4.0',
  //       'likes': '100',
  //       'price': 10000,
  //       'count': 0,
  //       'sold': 100,
  //       'custom': true,
  //     },
  //     'menu 2': {
  //       'id': '2',
  //       'nama': 'nama menu',
  //       'rate': '4.0',
  //       'likes': '100',
  //       'price': 10000,
  //       'count': 0,
  //       'sold': 100,
  //       'custom': false,
  //     },

  //   },
  //   'kategori 1': {
  //     'menu 1': {
  //       'id': '7',
  //       'nama': 'nama menu kategori 1',
  //       'rate': '4.0',
  //       'likes': '100',
  //       'price': 10000,
  //       'count': 0,
  //       'sold': 100,
  //       'custom': false,
  //     },
  //     'menu 2': {
  //       'id': '8',
  //       'nama': 'nama menu',
  //       'rate': '4.0',
  //       'likes': '100',
  //       'price': 10000,
  //       'count': 0,
  //       'sold': 100,
  //       'custom': false,
  //     },

  //   },
  //   'kategori 2': {
  //     'menu 1': {
  //       'id': '11',
  //       'nama': 'nama menu kategori 2',
  //       'rate': '4.0',
  //       'likes': '100',
  //       'price': 10000,
  //       'count': 0,
  //       'sold': 100,
  //       'custom': false,
  //     },

  //   },
  //   'kategori 3': {
  //     'menu 1': {
  //       'id': '15',
  //       'nama': 'nama menu kategori 3',
  //       'rate': '4.0',
  //       'likes': '100',
  //       'price': 10000,
  //       'count': 0,
  //       'sold': 100,
  //       'custom': false,
  //     },

  //   },
  //   'kategori 4': {
  //     'menu 1': {
  //       'id': '19',
  //       'nama': 'nama menu kategori 4',
  //       'rate': '4.0',
  //       'likes': '100',
  //       'price': 10000,
  //       'count': 0,
  //       'sold': 100,
  //       'custom': false,
  //     },

  //   }
  // };

  List<Map<String, dynamic>> variantMenuTypeList = [
    {
      'name': 'koclat',
      'variants': [
        {
          'name': 'coclat deme',
          'cost': 1000,
          'selected': false,
        },
        {
          'name': 'keju deme',
          'cost': 1000,
          'selected': false,
        },
      ],
    },
    {
      'name': 'tiramusi',
      'variants': [
        {
          'name': 'coclat tiramese',
          'cost': 1000,
          'selected': false,
        },
      ],
    },
    {
      'name': 'vanila',
      'variants': [
        {
          'name': 'vanila tiramese',
          'cost': 1000,
          'selected': false,
        },
      ],
    },
  ];
}
