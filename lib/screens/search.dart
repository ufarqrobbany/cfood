import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/style.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextController = TextEditingController();
  ScrollController onSearchScrollController = ScrollController();
  ScrollController searchResultScrollController = ScrollController();
  bool searchDone = false;
  String selectedTab = 'menu';

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

    searchTextController.addListener(_filterSearch);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void selectTabs(tab) {
    setState(() {
      selectedTab = tab;
    });
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
                        _filterSearch();
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

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Text(
              'Riwayat',
              style: AppTextStyles.subTitle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              children: [
                for (var item in riwayat)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: searchItemBox(
                      onPressed: () {},
                      text: item,
                    ),
                  )
              ],
            ),
          ),
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
                      onPressed: () {},
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
        return MasonryGridView.count(
          itemCount: 8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
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
        ); // Replace with the widget you want to show for 'menu'
      } else if (selectedTab == 'kantin') {
        return ListView.builder(
          itemCount: 10,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 20),
          itemBuilder: (context, index) {
            return Container(
              // margin: const EdgeInsets.only(top: 25, bottom: 10, left: 25, right: 25),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const CanteenCardBox(
                canteenName: '[Canteen Name]',
                menuList: 'Rendang, Ayam Geprek, Nasgor ...',
                likes: '200',
                rate: '4.4',
                type: 'kantin',
              ),
            );
          },
        ); // Replace with the widget you want to show for 'kantin'
      } else if (selectedTab == 'wirausaha') {
        return ListView.builder(
          itemCount: 10,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 20),
          itemBuilder: (context, index) {
            return Container(
              // margin: const EdgeInsets.only(top: 25, bottom: 10, left: 25, right: 25),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const CanteenCardBox(
                canteenName: '[Canteen Name]',
                menuList: 'Rendang, Ayam Geprek, Nasgor ...',
                likes: '200',
                rate: '4.4',
                type: 'wirausaha',
              ),
            );
          },
        ); // Default case if selectedTab doesn't match 'menu' or 'kantin'
      } else {
        return ListView.builder(
          itemCount: 10,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 20),
          itemBuilder: (context, index) {
            return Container(
              // margin: const EdgeInsets.only(top: 25, bottom: 10, left: 25, right: 25),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const OrganizationCardBox(
                organizationName: '[Canteen Name]',
                // menuList: 'Rendang, Ayam Geprek, Nasgor ...',
                // likes: '200',
                // rate: '4.4',
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
          tabMenuItem(
            onPressed: () {
              selectTabs('kantin');
            },
            text: 'Kantin',
            icons: Icons.store_rounded,
            activeColor: Warna.biru1,
            menuName: 'kantin',
          ),
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
