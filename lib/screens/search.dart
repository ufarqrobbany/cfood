import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/custom/page_item_void.dart';
import 'package:cfood/model/get_all_menu_response.dart';
import 'package:cfood/model/get_all_organization_response.dart';
import 'package:cfood/model/getl_all_merchant_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/canteen.dart';
import 'package:cfood/screens/organization.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  final int campusId;
  const SearchScreen({
    super.key,
    this.campusId = 0,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextController = TextEditingController();
  ScrollController onSearchScrollController = ScrollController();
  ScrollController searchResultScrollController = ScrollController();
  bool searchDone = false;
  String selectedTab = 'menu';

  GetAllMerchantsResponse? dataMerchantsResponse;
  DataGetMerchant? dataMerchants;
  MerchantItems? merchantListItems;

  GetAllOrganizationsResponse? dataOrganizationsResponse;
  DataGetOrganization? dataOrganizations;
  OrganizationItems? organizationListItems;

  MenusResponse? dataMenusResponse;
  DataGetMenu? dataMenus;

  final List<String> riwayat = [
    'ayam geprek',
    'tahu',
    'nasi padang',
    'gehu',
    'es krim',
    'martabak'
  ];
  final List<String> pencarianPopuler = [
    'gehu',
    'es krim',
    'martabak',
    'ayam geprek',
    'tahu',
    'nasi padang',
  ];

  final List<String> listSearcMenu = [
    'gehu',
    'es krim',
    'martabak',
    'ayam geprek',
    'tahu',
    'nasi padang',
    'nasi goreng',
    'roti bakar',
    'cimol',
    'cilok'
  ];

  List<String> _filteredSeacrhList = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();

    // searchTextController.addListener(_filterSearch);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void selectTabs(tab) {
    setState(() {
      selectedTab = tab;
    });
    log(selectedTab);
    searchItemsBy(context, query: searchTextController.text);
  }

  void _filterSearch() {
    String query = searchTextController.text.toLowerCase();
    searchDone = false;
    print('Query: $query');
    if (query.isNotEmpty) {
      List<String> filteredList = listSearcMenu.where((campus) {
        return campus.toLowerCase().contains(query);
      }).toList();

      filteredList.sort((a, b) {
        int indexA = a.toLowerCase().indexOf(query);
        int indexB = b.toLowerCase().indexOf(query);
        return indexA.compareTo(indexB);
      });

      setState(() {
        _filteredSeacrhList = filteredList;
        _showSuggestions = true;
      });
      print('Filtered List: $_filteredSeacrhList');
    } else {
      setState(() {
        _filteredSeacrhList = [];
        _showSuggestions = false;
      });
      print('Filtered List cleared');
    }
  }

  void searchItemsBy(BuildContext context, {String query = ''}) {
    log('$query -- $selectedTab');
    if (selectedTab == 'menu') {
      getAllMenus(context, query: query);
      return;
    }

    if (selectedTab == 'wirausaha') {
      getAllMerchants(context, query: query);
      return;
    }

    if (selectedTab == 'organisasi') {
      getAllOrganizations(context, query: query);
      return;
    }
  }

  Future<void> getAllMenus(BuildContext context, {String query = ''}) async {
    dataMenusResponse = await FetchController(
      endpoint: 'menus/?page=1&size=50&searchName=$query',
      fromJson: (json) => MenusResponse.fromJson(json),
    ).getData();

    setState(() {
      dataMenus = dataMenusResponse?.data;
      log(dataMenus.toString());
    });
  }

  Future<void> getAllOrganizations(BuildContext context,
      {String query = ''}) async {
    dataOrganizationsResponse = await FetchController(
      endpoint: 'organizations/?campusId=${widget.campusId}&page=1&size=50&name=$query',
      // endpoint: 'organizations/?campusId=${widget.campusId}&name=$query',
      fromJson: (json) => GetAllOrganizationsResponse.fromJson(json),
    ).getData();

    setState(() {
      dataOrganizations = dataOrganizationsResponse?.data;
      log(dataOrganizations.toString());
    });
  }

  Future<void> getAllMerchants(BuildContext context,
      {String query = ''}) async {
    dataMerchantsResponse = await FetchController(
      endpoint:
          'merchants/all?page=1&size=50&type=all&isOpen=all&searchName=$query',
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
      appBar: AppBar(
        leadingWidth: 90,
        leading: backButtonCustom(context: context),
        title: const Text(
          'Pencarian',
          style: AppTextStyles.title,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        forceMaterialTransparency: false,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
            // preferredSize: const Size.fromHeight(80),
            preferredSize: searchDone
                ? const Size.fromHeight(130)
                : const Size.fromHeight(80),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    // height: 80,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    child: CTextField(
                      controller: searchTextController,
                      hintText: 'Jajan Apa hari ini?',
                      borderColor: Warna.abu4,
                      borderRadius: 58,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (p0) {
                        setState(() {
                          searchDone = true;
                        });
                      },
                      onChanged: (p0) {
                        // _filterSearch();
                        searchItemsBy(context, query: p0);
                        setState(() {
                          searchDone = true;
                        });
                        // if(searchTextController.text.isNotEmpty) {
                        //   setState(() {
                        //     _showSuggestions = !_showSuggestions;
                        //   });
                        // }
                      },
                      prefixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              searchDone = !searchDone;
                            });
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
                    )),
                searchDone
                    ? tabMenuItemsList()
                    : Container(
                        height: 0,
                      ),
              ],
            )),
      ),
      backgroundColor: searchDone ? Warna.pageBackgroundColor : Colors.white,
      body: searchDone ? searchResultBody() : onSearchBody(),
    );
  }

  Widget onSearchResultItemsSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Text(
            'Hasil Pencarian',
            style: AppTextStyles.subTitle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            children: [
              for (var item in _filteredSeacrhList)
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: searchItemBox(
                    onPressed: () {
                      setState(() {
                        searchDone = true;
                      });
                    },
                    text: item,
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget onSearchBody() {
    return SingleChildScrollView(
      controller: onSearchScrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (_showSuggestions && searchTextController.text.isNotEmpty)
          //     onSearchResultItemsSelection(),

          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          //   child: Text(
          //     'Riwayat',
          //     style: AppTextStyles.subTitle,
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Wrap(
          //     children: [
          //       for (var item in riwayat)
          //         Padding(
          //           padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          //           child: searchItemBox(
          //             onPressed: () {},
          //             text: item,
          //           ),
          //         )
          //     ],
          //   ),
          // ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Text(
              'Pencarian Populer',
              style: AppTextStyles.subTitle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              children: [
                for (var item in pencarianPopuler)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: searchItemBox(
                      onPressed: () {
                        setState(() {
                          searchTextController.text = item;
                          searchDone = true;
                        });
                        searchItemsBy(
                          context,
                          query: searchTextController.text,
                        );
                      },
                      text: item,
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchResultBody() {
    return SingleChildScrollView(
      controller: searchResultScrollController,
      physics: const BouncingScrollPhysics(),
      child: searchResultsBodyItems(selectedTab),
    );
  }

  Widget searchResultsBodyItems(String? selectedTab) {
    if (selectedTab == null) {
      // If selectedTab is null, return an empty container, shimmer, or error message
      return Container(); // Replace with your shimmer or error message widget
    } else {
      // If selectedTab is not null, check its value and return the corresponding widget
      if (selectedTab == 'menu') {
        return dataMenus?.content == null
            ? itemsEmptyBody(context,
                bgcolors: Warna.pageBackgroundColor,
                icons: Icons.fastfood_rounded,
                iconsColor: Warna.oranye1,
                text: 'Cari Menu')
            : dataMenus!.content!.isEmpty
                ? itemsEmptyBody(context,
                    icons: Icons.fastfood_rounded,
                    iconsColor: Warna.oranye1,
                    bgcolors: Warna.pageBackgroundColor)
                : MasonryGridView.count(
                    itemCount: dataMenus?.content?.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 25),
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    itemBuilder: (context, index) {
                      MenuItems? items = dataMenus?.content![index];
                      return ProductCardBox(
                          onPressed: () {
                            navigateTo(
                              context,
                              CanteenScreen(
                                menuId: '${items!.menuId}',
                                merchantId: items.merchants?.merchantId,
                                merchantType:
                                      items.merchants!.merchantType!
                              ),
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
                          isDanus: items?.menuIsDanus!);
                    },
                  ); // Replace with the widget you want to show for 'menu'
      }
      // else if (selectedTab == 'kantin') {
      //   return ListView.builder(
      //     itemCount: 10,
      //     physics: const NeverScrollableScrollPhysics(),
      //     shrinkWrap: true,
      //     padding: const EdgeInsets.fromLTRB(25, 25, 25, 20),
      //     itemBuilder: (context, index) {
      //       return Container(
      //         // margin: const EdgeInsets.only(top: 25, bottom: 10, left: 25, right: 25),
      //         padding: const EdgeInsets.symmetric(vertical: 10),
      //         child: const CanteenCardBox(
      //           canteenName: '[Canteen Name]',
      //           menuList: 'Rendang, Ayam Geprek, Nasgor ...',
      //           likes: '200',
      //           rate: '4.4',
      //           type: 'kantin',
      //         ),
      //       );
      //     },
      //   ); // Replace with the widget you want to show for 'kantin'
      // }
      else if (selectedTab == 'wirausaha') {
        return dataMerchants?.merchants! == null
            ? itemsEmptyBody(context,
                bgcolors: Warna.pageBackgroundColor,
                icons: CommunityMaterialIcons.handshake,
                iconsColor: Warna.kuning,
                text: 'Cari Wirausaha')
            : dataMerchants!.merchants!.isEmpty
                ? itemsEmptyBody(context,
                    icons: CommunityMaterialIcons.handshake,
                    iconsColor: Warna.kuning,
                    bgcolors: Warna.pageBackgroundColor)
                : ListView.builder(
                    itemCount: dataMerchants?.merchants?.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(25, 15, 25, 20),
                    itemBuilder: (context, index) {
                      MerchantItems? items = dataMerchants?.merchants![index];
                      return Padding(
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
                  ); // Default case if selectedTab doesn't match 'menu' or 'kantin'
      } else {
        return dataOrganizations?.organizations == null
            ? itemsEmptyBody(context,
                icons: Icons.groups,
                iconsColor: Warna.biru,
                text: 'Cari Organisasi',
                bgcolors: Warna.pageBackgroundColor)
            : dataOrganizations!.organizations!.isEmpty
                ? itemsEmptyBody(context,
                    icons: Icons.groups,
                    iconsColor: Warna.biru,
                    bgcolors: Warna.pageBackgroundColor)
                : ListView.builder(
                    itemCount: dataOrganizations?.organizations?.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(25, 15, 25, 20),
                    itemBuilder: (context, index) {
                       OrganizationItems? items =
                          dataOrganizations?.organizations![index];
                      return Container(
                        // margin: const EdgeInsets.only(top: 25, bottom: 10, left: 25, right: 25),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: OrganizationCardBox(
                          organizationId: items?.id,
                          imgUrl:
                              '${AppConfig.URL_IMAGES_PATH}${items?.organizationLogo}',
                          organizationName: items?.organizationName,
                          totalActivity: '${items?.totalActivity}',
                          totalWirausaha: '${items?.totalWirausaha}',
                          totalMenu: '${items?.totalMenu}',
                          onPressed: () => navigateTo(
                            context,
                            OrganizationScreen(id: items?.id),
                          ),
                        ),
                      );
                    },
                  );
      }
    }
  }

  Widget tabMenuItemsList() {
    return Container(
      height: 50,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        children: [
          tabMenuItem(
            onPressed: () {
              selectTabs('menu');
            },
            text: 'Menu',
            icons: Icons.fastfood_rounded,
            activeColor: Warna.oranye1,
            menuName: 'menu',
          ),
          // tabMenuItem(
          //   onPressed: () {
          //     selectTabs('kantin');
          //   },
          //   text: 'Kantin',
          //   icons: Icons.store_rounded,
          //   activeColor: Warna.biru1,
          //   menuName: 'kantin',
          // ),
          tabMenuItem(
            onPressed: () {
              selectTabs('wirausaha');
            },
            text: 'Wirausaha',
            icons: CommunityMaterialIcons.handshake,
            activeColor: Warna.kuning,
            menuName: 'wirausaha',
          ),
          tabMenuItem(
            onPressed: () {
              selectTabs('organisasi');
            },
            text: 'Organisasi',
            icons: Icons.groups,
            activeColor: Warna.biru,
            menuName: 'organisasi',
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
            Icon(
              icons,
              size: 20,
              color: menuName == selectedTab ? activeColor : Warna.abu6,
            ),
            const SizedBox(
              width: 10,
            ),
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

  Widget searchItemBox({
    VoidCallback? onPressed,
    String? text,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Warna.abu,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(37),
            side: BorderSide(color: Warna.abu3, width: 1),
          )),
      child: Text(
        text!,
        style: TextStyle(
          fontSize: 16,
          color: Warna.kuning,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
