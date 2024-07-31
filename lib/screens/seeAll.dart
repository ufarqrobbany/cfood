import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/custom/page_item_void.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/getl_all_merchant_response.dart';
import 'package:cfood/model/get_all_organization_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/canteen.dart';
import 'package:cfood/screens/organization.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SeeAllItemsScreen extends StatefulWidget {
  final String? typeName;
  final String? typeCode;
  final bool? listGrid;
  const SeeAllItemsScreen({
    super.key,
    this.listGrid = false,
    this.typeName = 'Kantin', // Kantin | Organisasi | Pre-Order | Wirausaha
    this.typeCode = 'kantin',
  });

  @override
  State<SeeAllItemsScreen> createState() => _SeeAllItemsScreenState();
}

class _SeeAllItemsScreenState extends State<SeeAllItemsScreen> {
  TextEditingController searchTextController = TextEditingController();
  GetAllMerchantsResponse? dataMerchantsResponse;
  DataGetMerchant? dataMerchants;
  MerchantItems? merchantListItems;

  GetAllOrganizationsResponse? dataOrganizationsResponse;
  DataGetOrganization? dataOrganizations;
  OrganizationItems? organizationListItems;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    log('get data type : ${widget.typeCode}');
    if (widget.typeCode == 'wirausaha' || widget.typeCode == 'kantin') {
      getAllMerchants(context);
    }

    if (widget.typeCode == 'organisasi') {
      getAllOrganizations(context);
    }
  }

  Future<void> getAllMerchants(BuildContext context,
      {String searchItem = ''}) async {
    dataMerchantsResponse = await FetchController(
      endpoint:
          'merchants/all?page=1&size=10&type=${widget.typeCode}&isOpen=all&searchName=$searchItem',
      fromJson: (json) => GetAllMerchantsResponse.fromJson(json),
    ).getData();

    setState(() {
      dataMerchants = dataMerchantsResponse?.data;
    });
  }

  Future<void> getAllOrganizations(BuildContext context,
      {String searchItem = ''}) async {
    dataOrganizationsResponse = await FetchController(
      endpoint: 'organizations/?campusId=1&page=1&size=50&name=$searchItem',
      fromJson: (json) => GetAllOrganizationsResponse.fromJson(json),
    ).getData();

    setState(() {
      dataOrganizations = dataOrganizationsResponse?.data;
    });
  }

  void onSearch({String searchItem = ''}) {
    if (widget.typeCode == 'wirausaha' || widget.typeCode == 'kantin') {
      getAllMerchants(context, searchItem: searchItem);
    }

    if (widget.typeCode == 'organisasi') {
      getAllOrganizations(context, searchItem: searchItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: backButtonCustom(context: context),
        title: Text(
          widget.typeName!,
          style: AppTextStyles.title,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        forceMaterialTransparency: false,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
            // preferredSize: const Size.fromHeight(80),
            preferredSize: const Size.fromHeight(80),
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
                      hintText: 'Cari ${widget.typeName}',
                      borderColor: Warna.abu4,
                      borderRadius: 58,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (p0) {
                        onSearch(searchItem: p0);
                      },
                      onChanged: (p0) {
                        onSearch(searchItem: p0);
                      },
                      prefixIcon: IconButton(
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          iconSize: 15,
                          color: Warna.biru,
                          icon: const Icon(
                            Icons.search,
                          )),
                    )),

                // searchDone ? tabMenuItemsList() : Container(height: 0,),
              ],
            )),
      ),
      backgroundColor: Colors.white,
      body: widget.typeCode == 'kantin'
          ? onCanteenBody()
          : widget.typeCode == 'wirausaha'
              ? onWirausahaBody()
              : widget.typeCode == 'organisasi'
                  ? onOrganizationBody()
                  : widget.typeCode == 'pre-order'
                      ? onPreOrderBody()
                      : onPreOrderBody(),
    );
  }

  Widget onCanteenBody() {
    return ReloadIndicatorType1(
      onRefresh: fetchData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: dataMerchants?.merchants == null
            ? Container()
            : dataMerchants?.totalElements == 0
                ? itemsEmptyBody(context)
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
                          likes: ' ${items?.followers}',
                          rate: '${items?.rating}',
                          type: items?.merchantType,
                          open: items!.open!,
                          danus: items.danus!,
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
                  ),
      ),
    );
  }

  Widget onWirausahaBody() {
    return ReloadIndicatorType1(
      onRefresh: fetchData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: dataMerchants?.merchants == null
            ? Container()
            : dataMerchants?.totalElements == 0
                ? itemsEmptyBody(context)
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
                          likes: ' ${items?.followers}',
                          rate: '${items?.rating}',
                          type: items?.merchantType,
                          open: items!.open!,
                          danus: items.danus!,
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
                  ),
      ),
    );
  }

  Widget onOrganizationBody() {
    return ReloadIndicatorType1(
      onRefresh: fetchData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: dataOrganizations?.organizations == null
            ? Container()
            : dataOrganizations?.totalElements == 0
                ? itemsEmptyBody(context)
                : ListView.builder(
                    itemCount: dataOrganizations?.organizations?.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 20),
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
                  ),
      ),
    );
  }

  Widget onPreOrderBody() {
    return ReloadIndicatorType1(
      onRefresh: fetchData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: MasonryGridView.count(
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
        ),
      ),
    );
  }
}
