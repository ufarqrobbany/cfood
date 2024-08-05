import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cfood/custom/CBottomSheet.dart';
import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/custom/page_item_void.dart';
import 'package:cfood/custom/popup_dialog.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/add_cart_response.dart';
import 'package:cfood/model/add_merchants_response.dart';
import 'package:cfood/model/error_response.dart';
import 'package:cfood/model/follow_merchant_response.dart';
import 'package:cfood/model/get_detail_merchant_response.dart';
import 'package:cfood/model/get_quantity_selected_menu_response.dart';
import 'package:cfood/model/get_specific_menu_response.dart';
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
import 'package:cfood/utils/common.dart';
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
  final bool isOwner;
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
  List<Menu> allMenuItems = []; // Original menu items
  List<Menu> filteredMenuItems = [];
  TextEditingController searchTextController = TextEditingController();
  List<Map<String, dynamic>> orderMenuCount = [];
  Map<String, dynamic> organizationMaps = {};

  GetDetailMerchantResponse? merchantDataResponse;
  DataDetailMerchant? dataMerchant;
  String? photoMerchant;
  List<MenusMerchant>? menusMerchant;
  Map<String, List<Menu>> menuMaps = {};

  DataSpecificMenu? dataSpecificMenu;

  int selectedMenuId = 0;
  DataAddCart? dataAddCartInfo;
  List<DataQuantityMenu>? menuQuanList;
  List<Menu> menuItems = [];

  @override
  void initState() {
    super.initState();
    // categoryTabController = TabController(length: menuMaps.length, vsync: this);
    onEnterPage();

    // Listen for changes in the search input
    searchTextController.addListener(() {
      filterSearchResults();
    });
  }

  void filterSearchResults() {
    setState(() {
      if (searchTextController.text.isEmpty) {
        filteredMenuItems = allMenuItems;
      } else {
        filteredMenuItems = allMenuItems.where((menu) {
          return menu.menuName!.toLowerCase().contains(
                searchTextController.text.toLowerCase(),
              );
        }).toList();
      }
    });
  }

  Future<void> onEnterPage() async {
    fetchDetailDataMerchant();
    if (widget.menuId != null) {
      log('menu id > ${widget.menuId}');
      getSpecificMenu(context);
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
    if (widget.isOwner) {
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
      dataMerchant = merchantDataResponse?.data;
      favorited = merchantDataResponse!.data!.follow!;
      menusMerchant = merchantDataResponse?.data?.menusMerchant!;

      menusMerchant?.forEach((category) {
        menuMaps[category.categoryMenuName!] = category.menus!;
      });

      photoMerchant = AppConfig.URL_IMAGES_PATH +
          merchantDataResponse!.data!.merchantPhoto!;

      allMenuItems = menuMaps['Semua']!;
      filteredMenuItems = allMenuItems;
    });

    if (menuMaps != []) {
      getQuantitySelctedMenu();
    }
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
      showToast('Gagal Unfollow ${dataMerchant?.merchantName}');
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
    // Menu? menuItem,
    dynamic menuItem,
  }) {
    if (isLike) {
      unLikeMenu(context,
          isLike: isLike,
          menuId: menuId,
          updateState: updateState,
          menuItem: menuItem);
    } else {
      likeMenu(context,
          isLike: isLike,
          menuId: menuId,
          updateState: updateState,
          menuItem: menuItem);
    }
  }

  Future<void> likeMenu(
    BuildContext context, {
    bool isLike = false,
    int menuId = 0,
    Function? updateState,
    // Menu? menuItem,
    dynamic menuItem,
  }) async {
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

  Future<void> unLikeMenu(
    BuildContext context, {
    bool isLike = false,
    int menuId = 0,
    Function? updateState,
    // Menu? menuItem,
    dynamic menuItem,
  }) async {
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

  Future<void> getSpecificMenu(BuildContext context) async {
    GetSpecificMenuResponse? response = await FetchController(
        endpoint: 'menus/${widget.menuId}?userId=${AppConfig.USER_ID}',
        fromJson: (json) => GetSpecificMenuResponse.fromJson(json)).getData();

    log('specific menu > ${response?.data}');
    if (response != null) {
      dataSpecificMenu = response.data!;
    }

    fetchDetailDataMerchant();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        menuFrameSheet(
          context,
          menuId: dataSpecificMenu?.id!,
          merchantId: dataMerchant?.merchantId!,
          imgUrl: "${AppConfig.URL_IMAGES_PATH}${dataSpecificMenu?.menuPhoto}",
          productName: dataSpecificMenu?.menuName!,
          description: dataSpecificMenu?.menuDesc!,
          price: dataSpecificMenu?.menuPrice!,
          likes: dataSpecificMenu!.likes!.toString(),
          count: dataSpecificMenu?.menuStock!.toString(),
          // sold: dataSpecificMenu?.menuSolds,
          rate: dataSpecificMenu?.rating.toString(),
          innerContentSize: 110,
          isLike: dataSpecificMenu!.isLike!,
          onTapLike: (updateState) {
            tapLikeMenu(context,
                isLike: dataSpecificMenu!.isLike!,
                menuId: dataSpecificMenu!.id!,
                updateState: updateState,
                menuItem: dataSpecificMenu);
          },
          onPressed: () {
            if (dataSpecificMenu!.variants!.isEmpty) {
              // updateCartItem(item.cartItemId, "add",
              // //  cartId
              //  );
              updateCart(
                menuId: dataSpecificMenu!.id!,
                quantity: 1,
                // variants: selectedVariants
                //     .map((v) => {
                //           'variantId': v.id,
                //           'variantOptionIds': [v.id],
                //         })
                //     .toList(),
              );
              Navigator.pop(context);

              if (dataSpecificMenu!.quantity! < dataSpecificMenu!.menuStock!) {
                updateCart(
                    quantity: dataSpecificMenu!.quantity!,
                    menuId: dataSpecificMenu!.id!);
                Navigator.pop(context);
              } else {
                showToast('Stok tidak mencukupi');
              }
            } else {
              Navigator.pop(context);
              // int selectedCount = 0;
              int selectedCount = dataSpecificMenu!.quantity!;
              int price = dataSpecificMenu!.menuPrice!;
              int subtotal = price;
              menuCustomeFrameSheet(
                context,
                imgUrl:
                    "${AppConfig.URL_IMAGES_PATH}${dataSpecificMenu!.menuPhoto}",
                productName: dataSpecificMenu!.menuName!,
                description: dataSpecificMenu!.menuDesc!,
                price: dataSpecificMenu!.menuPrice!,
                stock: dataSpecificMenu!.menuStock!,
                quantity: dataSpecificMenu!.quantity!,
                sold: dataSpecificMenu!.menuSolds!,
                // quantity: dataSpecificMenu!.quantity!,
                likes: dataSpecificMenu!.likes.toString(),
                rate: dataSpecificMenu!.rating.toString(),
                // count: dataSpecificMenu!.quantity!,
                count: selectedCount,
                // sold: dataSpecificMenu!.solds,

                innerContentSize: 110,
                variantSelected: null,
                total: subtotal,
                variantTypeList: dataSpecificMenu!.variants!,
                onPressed: () {},
                onTapAdd: (Function updateState) {
                  setState(() {
                    selectedCount++;
                  });
                  updateState();
                },
                onTapRemove: (Function updateState) {
                  if (selectedCount > 0) {
                    setState(() {
                      selectedCount--;
                    });
                    updateState();
                  }
                },
                onTapAddOrder:
                    (selectedCount, calculatedTotal, selectedVariants) {
                  setState(() {
                    // Update UI if needed
                  });
                  updateCart(
                    menuId: dataSpecificMenu!.id!,
                    quantity: selectedCount,
                    variants: dataSpecificMenu!.variants!
                        .where((variant) => variant.selected!)
                        .map((variant) => {
                              'variantId': variant.id,
                              'variantOptionIds': variant.variantOptions!
                                  .where((option) => option.selected!)
                                  .map((option) => option.id)
                                  .toList(),
                            })
                        .toList(),

                    // merchantId: merchantId
                  );
                },
              );
            }
          },
          onTapAdd: () {},
          onTapRemove: () {},
        );
      },
    );
  }

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
    int? menuStock,
    int? subTotal,
    Menu? menuItem,
    Function? updateState,
  }) async {
    if (menuCount! < menuStock!) {
      setState(() {
        menuCount = menuCount! + 1;
        subTotal = (price! * menuCount!);

        menuItem = Menu(
          selectedCount: menuCount,
          subTotal: subTotal,
        );
      });
      updateState!(() {
        menuCount = menuCount! + 1;
        subTotal = (price! * menuCount!);
      });
    } else {
      // Show a message that stock limit has been reached
      showToast('Stock tidak mencukupi');
    }
  }

  Future<void> deleteOrderMenu({
    int? menuId,
    String? menuName,
    int? price,
    int? menuCount,
    int? menuStock,
    int? subTotal,
    Menu? menuItem,
    Function? updateState,
  }) async {
    if (menuCount! < 0) {
      setState(() {
        menuCount = menuCount! - 1;
        subTotal = (subTotal! - price!);

        menuItem = Menu(
          selectedCount: menuCount,
          subTotal: subTotal,
        );
      });
      updateState!(() {
        menuCount = menuCount! + 1;
        subTotal = (price! * menuCount!);
      });
    }
  }

  Future<void> addToCart(
    BuildContext context, {
    int menuId = 0,
    int quantity = 0,
    List<Map<String, dynamic>>? variants,
  }) async {
    await FetchController(
      endpoint: '',
      fromJson: (json) => ResponseHendler.fromJson(json),
    ).postData({
      'userId': AppConfig.USER_ID,
      'merchantId': dataMerchant?.merchantId,
      'menuId': menuId,
      'quantity': quantity,
      'variants': variants,
    });

    // Contoh data variants
    //  'variants': [
    //     {
    //       'variantId': 0,
    //       'variantOptionIds': [1, 2],
    //     }
    //   ]
  }

  Future<void> updateCart({
    required int menuId,
    required int quantity,
    List<Map<String, dynamic>>? variants,
  }) async {
    AddCartResponse? info = await FetchController(
      endpoint: 'carts/add',
      fromJson: (json) => AddCartResponse.fromJson(json),
    ).postData({
      'userId': AppConfig.USER_ID,
      'merchantId': dataMerchant?.merchantId,
      'menuId': menuId,
      'quantity': quantity, // positif untuk tambah, negatif untuk kurangi
      'variants': variants ?? [],
    });

    log({
      'userId': AppConfig.USER_ID,
      'merchantId': dataMerchant?.merchantId,
      'menuId': menuId,
      'quantity': quantity, // positif untuk tambah, negatif untuk kurangi
      'variants': variants ?? [],
    }.toString());

    if (info != null) {
      getQuantitySelctedMenu();
      setState(() {
        dataAddCartInfo = info.data!;
      });
    }
  }

  Future<void> getQuantitySelctedMenu() async {
    GetQuantitySelectedMenuResponse response = await FetchController(
      endpoint:
          'carts/quantity?userId=${AppConfig.USER_ID}&merchantId=${dataMerchant?.merchantId}',
      fromJson: (json) => GetQuantitySelectedMenuResponse.fromJson(json),
    ).getData();

    setState(() {
      menuQuanList = response.data!;
      updateMenuItemsQuantity();
    });
  }

  void updateMenuItemsQuantity() {
    if (menuQuanList != null && menuItems.isNotEmpty) {
      for (var menu in menuItems) {
        var matchedMenu = menuQuanList!.firstWhere(
          (menuQuan) => menuQuan.menuId == menu.id,
          // orElse: () => null,
        );
        setState(() {
          menu.selectedCount = matchedMenu.quantity;
        });
      }
    }
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
                child: dataMerchant == null && dataSpecificMenu == null
                    ? pageOnLoading(context)
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
      floatingActionButton: widget.isOwner == true
          ? Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: IconButton(
                onPressed: () {
                  navigateTo(
                      context,
                      AddEditMenuScreen(
                        isEdit: false,
                        merchantIsDanus: dataMerchant!.danusInformation != null
                            ? true
                            : false,
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
      floatingActionButtonLocation: widget.isOwner == true
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
              dataMerchant?.merchantType! == 'WIRAUSAHA'
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
            '${dataMerchant?.merchantDesc}',
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
    return Container(
      color: Colors.white,
      child: Column(
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
          // dataMerchant == null ? Container() :
          ListView.builder(
            itemCount: menuMaps[selectedTab]?.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              menuItems = menuMaps[selectedTab]!;
              Menu item = menuItems[index];
              // log('menu photo -> ${item.menuPhoto}');
              // log('${item.menuName} | ${item.variants}');
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
                            price: item.menuPrice!,
                            likes: item.menuLikes!.toString(),
                            sold: item.menuSolds,
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
                            onPressed: () {
                              // edit menu
                            },
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
                        isCustom: item.variants!.isNotEmpty ? true : false,
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
                            price: item.menuPrice!,
                            likes: item.menuLikes!.toString(),
                            // count: item.menuStock!.toString(),
                            count: item.selectedCount!.toString(),
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
                            onPressed: item.variants!.isNotEmpty
                                ? () {
                                    Navigator.pop(context);
                                    int selectedCount = 0;
                                    int price = item.menuPrice!;
                                    int subtotal = price;
                                    menuCustomeFrameSheet(
                                      context,
                                      imgUrl:
                                          "${AppConfig.URL_IMAGES_PATH}${item.menuPhoto}",
                                      productName: item.menuName!,
                                      description: item.menuDesc ?? '',
                                      price: item.menuPrice!,
                                      stock: item.menuStock!,
                                      quantity: 100, // perbaiki
                                      likes: item.menuLikes.toString(),
                                      rate: item.menuRate.toString(),
                                      // count: item.selectedCount!,
                                      count: item.quantity!,
                                      sold: item.menuSolds ?? 0,
                                      innerContentSize: 110,
                                      variantSelected: null,
                                      total: subtotal,
                                      variantTypeList: item.variants!,
                                      onPressed: () {},
                                      onTapAdd: (Function updateState) {
                                        setState(() {
                                          selectedCount++;
                                          item.selectedCount = selectedCount;
                                        });
                                        updateState();
                                      },
                                      onTapRemove: (Function updateState) {
                                        if (selectedCount > 0) {
                                          setState(() {
                                            selectedCount--;
                                            item.selectedCount = selectedCount;
                                          });
                                          updateState();
                                        }
                                      },
                                      onTapAddOrder: (selectedCount,
                                          calculatedTotal, selectedVariants) {
                                        setState(() {
                                          // Update UI if needed
                                        });
                                        updateCart(
                                          menuId: item.id!,
                                          quantity: selectedCount,
                                          variants: item.variants!
                                              .where((variant) =>
                                                  variant.selected!)
                                              .map((variant) => {
                                                    'variantId': variant.id,
                                                    'variantOptionIds': variant
                                                        .variantOptions!
                                                        .where((option) =>
                                                            option.selected!)
                                                        .map((option) =>
                                                            option.id)
                                                        .toList(),
                                                  })
                                              .toList(),
                                        );
                                      },
                                    );
                                  }
                                : () {
                                    setState(() {
                                      item.selectedCount =
                                          // item.selectedCount! + 1;
                                          item.quantity! + 1;
                                      // item.subTotal =
                                      //     (item.menuPrice! * item.selectedCount!);
                                    });
                                    updateCart(
                                      menuId: item.id!,
                                      quantity: 1,
                                    );
                                    showToast(
                                        'Menu ditambahkan ke dalam keranjang');
                                  },
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
                        // count: item.menuStock!.toString(),
                        // count: item.selectedCount!.toString(),
                        count: item.quantity!.toString(),
                        // isCustom: item.isDanus!,
                        isCustom: item.variants!.isNotEmpty ? true : false,
                        onTapAdd: () async {
                          if (item.variants!.isNotEmpty) {
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
                              price: item.menuPrice!,
                              likes: item.menuLikes!.toString(),
                              // count: item.menuStock!.toString(),
                              // count: item.selectedCount!.toString(),
                              count: item.quantity!.toString(),
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
                              onPressed: item.variants!.isNotEmpty
                                  ? () {
                                      // int selectedCount = item.selectedCount!;
                                      int selectedCount = item.quantity!;
                                      int price = item.menuPrice!;
                                      int subtotal = price * selectedCount;
                                      menuCustomeFrameSheet(
                                        context,
                                        imgUrl:
                                            "${AppConfig.URL_IMAGES_PATH}${item.menuPhoto}",
                                        productName: item.menuName!,
                                        description: item.menuDesc ?? '',
                                        price: item.menuPrice!,
                                        subTotal: item.subTotal!,
                                        likes: item.menuLikes.toString(),
                                        rate: item.menuRate.toString(),
                                        // count: item.selectedCount!,
                                        count: item.quantity!,
                                        sold: item.menuSolds ?? 0,
                                        innerContentSize: 110,
                                        variantSelected: null,
                                        total: subtotal,
                                        variantTypeList: item.variants!,
                                        onPressed: () {},
                                        onTapAdd: (Function updateState) {
                                          setState(() {
                                            selectedCount++;
                                            item.selectedCount = selectedCount;
                                          });
                                          updateState();
                                        },
                                        onTapRemove: (Function updateState) {
                                          if (selectedCount > 0) {
                                            setState(() {
                                              selectedCount--;
                                              item.selectedCount =
                                                  selectedCount;
                                            });
                                            updateState();
                                          }
                                        },
                                        onTapAddOrder: (selectedCount,
                                            calculatedTotal, selectedVariants) {
                                          setState(() {
                                            // Update UI if needed
                                          });
                                          updateCart(
                                            menuId: item.id!,
                                            quantity: selectedCount,
                                            variants: item.variants!
                                                .where((variant) =>
                                                    variant.selected!)
                                                .map((variant) => {
                                                      'variantId': variant.id,
                                                      'variantOptionIds': variant
                                                          .variantOptions!
                                                          .where((option) =>
                                                              option.selected!)
                                                          .map((option) =>
                                                              option.id)
                                                          .toList(),
                                                    })
                                                .toList(),
                                          );
                                        },
                                      );
                                    }
                                  : () {
                                      setState(() {
                                        item.selectedCount = item.quantity! + 1;
                                        // item.selectedCount! + 1;

                                        // item.subTotal =
                                        //     (item.menuPrice! * item.selectedCount!);
                                      });
                                      updateCart(
                                        menuId: item.id!,
                                        quantity: 1,
                                      );
                                      showToast(
                                          'Menu di tambahkan kedalam keranjang');
                                    },
                              onTapAdd: () {},
                              onTapRemove: () {},
                            );
                            // int selectedCount = item.selectedCount!;
                            // int price = item.menuPrice!;
                            // int subtotal = price * selectedCount;
                            // menuCustomeFrameSheet(
                            //   context,
                            //   imgUrl:
                            //       "${AppConfig.URL_IMAGES_PATH}${item.menuPhoto}",
                            //   productName: item.menuName!,
                            //   description: item.menuDesc ?? '',
                            //   price: item.menuPrice!,
                            //   subTotal: item.subTotal!,
                            //   likes: item.menuLikes.toString(),
                            //   rate: item.menuRate.toString(),
                            //   count: item.selectedCount!,
                            //   sold: item.menuSolds ?? 0,
                            //   innerContentSize: 110,
                            //   variantSelected: null,
                            //   total: subtotal,
                            //   variantTypeList: item.variants!,
                            //   onPressed: () {},
                            //   onTapAdd: (Function updateState) {
                            //     setState(() {
                            //       selectedCount++;
                            //       item.selectedCount = selectedCount;
                            //     });
                            //     updateState();
                            //   },
                            //   onTapRemove: (Function updateState) {
                            //     if (selectedCount > 0) {
                            //       setState(() {
                            //         selectedCount--;
                            //         item.selectedCount = selectedCount;
                            //       });
                            //       updateState();
                            //     }
                            //   },
                            //   onTapAddOrder: (selectedCount, calculatedTotal,
                            //       selectedVariants) {
                            //     setState(() {
                            //       // Update UI if needed
                            //     });
                            //     updateCart(
                            //       menuId: item.id!,
                            //       quantity: selectedCount,
                            //       variants: selectedVariants
                            //           .map((v) => {
                            //                 'variantId': v.id,
                            //                 'variantOptionIds': [v.id],
                            //               })
                            //           .toList(),
                            //     );
                            //   },
                            // );
                          } else {
                            if (item.quantity! < item.menuStock!) {
                              setState(() {
                                item.quantity = item.quantity! + 1;
                              });
                              updateCart(
                                menuId: item.id!,
                                quantity: 1,
                              );
                            } else {
                              showToast('Stok tidak mencukupi');
                            }
                          }
                        },
                        onTapRemove: () {
                          if (item.quantity! > 0) {
                            setState(() {
                              item.quantity = item.quantity! - 1;
                            });
                            updateCart(
                              menuId: item.id!,
                              quantity: -1,
                            );
                          }
                        },
                      ),
              );
            },
          ),
          const SizedBox(
            height: 150,
          )
        ],
      ),
    );
  }

  Widget actionButtonCustom({VoidCallback? onPressed, IconData? icons}) {
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
      ],
    );
  }

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
    return dataAddCartInfo == null
        ? Container()
        : AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            height: dataAddCartInfo != null ? 116 : 0,
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
                            subtitle: Text(
                              '${dataAddCartInfo?.totalMenus!} Menu | ${dataAddCartInfo?.totalItems!} Item',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: SizedBox(
                              width: 85,
                              child: FittedBox(
                                child: Text(
                                  'Rp${formatNumberWithThousandsSeparator(dataAddCartInfo!.totalPrices!)}',
                                  style: const TextStyle(
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
          itemCount: filteredMenuItems.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Menu item = filteredMenuItems[index];
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: widget.isOwner!
                  ? ProductCardBoxHorizontal(
                      onPressed: () {
                        log('product: ${item.menuName}');
                        menuFrameSheet(
                          context,
                          menuId: item.id!,
                          merchantId: dataMerchant?.merchantId!,
                          imgUrl:
                              "${AppConfig.URL_IMAGES_PATH}${item.menuPhoto}",
                          productName: item.menuName!,
                          description: item.menuDesc!,
                          price: item.menuPrice!,
                          likes: item.menuLikes!.toString(),
                          // count: item.selectedCount!.toString(),
                          count: item.quantity!.toString(),
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
                      isCustom: item.variants!.isNotEmpty ? true : false,
                      isOwner: widget.isOwner!,
                      onTapEditProduct: () {},
                    )
                  : ProductCardBoxHorizontal(
                      onPressed: () {
                        log('product: ${item.menuName}');
                        menuFrameSheet(
                          context,
                          menuId: item.id!,
                          merchantId: dataMerchant?.merchantId!,
                          imgUrl:
                              "${AppConfig.URL_IMAGES_PATH}${item.menuPhoto}",
                          productName: item.menuName!,
                          description: item.menuDesc!,
                          price: item.menuPrice!,
                          likes: item.menuLikes!.toString(),
                          // count: item.selectedCount!.toString(),
                          count: item.quantity!.toString(),
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
                          onPressed: () {
                            updateCart(
                              menuId: item.id!,
                              quantity: 1,
                            );
                          },
                          onTapAdd: () {},
                          onTapRemove: () {},
                        );
                      },
                      imgUrl: "${AppConfig.URL_IMAGES_PATH}${item.menuPhoto}",
                      productName: item.menuName!,
                      description: item.menuDesc ?? 'deskripsi menu',
                      price:
                          item.subTotal != 0 ? item.subTotal : item.menuPrice,
                      likes: item.menuLikes.toString(),
                      rate: item.menuRate.toString(),
                      // count: item.selectedCount!.toString(),
                      count: item.quantity!.toString(),
                      isCustom: item.variants!.isNotEmpty ? true : false,
                      onTapAdd: () async {
                        if (item.variants!.isNotEmpty) {
                          // int selectedCount = item.selectedCount!;
                          int selectedCount = item.quantity!;
                          int price = item.menuPrice!;
                          int subtotal = price * selectedCount;
                          menuCustomeFrameSheet(
                            context,
                            imgUrl:
                                "${AppConfig.URL_IMAGES_PATH}${item.menuPhoto}",
                            productName: item.menuName!,
                            description: item.menuDesc ?? '',
                            price: item.menuPrice!,
                            subTotal: item.subTotal!,
                            likes: item.menuLikes.toString(),
                            rate: item.menuRate.toString(),
                            // count: item.selectedCount!,
                            count: item.quantity!,
                            sold: item.menuSolds ?? 0,
                            innerContentSize: 110,
                            variantSelected: null,
                            total: subtotal,
                            variantTypeList: item.variants!,
                            onPressed: () {},
                            onTapAdd: (Function updateState) {
                              setState(() {
                                selectedCount++;
                              });
                              updateState();
                            },
                            onTapRemove: (Function updateState) {
                              if (selectedCount > 0) {
                                setState(() {
                                  selectedCount--;
                                });
                                updateState();
                              }
                            },
                            onTapAddOrder: (selectedCount, calculatedTotal,
                                selectedVariants) {
                              setState(() {
                                // Update UI if needed
                              });
                              updateCart(
                                menuId: item.id!,
                                quantity: selectedCount,
                                variants: item.variants!
                                    .where((variant) => variant.selected!)
                                    .map((variant) => {
                                          'variantId': variant.id,
                                          'variantOptionIds': variant
                                              .variantOptions!
                                              .where(
                                                  (option) => option.selected!)
                                              .map((option) => option.id)
                                              .toList(),
                                        })
                                    .toList(),
                              );
                            },
                          );
                        } else {
                          if (item.quantity! < item.menuStock!) {
                            setState(() {
                              item.quantity = item.quantity! + 1;
                              item.subTotal =
                                  (item.menuPrice! * item.quantity!);
                            });
                            updateCart(
                              menuId: item.id!,
                              quantity: item.quantity!,
                            );
                          } else {
                            // Show a message that stock limit has been reached
                            showToast('Stock tidak mencukupi');
                          }
                        }
                      },
                      onTapRemove: () {
                        if (item.quantity! > 0) {
                          setState(() {
                            item.quantity = item.quantity! - 1;
                            item.subTotal = (item.subTotal! - item.menuPrice!);
                          });
                          updateCart(
                            menuId: item.id!,
                            quantity: -item.quantity!,
                          );
                        }
                      },
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget searchBarStore() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: CTextField(
        controller: searchTextController,
        hintText: 'Jajan Apa hari ini?',
        borderColor: Warna.abu4,
        borderRadius: 58,
        maxLines: 1,
        textInputAction: TextInputAction.done,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
        prefixIcon: IconButton(
          onPressed: () {
            // Optionally, handle search button press here
          },
          padding: EdgeInsets.zero,
          iconSize: 15,
          color: Warna.biru,
          icon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
