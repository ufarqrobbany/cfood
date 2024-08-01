import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/getl_all_merchant_response.dart';
import 'package:cfood/model/get_all_menu_response.dart';
import 'package:cfood/model/get_all_organization_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/canteen.dart';
import 'package:cfood/screens/favorite.dart';
import 'package:cfood/screens/inbox.dart';
import 'package:cfood/screens/organization.dart';
import 'package:cfood/screens/search.dart';
import 'package:cfood/screens/seeAll.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _mainScrollController = ScrollController();
  String nama_user = '';
  String first_name = '';

  GetAllMerchantsResponse? dataMerchantsResponse;
  DataGetMerchant? dataMerchants;
  MerchantItems? merchantListItems;

  GetAllOrganizationsResponse? dataOrganizationsResponse;
  DataGetOrganization? dataOrganizations;
  OrganizationItems? organizationListItems;

  MenusResponse? dataMenusResponse;
  DataGetMenu? dataMenus;

  @override
  void initState() {
    super.initState();

    if (dataMenusResponse == null) {
      log('load all menus');
      getAllMenus(context);
    }

    if (dataOrganizationsResponse == null) {
      log('load all organizations');
      getAllOrganizations(context);
    }

    if (dataMerchantsResponse == null) {
      log('load all merchants');
      getAllMerchants(context);
    }

    setState(() {
      nama_user = AppConfig.NAME;
      // first_name = nama_user.split(' ')[0];
      first_name = nama_user != ''
          ? nama_user.split(' ')[0]
          : _capitalizeFirstLetter(AppConfig.EMAIL.split('.')[0]);
    });
  }

  String _capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 10));

    print('reload...');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getAllMenus(BuildContext context) async {
    dataMenusResponse = await FetchController(
      endpoint: 'menus/?page=1&size=5',
      fromJson: (json) => MenusResponse.fromJson(json),
    ).getData();

    setState(() {
      dataMenus = dataMenusResponse?.data;
      log(dataMenus.toString());
    });
  }

  Future<void> getAllOrganizations(BuildContext context) async {
    dataOrganizationsResponse = await FetchController(
      endpoint: 'organizations/?campusId=1&page=1&size=5&name',
      fromJson: (json) => GetAllOrganizationsResponse.fromJson(json),
    ).getData();

    setState(() {
      dataOrganizations = dataOrganizationsResponse?.data;
      log(dataOrganizations.toString());
    });
  }

  Future<void> getAllMerchants(BuildContext context) async {
    dataMerchantsResponse = await FetchController(
      endpoint: 'merchants/all?page=1&size=10&type=all&isOpen=all&searchName=',
      fromJson: (json) => GetAllMerchantsResponse.fromJson(json),
    ).getData();

    setState(() {
      dataMerchants = dataMerchantsResponse?.data;
      log(dataMerchants.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.pageBackgroundColor,
      body: ReloadIndicatorType1(
        onRefresh: refreshPage,
        child: CustomScrollView(
          controller: _mainScrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverLayoutBuilder(builder: (context, constraints) {
              // print(constraints.scrollOffset);
              final scrolled = constraints.scrollOffset > 0.0;
              final moveLocationBox = constraints.scrollOffset > 80.0;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.bounceOut,
                child: SliverAppBar(
                  leadingWidth: 10,
                  leading: Container(),
                  pinned: true,
                  stretch: true,
                  title: moveLocationBox
                      ? SizedBox(height: 40, child: boxLocation())
                      : Text(
                          'Hai, $first_name',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                  // NOTIF BUTTONS
                  actions: [
                    notifIconButton(
                      icons: UIcons.solidRounded.bell,
                      notifCount: '22',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    notifIconButton(
                      icons: UIcons.solidRounded.comment,
                      notifCount: '5',
                      onPressed: () => navigateTo(
                          context,
                          InboxScreen(
                            canBack: true,
                          )),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                  onStretchTrigger: () {
                    return Future<void>.value();
                  },
                  // changeble background
                  backgroundColor:
                      scrolled ? Warna.biru : Warna.pageBackgroundColor,
                  // Bottom Appbar show when page scroll
                  bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(60),
                      child: Container(
                        color: Warna.biru,
                      )),

                  // Flexible SpaceBar
                  expandedHeight: 255,
                  // expandedHeight: 245,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                      // StretchMode.fadeTitle,
                    ],
                    centerTitle: true,
                    expandedTitleScale: 1.0,
                    titlePadding: const EdgeInsets.symmetric(horizontal: 25),
                    title: InkWell(
                      onTap: () {
                        print('go to search page');
                        navigateTo(context, const SearchScreen());
                      },
                      borderRadius: BorderRadius.circular(58),
                      focusColor: Warna.abu,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: 50,
                        margin: scrolled
                            ? const EdgeInsets.only(bottom: 10, top: 15)
                            : const EdgeInsets.only(bottom: 20, top: 15),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(58),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                  color: Warna.shadow.withOpacity(0.12),
                                  offset: const Offset(0, 0))
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.search,
                              size: 18,
                              color: Warna.biru,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Jajan apa hari ini?',
                              style: AppTextStyles.placeholderInput,
                            )
                          ],
                        ),
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 45),
                          color: Warna.pageBackgroundColor,
                          child: Image.asset(
                            'assets/header_image.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 45),
                          decoration: BoxDecoration(
                              color: Warna.biru.withOpacity(0.80)),
                        ),

                        // WELCOME WIDGETS
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 40),
                                constraints: const BoxConstraints(
                                  maxWidth: 280,
                                  minWidth: 280,
                                ),
                                // child: const Text(
                                //   'Hai, AhmadHammamMUhajirHanan',
                                //   style: TextStyle(
                                //     fontSize: 26,
                                //     fontWeight: FontWeight.w700,
                                //     color: Colors.white,
                                //     overflow: TextOverflow.ellipsis,
                                //   ),
                                // ),
                              ),
                              // const SizedBox(height: 80,),
                              const Spacer(),
                              const Text(
                                'Kirim ke:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              moveLocationBox ? Container() : boxLocation(),

                              const SizedBox(
                                height: 90,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),

            // BODY CONTENT
            SliverList(
              delegate: SliverChildListDelegate([homeContents()]),
            ),
          ],
        ),
      ),
    );
  }

  Widget boxLocation() {
    return FittedBox(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            backgroundColor: Colors.white.withOpacity(0.20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(51),
            ),
          ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                UIcons.solidRounded.marker,
                color: Warna.kuning,
                size: 16,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'POLBAN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          )),
    );
  }

  Widget homeContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        // Carousel Addsenses

        // Category
        SizedBox(
          height: 160,
          // margin: EdgeInsets.symmetric(vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CategoryCardBox(
                  onTap: () => navigateTo(
                    context,
                    const SeeAllItemsScreen(
                      typeName: 'Wirausaha',
                      typeCode: 'wirausaha',
                    ),
                  ),
                  icons: CommunityMaterialIcons.handshake,
                  iconColors: Warna.kuning,
                  text: 'Wirausaha',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CategoryCardBox(
                  onTap: () => navigateTo(
                    context,
                    const SeeAllItemsScreen(
                      typeName: 'Kantin',
                      typeCode: 'kantin',
                    ),
                  ),
                  icons: Icons.store,
                  iconColors: Warna.biru,
                  text: 'Kantin',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CategoryCardBox(
                  onTap: () => navigateTo(
                    context,
                    const FavoriteScreen(),
                  ),
                  // onTap: () => context.go('/favorite'),
                  icons: Icons.favorite,
                  iconColors: Warna.like,
                  text: 'Favorit',
                ),
              ),
            ],
          ),
        ),

        // Recomendation
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            'Rekomendasi hari ini🔥',
            style: AppTextStyles.subTitle,
            textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          // lagi di bikin
          height: 315,
          child: dataMenus?.content == null
              ? Container()
              : ListView.builder(
                  itemCount: dataMenus?.content!.length,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemBuilder: (context, index) {
                    MenuItems? items = dataMenus?.content![index];
                    return Container(
                      margin: const EdgeInsets.only(top: 24, bottom: 40),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ProductCardBox(
                          onPressed: () {
                            navigateTo(
                              context,
                              CanteenScreen(
                                  menuId: '${items?.menuId}',
                                  merchantId: items?.merchants!.merchantId!,
                                  merchantType:
                                      items!.merchants!.merchantType!),
                            );
                          },
                          imgUrl:
                              '${AppConfig.URL_IMAGES_PATH}${items?.menuPhoto}',
                          productName: '${items?.menuName}',
                          storeName: '${items?.merchants?.merchantName}',
                          price: items?.menuPrice,
                          likes: '${items?.menuLikes}',
                          rate: '${items?.menuRating}',
                          merchantType: '${items?.merchants?.merchantType}',
                          isDanus: items?.menuIsDanus!),
                    );
                  },
                ),
        ),

        // Pre-Order
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 25),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       const Text(
        //         'Pre-order Sekarang ',
        //         style: AppTextStyles.subTitle,
        //         textAlign: TextAlign.left,
        //       ),
        //       CYellowMoreButton(
        //           onPressed: () => navigateTo(
        //                 context,
        //                 const SeeAllItemsScreen(
        //                   typeName: 'Pre-Order',
        //                   typeCode: 'pre-order',
        //                 ),
        //               ),
        //           text: 'Lihat Semua'),
        //     ],
        //   ),
        // ),
        // SizedBox(
        //   height: 315,
        //   child: ListView.builder(
        //     itemCount: 10,
        //     physics: const BouncingScrollPhysics(),
        //     scrollDirection: Axis.horizontal,
        //     padding: const EdgeInsets.symmetric(horizontal: 15),
        //     itemBuilder: (context, index) {
        //       return Container(
        //         margin: const EdgeInsets.only(top: 24, bottom: 40),
        //         padding: const EdgeInsets.symmetric(horizontal: 10),
        //         child: ProductCardBox(
        //           onPressed: () {
        //             navigateTo(
        //               context,
        //               const CanteenScreen(
        //                 menuId: '0',
        //                 merchantId: 1,
        //               ),
        //             );
        //           },
        //           productName: '[Nama Menu]',
        //           storeName: '[Nama Toko]',
        //           price: 100000,
        //           likes: '100',
        //           rate: '4.5',
        //         ),
        //       );
        //     },
        //   ),
        // ),

        // SUMBANGAN DANA BANtu Usaha
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bantu Dana Usaha',
                style: AppTextStyles.subTitle,
                textAlign: TextAlign.left,
              ),
              CYellowMoreButton(
                  onPressed: () => navigateTo(
                        context,
                        const SeeAllItemsScreen(
                          typeName: 'Organisasi',
                          typeCode: 'organisasi',
                        ),
                      ),
                  text: 'Lihat Semua'),
            ],
          ),
        ),
        SizedBox(
          height: 224,
          child: dataOrganizations?.organizations == null
              ? Container()
              : ListView.builder(
                  itemCount: dataOrganizations?.organizations!.length,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemExtent: 180,
                  shrinkWrap: true,
                  // lagi di bikin
                  itemBuilder: (context, index) {
                    OrganizationItems? items =
                        dataOrganizations?.organizations![index];
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 24, bottom: 40),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: OrganizationCard(
                        text: items?.organizationName!,
                        imgUrl:
                            '${AppConfig.URL_IMAGES_PATH}${items?.organizationLogo}',
                        onPressed: () => navigateTo(
                          context,
                          OrganizationScreen(id: items?.id),
                        ),
                      ),
                    );
                  },
                ),
        ),

        // Kantin dan Wirausaga
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            'Kantin Dan Wirausaha',
            style: AppTextStyles.subTitle,
            textAlign: TextAlign.left,
          ),
        ),
        dataMerchants?.merchants == null
            ? Container()
            : ListView.builder(
                itemCount: dataMerchants?.merchants?.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(25, 15, 25, 40),
                itemBuilder: (context, index) {
                  MerchantItems? items = dataMerchants?.merchants![index];
                  return Container(
                    // margin: const EdgeInsets.only(top: 25, bottom: 10, left: 25, right: 25),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CanteenCardBox(
                      imgUrl:
                          '${AppConfig.URL_IMAGES_PATH}${items?.merchantPhoto}',
                      canteenName: items?.merchantName,
                      // menuList: 'kosong',
                      // likes: ' 0',
                      likes: ' ${items?.followers}',
                      rate: '${items?.rating}',
                      type: items?.merchantType,
                      open: items!.open!,
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
              ),

        const SizedBox(
          height: 100,
        )
      ],
    );
  }
}
