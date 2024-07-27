import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

class OrganizationScreen extends StatefulWidget {
  final String? id;
  const OrganizationScreen({
    super.key,
    this.id,
  });

  @override
  State<OrganizationScreen> createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen>
    with SingleTickerProviderStateMixin {
  String selectedTab = 'Semua';
  late TabController categoryTabController;
  TextEditingController searchTextController = TextEditingController();
  Map<String, Map<String, Map<String, dynamic>>> organizationMaps = {
    'Semua': {
      'wirausaha 1': {
        'id': '1',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 2': {
        'id': '2',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 3': {
        'id': '3',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 4': {
        'id': '4',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 5': {
        'id': '5',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 6': {
        'id': '6',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
    },
    'kategori 1': {
      'wirausaha 1': {
        'id': '7',
        'nama': 'nama wirausaha kategori 1',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 2': {
        'id': '8',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 3': {
        'id': '9',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 4': {
        'id': '10',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
    },
    'kategori 2': {
      'wirausaha 1': {
        'id': '11',
        'nama': 'nama wirausaha kategori 2',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 2': {
        'id': '12',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 3': {
        'id': '13',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 4': {
        'id': '14',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
    },
    'kategori 3': {
      'wirausaha 1': {
        'id': '15',
        'nama': 'nama wirausaha kategori 3',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 2': {
        'id': '16',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 3': {
        'id': '17',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 4': {
        'id': '18',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
    },
    'kategori 4': {
      'wirausaha 1': {
        'id': '19',
        'nama': 'nama wirausaha kategori 4',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 2': {
        'id': '20',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 3': {
        'id': '21',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
      'wirausaha 4': {
        'id': '22',
        'nama': 'nama wirausaha',
        'rate': '4.0',
        'likes': '100',
        'menuList': 'Rendang, Ayam Geprek, Nasgor ...',
      },
    }
  };

  @override
  void initState() {
    super.initState();
    categoryTabController =
        TabController(length: organizationMaps.length, vsync: this);
    onEnterPage();
  }


  Future<void> onEnterPage() async {}

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 10));

    print('reload...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: backButtonCustom(
          context: context,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 10,
        elevation: 2,
        forceMaterialTransparency: true,
        actions: [
          actionButtonCustom(
            icons: UIcons.solidRounded.share,
            onPressed: () {},
          ),
          const SizedBox(
            width: 25,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ReloadIndicatorType1(
        onRefresh: refreshPage,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CustomScrollView(
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
                    height: 120,
                    width: double.infinity,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Center(
                      child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Warna.abu5,
                          )),
                    )),
              ])),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    bodyOrganizationInfo(),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    bodyWirausahaList(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyOrganizationInfo() {
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
              Icon(
                Icons.store,
                color: Warna.biru.withOpacity(0.70),
                size: 35,
              ),
              const SizedBox(
                width: 15,
              ),
              const Text(
                '[Nama Kantin]',
                style: AppTextStyles.title,
                maxLines: 2,
              ),
            ],
          ),
          const Text(
            '[List Kategori Kantin]',
            style: AppTextStyles.textRegular,
          ),
          const SizedBox(
            height: 8,
          ),
          // storeReviewContainer(),
          // const SizedBox(
          //   height: 8,
          // ),
          Row(
            children: [
              Icon(
                UIcons.solidRounded.user,
                color: Warna.biru,
                size: 16,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'Nama Mahasiswa - Prodi dan Jurusan',
                style: AppTextStyles.textRegular,
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            '[Deskripsi kantin/wirausaha]',
            style: AppTextStyles.textRegular,
          ),
        ],
      ),
    );
  }

  Widget bodyWirausahaList() {
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
            children: organizationMaps.keys.map((String key) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
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
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      selectedTab = key;
                    });
                    log(selectedTab);
                  },
                  child: Text(
                    key,
                    style: TextStyle(
                      fontSize: key == selectedTab ? 16 : 14,
                      color: key == selectedTab ? Warna.kuning : Warna.biru,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        ListView.builder(
          itemCount: organizationMaps[selectedTab]?.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Map<String, dynamic> wirausahaItems =
                organizationMaps[selectedTab]!;
            String wirausahaKey = wirausahaItems.keys.elementAt(index);
            var item = wirausahaItems[wirausahaKey];
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Container(
                // margin: const EdgeInsets.only(top: 25, bottom: 10, left: 25, right: 25),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: OrganizationCardBox(
                  organizationName: item['nama'],
                  menuList: item['menuList'],
                  likes: item['likes'],
                  rate: item['rate'],
                ),
              ),
            );
          },
        ),
      ],
    );
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
}
