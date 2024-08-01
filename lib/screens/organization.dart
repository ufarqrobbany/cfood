import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/get_detail_organization_response.dart';
import 'package:cfood/screens/canteen.dart';
import 'package:cfood/style.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:uicons/uicons.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/utils/constant.dart';

class OrganizationScreen extends StatefulWidget {
  final int? id;
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
  Map<String, dynamic> organizationMaps = {};

  GetDetailOrganizationResponse? organizationDataResponse;
  DataDetailOrganization? dataOrganization;
  String? logoOrganization;

  @override
  void initState() {
    super.initState();
    log(widget.id!.toString());
    onEnterPage();
  }

  Future<void> onEnterPage() async {
    fetchDetailDataOrganization();
    categoryTabController =
        TabController(length: organizationMaps.keys.length, vsync: this);
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 1));
    fetchDetailDataOrganization();
    print('reload...');
  }

  Future<void> fetchDetailDataOrganization() async {
    organizationDataResponse = await FetchController(
      endpoint: 'organizations/${widget.id}',
      fromJson: (json) => GetDetailOrganizationResponse.fromJson(json),
    ).getData();

    setState(() {
      dataOrganization = organizationDataResponse!.data;
      logoOrganization = AppConfig.URL_IMAGES_PATH +
          organizationDataResponse!.data!.organizationLogo!;
    });

    organizationMaps = {
      for (var activity in organizationDataResponse!.data!.activities!)
        activity.activityName!: activity.merchants!,
    };
    if (organizationMaps.isNotEmpty) {
      selectedTab = organizationMaps.keys.first;
    }
    log("$dataOrganization");
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
                  width: double.infinity,
                  height: 170,
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: Image.network(
                          logoOrganization ?? './jpg',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
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
                                    child: LoadingAnimationWidget.staggeredDotsWave(
                                        color: Warna.biru, size: 30),
                                  ),
                                ),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200,
                            width: double.infinity,
                            color: Warna.abu2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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
                Icons.groups,
                color: Warna.biru,
                size: 35,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                '${dataOrganization?.organizationName}',
                style: AppTextStyles.title,
                maxLines: 2,
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            '${dataOrganization?.totalActivity} Kegiatan',
            style: AppTextStyles.textRegular,
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
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
                      CommunityMaterialIcons.handshake,
                      size: 15,
                      color: Warna.kuning,
                    ),
                    Text(
                      ' ${dataOrganization?.totalWirausaha.toString()} Wirausaha',
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
                  border: Border.all(color: Warna.oranye1, width: 1),
                  color: Warna.oranye1.withOpacity(0.10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fastfood_rounded,
                      size: 15,
                      color: Warna.oranye1,
                    ),
                    Text(
                      ' ${dataOrganization?.totalMenu.toString()} Menu',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          )
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
        const SizedBox(
          height: 20,
        ),
        ListView.builder(
          itemCount: organizationMaps[selectedTab]?.length ?? 0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var merchants = organizationMaps[selectedTab]!;
            var merchant = merchants[index];
            log('Merchant data: ${merchant.toString()}');
            debugPrint('Merchant data: ${merchant.toString()}');
            return Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CanteenCardBox(
                    canteenId: '${merchant.merchantId}',
                    imgUrl:
                        '${AppConfig.URL_IMAGES_PATH}${merchant?.merchantPhoto}',
                    canteenName: merchant.merchantName,
                    likes: ' ${merchant?.followers}',
                    rate: '${merchant?.rating}',
                    type: merchant?.merchantType,
                    open: merchant!.open!,
                    danus: merchant.danus!,
                    onPressed: () => navigateTo(
                        context,
                        CanteenScreen(
                          merchantId: merchant.merchantId,
                          isOwner: false,
                          merchantType: merchant.merchantType!,
                          itsDanusan: merchant.danus,
                        )),
                  ),
                ));
          },
        ),
      ],
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
