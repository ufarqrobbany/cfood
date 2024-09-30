import 'dart:developer';

import 'package:cfood/custom/CBottomSheet.dart';
import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/custom/page_item_void.dart';
import 'package:cfood/custom/popup_dialog.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/add_cart_response.dart';
import 'package:cfood/model/get_cart_user_response.dart';
import 'package:cfood/model/reponse_handler.dart';
import 'package:cfood/model/update_cartitem_response.dart';
import 'package:cfood/model/get_calculate_cart_response.dart';
import 'package:cfood/model/delete_cart_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/model/post_menu_like_response.dart';
import 'package:cfood/model/post_menu_unlike_response.dart';
import 'package:cfood/screens/canteen.dart';
import 'package:cfood/screens/order_confirm.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/common.dart';
import 'package:cfood/utils/constant.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:uicons/uicons.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool menuOrderCountInfo = true;
  List<Map<String, dynamic>> cartListItems = [];

  CartResponse? cartResponse;
  List<CartData>? cartData;

  CalculateCartResponse? calculateCartResponse;
  CalculateCartData? calculateCartData;

  DeleteCartResponse? deleteCartResponse;
  bool? deleteCartData;

  UpdateCartItemResponse? updateCartItemResponse;
  UpdateCartItemData? updateCartItemData;

  int? selectCartId;

  @override
  void initState() {
    super.initState();
    getAllCarts();
  }

  void getSpecificMenu(int cartId, CartItem item, int merchantId) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        menuFrameSheet(
          context,
          menuId: item.detailMenu.id,
          merchantId: merchantId,
          imgUrl: "${AppConfig.URL_IMAGES_PATH}${item.detailMenu.menuPhoto}",
          productName: item.detailMenu.menuName,
          description: item.detailMenu.menuDesc,
          price: item.detailMenu.menuPrice,
          likes: item.detailMenu.likes.toString(),
          sold: item.solds,
          rate: item.detailMenu.rating.toString(),
          innerContentSize: 110,
          isLike: item.detailMenu.isLike!,
          onTapLike: (updateState) {
            tapLikeMenu(context,
                isLike: item.detailMenu.isLike!,
                menuId: item.detailMenu.id!,
                updateState: updateState,
                menuItem: item.detailMenu);
          },
          onPressed: () {
            if (item.detailMenu.variants!.isEmpty) {
              if (item.quantity < item.detailMenu.menuStock!) {
                updateCartItem(item.cartItemId, "add", cartId);
                Navigator.pop(context);
              } else {
                showToast('Stok tidak mencukupi');
              }
            } else {
              Navigator.pop(context);
              int selectedCount = 0;
              int price = item.detailMenu.menuPrice!;
              int subtotal = price;
              // List<Variant> variantTypeList;
              menuCustomeFrameSheet(
                context,
                imgUrl:
                    "${AppConfig.URL_IMAGES_PATH}${item.detailMenu.menuPhoto}",
                productName: item.detailMenu.menuName!,
                description: item.detailMenu.menuDesc!,
                price: item.detailMenu.menuPrice!,
                stock: item.detailMenu.menuStock!,
                quantity: item.totalQuantity,
                likes: item.detailMenu.likes.toString(),
                rate: item.detailMenu.rating.toString(),
                count: selectedCount,
                sold: item.solds,
                innerContentSize: 110,
                variantSelected: null,
                total: subtotal,
                variantTypeList: item.detailMenu.variants!,
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
                      menuId: item.detailMenu.id!,
                      quantity: selectedCount,
                      variants: item.detailMenu.variants!
                          .where((variant) => variant.selected!)
                          .map((variant) => {
                                'variantId': variant.id,
                                'variantOptionIds': variant.variantOptions!
                                    .where((option) => option.selected!)
                                    .map((option) => option.id)
                                    .toList(),
                              })
                          .toList(),
                      merchantId: merchantId);
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

  Future<void> updateCart(
      {required int menuId,
      required int quantity,
      List<Map<String, dynamic>>? variants,
      required int merchantId}) async {
    AddCartResponse? info = await FetchController(
      endpoint: 'carts/add',
      fromJson: (json) => AddCartResponse.fromJson(json),
    ).postData({
      'userId': AppConfig.USER_ID,
      'merchantId': merchantId,
      'menuId': menuId,
      'quantity': quantity, // positif untuk tambah, negatif untuk kurangi
      'variants': variants ?? [],
    });

    log({
      'userId': AppConfig.USER_ID,
      'merchantId': merchantId,
      'menuId': menuId,
      'quantity': quantity, // positif untuk tambah, negatif untuk kurangi
      'variants': variants ?? [],
    }.toString());

    if (info != null) {
      setState(() {
        getAllCarts();
      });
    }
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
      updateState != null
          ? (() {
              isLike = true;
              menuItem!.isLike = isLike;
            })
          : ();
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
      updateState != null
          ? (() {
              isLike = false;
              menuItem!.isLike = isLike;
            })
          : ();
      log('tap unlike menu');
    } else {
      // Handle error here
      log('Failed to unlike menu');
      showToast('Gagal Tidak Menyukai Menu');
    }
  }

  Future<void> deleteCart(int cartId) async {
    deleteCartResponse = await FetchController(
      endpoint: 'carts/$cartId',
      fromJson: (json) => DeleteCartResponse.fromJson(json),
    ).deleteData();

    setState(() {
      deleteCartData = deleteCartResponse?.data;
      log(deleteCartData.toString());
      if (selectCartId == cartId) {
        selectCartId = -1;
      }
      getAllCarts();
    });
  }

  String getVariantDescription(List<dynamic> variants) {
    if (variants.isEmpty) {
      return '';
    }

    List<String> variantOptionNames = [];

    for (var variant in variants) {
      for (var option in variant.variantOptions) {
        variantOptionNames.add(option.variantOptionName);
      }
    }

    return variantOptionNames.join(", ");
  }

  Future<void> getAllCarts() async {
    cartResponse = await FetchController(
      endpoint: 'carts/new/user/${AppConfig.USER_ID}',
      fromJson: (json) => CartResponse.fromJson(json),
    ).getData();

    setState(() {
      cartData = cartResponse?.data;
      log(cartData.toString());
    });
  }

  Future<void> getCalculateCart(int cartId) async {
    calculateCartResponse = await FetchController(
      endpoint: 'carts/calculate/$cartId',
      fromJson: (json) => CalculateCartResponse.fromJson(json),
    ).getData();

    setState(() {
      calculateCartData = calculateCartResponse?.data;
      log(calculateCartData.toString());
    });
  }

  Future<void> updateCartItem(int cartItemId, String type, int cartId) async {
    updateCartItemResponse = await FetchController(
      endpoint: 'carts/item/$cartItemId?quantity=${type == "add" ? 1 : -1}',
      fromJson: (json) => UpdateCartItemResponse.fromJson(json),
    ).putData({});

    setState(() {
      updateCartItemData = updateCartItemResponse?.data;
      log(updateCartItemData.toString());
      getAllCarts();
      if (cartId == selectCartId) {
        getCalculateCart(cartId);
      }
    });
  }

  Future<void> getCartQuantityCheck() async {
    ResponseHendlerDataBool response = await FetchController(
      endpoint: 'carts/check-quantity?cartId=$selectCartId',
      fromJson: (json) => ResponseHendlerDataBool.fromJson(json),
    ).getData();

    log(response.data.toString());
    if (response.data == true) {
      navigateTo(
          context,
          OrderConfirmScreen(
            cartId: selectCartId,
          ));
    } else {
      showToast('stok pada menu yg dipilih tidak mencukupi!!');
    }
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 3));

    print('reload...');
    getAllCarts();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          width: 0,
        ),
        leadingWidth: 20,
        title: const Text(
          'Keranjang',
          style: AppTextStyles.title,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        actions: [
          notifIconButton(
            icons: UIcons.solidRounded.comment,
            onPressed: () {},
            iconColor: Warna.regulerFontColor,
            notifCount: '7',
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      backgroundColor: cartResponse == null || cartData!.isEmpty
          ? Colors.white
          : Warna.pageBackgroundColor,
      body: cartBodyList(),
      floatingActionButton:
          (calculateCartResponse == null || selectCartId == -1)
              ? Container()
              : storeMenuCountInfo(
                  calculateCartData!.cartId,
                  calculateCartData!.totalMenus,
                  calculateCartData!.totalItems,
                  calculateCartData!.totalPrices),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  Widget cartBodyList() {
    return cartResponse == null
        ? pageOnLoading(context)
        : cartData!.isEmpty
            ? itemsEmptyBody(context,
                bgcolors: Colors.white,
                icons: UIcons.solidRounded.shopping_cart,
                iconsColor: Warna.kuning,
                text: 'Keranjang Kamu masih kosong\nayo tambah yang banyak!')
            : ReloadIndicatorType1(
                onRefresh: refreshPage,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ListView.builder(
                    itemCount: cartData?.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var store = cartData?[index];

                      return Container(
                        margin: index == cartData!.length - 1
                            ? const EdgeInsets.only(bottom: 180)
                            : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Warna.abu5,
                              width: 14,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 20, 25, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        log('Cart selected: ${store.merchantName}');
                                        setState(() {
                                          if (store.isOpen) {
                                            selectCartId = store.cartId;
                                            getCalculateCart(selectCartId!);
                                          }
                                        });
                                      },

                                      // bookmark
                                      child: store!.isOpen
                                          ? Icon(
                                              selectCartId == store.cartId
                                                  ? Icons
                                                      .radio_button_checked_rounded
                                                  : Icons
                                                      .radio_button_unchecked,
                                              color: Warna.biru,
                                              size: 25,
                                            )
                                          : Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 1),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                    color: Warna.like,
                                                    width: 1),
                                                color: Warna.like
                                                    .withOpacity(0.10),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    UIcons.solidRounded
                                                        .time_oclock,
                                                    size: 13,
                                                    color: Warna.like,
                                                  ),
                                                  Text(
                                                    ' Tutup',
                                                    style: TextStyle(
                                                        color: Warna.like,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () => navigateTo(
                                          context,
                                          CanteenScreen(
                                            merchantId: store.merchantId,
                                            isOwner: false,
                                            merchantType: store.merchantType,
                                          )),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            store.merchantType == "WIRAUSAHA"
                                                ? CommunityMaterialIcons
                                                    .handshake
                                                : Icons.store,
                                            color: store.merchantType ==
                                                    "WIRAUSAHA"
                                                ? Warna.kuning
                                                : Warna.biru,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Flexible(
                                            child: Text(
                                              store.merchantName,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        // context.pushReplacementNamed('main');
                                        showMyCustomDialog(context,
                                            text:
                                                'Apakah Anda yakin untuk menghapus keranjang ini?\n',
                                            colorYes: Warna.like, onTapYes: () {
                                          navigateBack(context);
                                          deleteCart(store.cartId);
                                        });
                                      },
                                      child: Icon(
                                        UIcons.solidRounded.trash,
                                        color: Warna.like,
                                        size: 25,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                              itemCount: store.items.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, idxMenu) {
                                var menuItem = store.items[idxMenu];
                                return Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                  ),
                                  child: ProductCardBoxHorizontal(
                                    innerContentSize: 90,
                                    onPressed: () {
                                      getSpecificMenu(store.cartId, menuItem,
                                          store.merchantId);
                                    },
                                    imgUrl:
                                        '${AppConfig.URL_IMAGES_PATH}${menuItem.detailMenu.menuPhoto}',
                                    productName: menuItem.detailMenu.menuName,
                                    description: menuItem.cartVariants.isEmpty
                                        ? ''
                                        : getVariantDescription(
                                            menuItem.cartVariants),
                                    price: menuItem.totalPriceItem *
                                        menuItem.quantity,
                                    count: menuItem.quantity.toString(),
                                    isDanus: menuItem.detailMenu.isDanus!,
                                    onTapAdd: () {
                                      if (menuItem.totalQuantity <
                                          menuItem.stock) {
                                        updateCartItem(menuItem.cartItemId,
                                            "add", store.cartId);
                                      } else {
                                        showToast('Stok tidak mencukupi');
                                      }
                                    },
                                    onTapRemove: () {
                                      if (menuItem.quantity > 1) {
                                        updateCartItem(menuItem.cartItemId,
                                            "reduce", store.cartId);
                                      } else {
                                        // showDialog(context: context, builder: builder)
                                        showMyCustomDialog(context,
                                            text:
                                                'Apakah Anda yakin untuk menghapus menu ini di keranjang?\n',
                                            colorYes: Warna.like, onTapYes: () {
                                          navigateBack(context);
                                          updateCartItem(menuItem.cartItemId,
                                              "reduce", store.cartId);
                                          // deleteCart(store!.cartId);
                                        });
                                      }
                                    },
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
  }

  Widget storeMenuCountInfo(
      int cartId, int totalMenu, int totalItem, int totalPrice) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      height: menuOrderCountInfo ? 116 : 0,
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      margin: menuOrderCountInfo
          ? const EdgeInsets.only(bottom: 80)
          : EdgeInsets.zero,
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
              flex: 8,
              child: Container(
                color: Warna.biru,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListTile(
                      onTap: () {
                        // tambahkan logic pengecekan quantity

                        getCartQuantityCheck();
                      },
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
                        '$totalMenu Menu | $totalItem Item',
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
                            '${Constant.currencyCode}${formatNumberWithThousandsSeparator(totalPrice)}',
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
}
