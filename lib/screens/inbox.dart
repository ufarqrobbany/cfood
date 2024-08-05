import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/screens/chat.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InboxScreen extends StatefulWidget {
  bool canBack;
  InboxScreen({super.key, this.canBack = false});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  String selectedTab = 'driver';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        automaticallyImplyLeading: widget.canBack,
        leading: widget.canBack ? backButtonCustom(context: context) : Container(),
        elevation: 0,
        centerTitle: !widget.canBack,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: const Text(
          'Chat',
          style: AppTextStyles.title,
        ),
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
                            selectedTab = 'driver';
                          });
                        }, 
                        selectedTab: selectedTab,
                        typeTab: 'driver',
                        text: 'Kurir',
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: CTabButtons(
                        onPressed: () {
                          setState(() {
                            selectedTab = 'seller';
                          });
                        }, 
                        selectedTab: selectedTab,
                        typeTab: 'seller',
                        text: 'Pedagang',
                      ),
                    ),
                    
                  ],
                ),
              ),
        
              selectedTab == 'seller' ?
              sellerTabBody() : driverTabBody(),
          ],
        ),
      ),
    );
  }

  Widget sellerTabBody() {
    return ListView.builder(
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      // padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      itemBuilder: (context, index) {
      return  InboxCardItems(
        chatId: '0',
        inboxId: '0',
        userId: '0',
        name: 'nama penjual',
        lastMassage: 'sudah dikirim yah',
        totalNewMessage: '3',
        lastDateTime: '01-7-2024',
        onPressed: () {
  //         final bool? isMerchant;
  // final int? userId;
  // final int? merchantId;
          // Navigator.pushNamed(context, '/chat', arguments: {'isMerchant': true, 'userId': 0, 'merchantId': 0},);
          navigateTo(context, ChatScreen(isMerchant: true, merchantId: 0,userId: 0,), routeName: '/chat');
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen(),));
        },
      );
    },);
  }

  Widget driverTabBody() {
    return ListView.builder(
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      // padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      itemBuilder: (context, index) {
      return InboxCardItems(
        chatId: '0',
        inboxId: '0',
        userId: '0',
        name: 'nama kurir',
        lastMassage: 'sedang dikirim yah',
        totalNewMessage: '3',
        lastDateTime: '01-7-2024',
        onPressed: () {
          // Share.share('https://campusfood.id/splash',);
          navigateTo(context, ChatScreen(isMerchant: false, merchantId: 0, userId: 0,));
        },
      );
    },);
  }
}