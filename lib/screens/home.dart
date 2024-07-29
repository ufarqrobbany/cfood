import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/custom/reload_indicator.dart';
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

  @override
  void initState() {
    super.initState();

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
                'POLBAN, Gedung JTK',
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
                      type: 'Wirausaha',
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
                      type: 'Kantin',
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
          height: 315,
          child: ListView.builder(
            itemCount: 10,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(top: 24, bottom: 40),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ProductCardBox(
                  onPressed: () {
                    navigateTo(
                      context,
                      const CanteenScreen(
                        menuId: '0',
                        storeId: '1',
                      ),
                    );
                  },
                  productName: '[Nama Menu]',
                  storeName: '[Nama Toko]',
                  price: '10.000',
                  likes: '100',
                  rate: '4.5',
                ),
              );
            },
          ),
        ),

        // Pre-Order
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pre-order Sekarang ',
                style: AppTextStyles.subTitle,
                textAlign: TextAlign.left,
              ),
              CYellowMoreButton(
                  onPressed: () => navigateTo(
                        context,
                        const SeeAllItemsScreen(
                          type: 'Pre-Order',
                        ),
                      ),
                  text: 'Lihat Semua'),
            ],
          ),
        ),
        SizedBox(
          height: 315,
          child: ListView.builder(
            itemCount: 10,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(top: 24, bottom: 40),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ProductCardBox(
                  onPressed: () {
                    navigateTo(
                      context,
                      const CanteenScreen(
                        menuId: '0',
                        storeId: '1',
                      ),
                    );
                  },
                  productName: '[Nama Menu]',
                  storeName: '[Nama Toko]',
                  price: '10.000',
                  likes: '100',
                  rate: '4.5',
                ),
              );
            },
          ),
        ),

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
                          type: 'Organisasi',
                        ),
                      ),
                  text: 'Lihat Semua'),
            ],
          ),
        ),
        SizedBox(
          height: 224,
          child: ListView.builder(
            itemCount: 4,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemExtent: 180,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 24, bottom: 40),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: OrganizationCard(
                  onPressed: () => navigateTo(
                    context,
                    const OrganizationScreen(id: '0'),
                  ),
                  text: '[Nama Organisasi]',
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
        ListView.builder(
          itemCount: 10,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(25, 15, 25, 40),
          itemBuilder: (context, index) {
            return Container(
              // margin: const EdgeInsets.only(top: 25, bottom: 10, left: 25, right: 25),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CanteenCardBox(
                canteenName: '[Canteen Name]',
                menuList: 'Rendang, Ayam Geprek, Nasgor ...',
                likes: '200',
                rate: '4.4',
                type: 'kantin',
                onPressed: () => navigateTo(context, const CanteenScreen()),
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
