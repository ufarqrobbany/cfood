import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/screens/chat.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatSellerScreen extends StatefulWidget {
  const ChatSellerScreen({
    super.key,
  });

  @override
  State<ChatSellerScreen> createState() => _ChatSellerScreenState();
}

class _ChatSellerScreenState extends State<ChatSellerScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 10));

    print('reload...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: backButtonCustom(context: context),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          'Chat Pembeli',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Warna.regulerFontColor,
          ),
        ),
      ),
      backgroundColor: Warna.pageBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: chatSellerBody(),
      ),
    );
  }

  Widget chatSellerBody() {
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
          name: 'nama penjual',
          lastMassage: 'sudah dikirim yah',
          totalNewMessage: '3',
          lastDateTime: '01-7-2024',
          onPressed: () {
            navigateTo(context, ChatScreen());
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen(),));
          },
        );
      },
    );
  }
}
