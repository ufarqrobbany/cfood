import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String selectedTab = 'store';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: backButtonCustom(context: context),
        title: const Text('Favorit', style: AppTextStyles.title,),
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
                      text: 'kantin & Wirausaha',
                    ),
                  ),
                  const SizedBox(width: 20,),
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
        
            selectedTab == 'store' ?
            storeBody() : menuBody(),
          ],
        ),
      ),
    );
  }

  Widget storeBody() {
    return ListView.builder(
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CanteenCardBox(
            canteenId: '98098',
            canteenName: 'Nama Canteen',
            likes: '98',
            rate: '4.2',
            menuList: 'Geprek Bebek, Nasgor, Rotbar',
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