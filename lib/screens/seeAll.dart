import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SeeAllItemsScreen extends StatefulWidget {
  final String? type;
  final bool? listGrid;
  const SeeAllItemsScreen({
    super.key,
    this.listGrid = false,
    this.type = 'Kantin', // Kantin | Organiasi | Pre-Order | Wirausaha
  });

  @override
  State<SeeAllItemsScreen> createState() => _SeeAllItemsScreenState();
}

class _SeeAllItemsScreenState extends State<SeeAllItemsScreen> {
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> refreshCanteenBody() async {
    await Future.delayed(const Duration(seconds: 10));

    print('reload...');
  }

  Future<void> refreshOrganizationBody() async {
    await Future.delayed(const Duration(seconds: 10));

    print('reload...');
  }

  Future<void> refreshPreOrderBody() async {
    await Future.delayed(const Duration(seconds: 10));

    print('reload...');
  }

  Future<void> refreshWirausahaBody() async {
    await Future.delayed(const Duration(seconds: 10));

    print('reload...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: backButtonCustom(context: context),
        title: Text(
          widget.type!,
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
                      hintText: 'Cari ${widget.type}',
                      borderColor: Warna.abu4,
                      borderRadius: 58,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (p0) {},
                      onChanged: (p0) {},
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
      body: widget.type == 'Kantin'
          ? onCanteenBody()
          : widget.type == 'Wirausaha'
              ? onWirausahaBody()
              : widget.type == 'Organisasi'
                  ? onOrganizationBody()
                  : widget.type == 'Pre-Order'
                      ? onPreOrderBody()
                      : onPreOrderBody(),
    );
  }

  Widget onCanteenBody() {
    return ReloadIndicatorType1(
      onRefresh: refreshCanteenBody,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ListView.builder(
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
        ),
      ),
    );
  }

  Widget onWirausahaBody() {
    return ReloadIndicatorType1(
      onRefresh: refreshWirausahaBody,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ListView.builder(
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
        ),
      ),
    );
  }

  Widget onOrganizationBody() {
    return ReloadIndicatorType1(
      onRefresh: refreshOrganizationBody,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ListView.builder(
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
                menuList: 'Rendang, Ayam Geprek, Nasgor ...',
                likes: '200',
                rate: '4.4',
              ),
            );
          },
        ),
      ),
    );
  }

  Widget onPreOrderBody() {
    return ReloadIndicatorType1(
      onRefresh: refreshPreOrderBody,
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
