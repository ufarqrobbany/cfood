import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/custom/page_item_void.dart';
import 'package:cfood/model/followed_response.dart';
import 'package:cfood/model/liked_response.dart';
// import 'package:cfood/model/get_all_menu_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/canteen.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String selectedTab = 'store';
  GetFollowedResponse? dataFollowedMerchants;
  List<DataFollowed>? dataFollowed;

  GetLikedResponse? dataLikedMenus;
  List<DataLiked>? dataLiked;

  ScrollController scrollController = ScrollController();
  int initialPage = 1;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    getAllMerchants();
    getAllMenus();
  }

  Future<void> getAllMerchants() async {
    dataFollowedMerchants = await FetchController(
      endpoint: 'merchants/followed?userId=${AppConfig.USER_ID}',
      fromJson: (json) => GetFollowedResponse.fromJson(json),
    ).getData();

    setState(() {
      dataFollowed = dataFollowedMerchants?.data!;
    });
  }

  Future<void> getAllMenus() async {
    dataLikedMenus = await FetchController(
      endpoint: 'menus/liked?userId=${AppConfig.USER_ID}',
      fromJson: (json) => GetLikedResponse.fromJson(json),
    ).getData();

    setState(() {
      dataLiked = dataLikedMenus?.data!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: backButtonCustom(context: context),
        title: const Text(
          'Favorit',
          style: AppTextStyles.title,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        // elevation: 2,
      ),
      backgroundColor: Warna.pageBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CTabButtons(
                      onPressed: () {
                        setState(() {
                          selectedTab = 'store';
                        });
                      },
                      selectedTab: selectedTab,
                      typeTab: 'store',
                      text: 'Kantin & Wirausaha',
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: CTabButtons(
                      onPressed: () {
                        setState(() {
                          selectedTab = 'menu';
                        });
                      },
                      selectedTab: selectedTab,
                      typeTab: 'menu',
                      text: 'Menu',
                    ),
                  )
                ],
              ),
            ),
            selectedTab == 'store' ? storeBody() : menuBody(),
          ],
        ),
      ),
    );
  }

  Widget storeBody() {
    return dataFollowedMerchants == null
        ? Container()
        : dataFollowed!.isEmpty
            ? itemsEmptyBody(context, bgcolors: Warna.pageBackgroundColor)
            : ListView.builder(
                itemCount: dataFollowed?.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(25, 15, 25, 40),
                itemBuilder: (context, index) {
                  DataFollowed? items = dataFollowed?[index];
                  return Container(
                    // margin: const EdgeInsets.only(top: 25, bottom: 10, left: 25, right: 25),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CanteenCardBox(
                      imgUrl:
                          '${AppConfig.URL_IMAGES_PATH}${items?.merchantPhoto}',
                      canteenName: items?.merchantName,
                      // menuList: 'kosong',
                      open: items!.open!,
                      likes: ' ${items.followers}',
                      rate: '${items.rating}',
                      type: items.merchantType,
                      danus: items.danus!,
                      onPressed: () => navigateTo(
                          context,
                          CanteenScreen(
                            merchantId: items.merchantId,
                            isOwner: false,
                            merchantType: items.merchantType!,
                            itsDanusan: items.danus,
                          )),
                    ),
                  );
                },
              );
  }

  Widget menuBody() {
    return dataLikedMenus == null
        ? Container()
        : dataLiked!.isEmpty
            ? itemsEmptyBody(context, bgcolors: Warna.pageBackgroundColor)
            : MasonryGridView.count(
                itemCount: dataLiked?.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                itemBuilder: (context, index) {
                  DataLiked? items = dataLiked?[index];
                  return ProductCardBox(
                      onPressed: () {
                        navigateTo(
                          context,
                          CanteenScreen(
                              menuId: '${items?.menuId}',
                              merchantId: items?.merchants!.merchantId!,
                              merchantType: items!.merchants!.merchantType!),
                        );
                      },
                      imgUrl: '${AppConfig.URL_IMAGES_PATH}${items?.menuPhoto}',
                      productName: '${items?.menuName}',
                      storeName: '${items?.merchants?.merchantName}',
                      price: items?.menuPrice,
                      likes: '${items?.menuLikes}',
                      rate: '${items?.menuRating}',
                      merchantType: '${items?.merchants?.merchantType}',
                      isDanus: items?.menuIsDanus!);
                },
              );
  }
}
