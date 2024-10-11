import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/card.dart';
import 'package:cfood/custom/page_item_void.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/get_rooms_chat.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/chat.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:uicons/uicons.dart';

// ignore: must_be_immutable
class ChatSellerScreen extends StatefulWidget {
  const ChatSellerScreen({
    super.key,
  });

  @override
  State<ChatSellerScreen> createState() => _ChatSellerScreenState();
}

class _ChatSellerScreenState extends State<ChatSellerScreen> {
  String selectedTab = 'customer'; //driver
  GetChatRoomResponse? roomResponse;
  DataRoom? dataRoomMerchant;
  DataRoom? dataRoomDriver;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchData() {
    fetcthMerchatRooms();
  }

  Future<void> fetcthMerchatRooms() async {
    roomResponse = await FetchController(
        // endpoint: 'chats/merchants?userId=91',
        endpoint: 'chats/merchants?userId=${AppConfig.USER_ID}',
        fromJson: (json) => GetChatRoomResponse.fromJson(json)).getData();
    if (roomResponse != null) {
      setState(() {
        // dataRoomMerchant = roomResponse!.data;
        dataRoomMerchant = null;
      });
    }
  }

  Future<void> refreshPage() async {
    print('reload...');
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        // automaticallyImplyLeading: widget.canBack,
        leading: backButtonCustom(context: context),
        elevation: 0,
        // centerTitle: !widget.canBack,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: const Text(
          'Chat',
          style: AppTextStyles.title,
        ),
      ),
      backgroundColor: Warna.pageBackgroundColor,
      body: ReloadIndicatorType1(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CTabButtons(
                        onPressed: () {
                          setState(() {
                            selectedTab = 'customer';
                          });
                        },
                        selectedTab: selectedTab,
                        typeTab: 'customer',
                        text: 'Customer',
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
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
                  ],
                ),
              ),
              roomResponse == null || dataRoomMerchant == null
                  ? itemsEmptyBody(context,
                      bgcolors: Colors.transparent,
                      icons: UIcons.solidRounded.store_alt,
                      iconsColor: Warna.kuning,
                      text: 'Belum Ada Chat')
                  : selectedTab == 'customer'
                      ? customerTabBody()
                      : driverTabBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget customerTabBody() {
    return roomResponse == null && dataRoomMerchant == null
        ? SizedBox(
            width: double.infinity,
            height: 300,
            child: pageOnLoading(context, bgColor: Colors.transparent))
        : dataRoomMerchant!.rooms == []
            ? itemsEmptyBody(context,
                bgcolors: Colors.transparent,
                icons: UIcons.solidRounded.store_alt,
                iconsColor: Warna.kuning,
                text: 'Belum Ada Chat dengan Pedagang')
            : ListView.builder(
                itemCount: dataRoomMerchant!.rooms!.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                itemBuilder: (context, index) {
                  Rooms item = dataRoomMerchant!.rooms![index];
                  return InboxCardItems(
                    chatId: item.roomId,
                    inboxId: item.roomId,
                    imgUrl: item.photo,
                    userId: '0',
                    name: item.name,
                    lastMassage: item.latestChatMessage,
                    totalNewMessage: item.unreadMessages.toString(),
                    lastDateTime: item.latestUpdated,
                    latestSenderType: item.latestSenderType,
                    onPressed: () {
                      //         final bool? isMerchant;
                      // final int? userId;
                      // final int? merchantId;
                      // Navigator.pushNamed(context, '/chat', arguments: {'isMerchant': true, 'userId': 0, 'merchantId': 0},);
                      navigateTo(
                              context,
                              ChatScreen(
                                isMerchant: true,
                                roomId: int.parse(item.roomId!),
                                merchantId: 0,
                                userId: 0,
                                profileImg:
                                    '${AppConfig.URL_IMAGES_PATH}${item.photo}',
                                username: item.name,
                                subname: '',
                              ),
                              routeName: '/chat')
                          .then((onValue) {
                        setState(() {
                          item.unreadMessages = 0;
                        });
                      });
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen(),));
                    },
                  );
                },
              );
  }

  Widget driverTabBody() {
    return ListView.builder(
      itemCount: 0,
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
            navigateTo(
                context,
                ChatScreen(
                  isMerchant: false,
                  merchantId: 0,
                  userId: 0,
                ));
          },
        );
      },
    );
  }
}
