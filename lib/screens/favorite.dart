import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/custom/page_item_void.dart';
import 'package:cfood/model/followed_response.dart';
import 'package:cfood/model/getl_all_merchant_response.dart';
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
  // GetAllMerchantsResponse? dataMerchantsResponse;
  // DataGetMerchant? dataMerchants;
  // MerchantItems? merchantListItems;
  GetFollowedResponse? dataFollowedMerchants;
  List<DataFollowed>? dataFollowed;

  @override
  void initState() {
    super.initState();
    getAllMerchants();
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
        : dataFollowed?.length == 0
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
                      likes: ' ${items?.followers}',
                      rate: '${items?.rating}',
                      type: items?.merchantType,
                      onPressed: () => navigateTo(
                          context,
                          CanteenScreen(
                            merchantId: items?.merchantId,
                            isOwner: false,
                            merchantType: items!.merchantType!,
                            itsDanusan: items.danus,
                          )),
                    ),
                  );
                },
              );
  }

  Widget menuBody() {
    return MasonryGridView.count(
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      itemBuilder: (context, index) {
        return const ProductCardBox(
          productName: '[Nama Menu]',
          storeName: '[Nama Toko]',
          price: '10.000',
          likes: '100',
          rate: '4.5',
        );
      },
    );
  }
}
