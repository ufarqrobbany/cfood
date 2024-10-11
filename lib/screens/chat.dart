import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/background_image.dart';
import 'package:cfood/model/get_chat_message_response.dart';
import 'package:cfood/model/reponse_handler.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:uicons/uicons.dart';

class ChatScreen extends StatefulWidget {
  bool? isMerchant;
  int? userId;
  int? merchantId;
  int? roomId;
  String? profileImg;
  String? username;
  String? subname;
  ChatScreen({
    super.key,
    this.isMerchant = false,
    this.userId = 0,
    this.merchantId = 0,
    this.roomId,
    this.profileImg,
    this.subname,
    this.username,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController inputMessageController = TextEditingController();
  late final AnimationController inputOptionAnimationController;
  ScrollController _scrolController = ScrollController();
  bool sendMessage = false;
  bool showInputOption = false;
  Timer? _messageTimer;
  int page = 1;
  bool isFetching = false;

  GetChatMessageResponse? roomResponse;
  DataChat? dataChat;

  File? _image;
  File? _image_temp;
  final picker = ImagePicker();
  @override
  void initState() {
    inputOptionAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    super.initState();
    _scrolController.addListener(_scrollListener);
    log('is merchant: ${widget.isMerchant}');
    fetchData();
    _fetchNewMessages();
    // startMessagePolling();
  }

  // Fungsi untuk mendeteksi apakah scroll telah mencapai bagian atas
  void _scrollListener() {
    if (_scrolController.position.atEdge) {
      log(_scrolController.position.pixels.toString());
      if (_scrolController.position.pixels == _scrolController.position.maxScrollExtent) {
        // Ketika sudah di bagian paling atas
        _fetchOldMessages();
      }
    }
  }

  @override
  void dispose() {
    inputOptionAnimationController.dispose();
    _messageTimer?.cancel();
    super.dispose();
  }

  bool isClick = false;
  bool isClick1 = false;

  void fetchData() {
    fetchMessages();
  }

  // void startMessagePolling() {
  //   _messageTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     fetchMessages();
  //   });
  // }

  Future<void> fetchMessages() async {
    roomResponse = await FetchController(
      endpoint:
          'chats/merchants/room?roomId=${widget.roomId}&page=$page&size=10',
      fromJson: (json) => GetChatMessageResponse.fromJson(json),
    ).getData();

    if (roomResponse != null && roomResponse!.data != null && page > 1) {
      setState(() {
        // Gabungkan pesan baru dengan pesan lama tanpa menghapus data lama
        dataChat?.messages?.addAll(roomResponse!.data!.messages!);
        // Optional: Group ulang jika diperlukan
        dataChat?.messages = groupMessagesByDay(dataChat!.messages!)
            .values
            .expand((msg) => msg)
            .toList();
      });
    } else {
      setState(() {
        dataChat = roomResponse!.data;
      });
    }
  }

  // Fungsi untuk fetch message saat scroll ke atas (pagination)
  Future<void> _fetchOldMessages() async {
    if (isFetching) return; // Cegah pengambilan data saat sudah fetching
    setState(() {
      isFetching = true; // Tandai bahwa sedang fetching
    });

    // Naikkan halaman untuk fetch data sebelumnya
    page++;

    roomResponse = await FetchController(
      endpoint:
          'chats/merchants/room?roomId=${widget.roomId}&page=$page&size=10',
      fromJson: (json) => GetChatMessageResponse.fromJson(json),
    ).getData();

    if (roomResponse != null && roomResponse!.data != null) {
      setState(() {
        // Gabungkan pesan baru (lama) dengan pesan yang sudah ada di list
        // dataChat?.messages?.insertAll(0, roomResponse!.data!.messages!);
        dataChat?.messages?.addAll(roomResponse!.data!.messages!);
        // Optional: Group ulang jika diperlukan
        dataChat?.messages = groupMessagesByDay(dataChat!.messages!)
            .values
            .expand((msg) => msg)
            .toList();
      });
    }

    setState(() {
      isFetching = false; // Selesai fetching
    });
  }

  // Fungsi untuk fetch message saat scroll ke atas (pagination)
  Future<void> _fetchNewMessages() async {
    Timer.periodic(const Duration(seconds: 20), (timer) async {
      roomResponse = await FetchController(
        endpoint: 'chats/merchants/room?roomId=${widget.roomId}&page=1&size=10',
        fromJson: (json) => GetChatMessageResponse.fromJson(json),
      ).getData();

      if (roomResponse != null && roomResponse!.data != null) {
        setState(() {
          // Gabungkan pesan baru (lama) dengan pesan yang sudah ada di list
          // dataChat?.messages?.insertAll(0, roomResponse!.data!.messages!);
          // dataChat?.messages?.addAll(roomResponse!.data!.messages!);
          // Optional: Group ulang jika diperlukan
          dataChat = roomResponse!.data;
          dataChat?.messages = groupMessagesByDay(dataChat!.messages!)
              .values
              .expand((msg) => msg)
              .toList();
        });
      }
    });
  }

  // Future<void> fetcthMessages() async {
  //   roomResponse = await FetchController(
  //       endpoint: 'chats/merchants/room?roomId=${widget.roomId}&page=1&size=10',
  //       fromJson: (json) => GetChatMessageResponse.fromJson(json)).getData();
  //   if (roomResponse != null) {
  //     setState(() {
  //       dataChat = roomResponse!.data;
  //     });
  //   }
  // }

  String formatTimestampToHour(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  Map<String, List<Messages>> groupMessagesByDay(List<Messages> messages) {
    Map<String, List<Messages>> groupedMessages = {};

    for (var message in messages) {
      DateTime dateTime = DateTime.parse(message.timestamp!);
      String dayKey =
          "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

      if (!groupedMessages.containsKey(dayKey)) {
        groupedMessages[dayKey] = [];
      }
      groupedMessages[dayKey]!.add(message);
    }

    return groupedMessages;
  }

  Future<void> postMessage() async {
    log(inputMessageController.text);
    ResponseHendler response = await FetchController(
        endpoint:
            'chats/?userId=${AppConfig.USER_ID}&merchantId=${dataChat!.merchantId}&senderType=USER', //MERCHANT
        fromJson: (json) =>
            ResponseHendler.fromJson(json)).postMultipartDataMessage(
        dataKeyName: 'message',
        data: null,
        dataText: inputMessageController.text,
        file: _image == null ? null : _image,
        fileKeyName: 'media');

    if (response.statusCode == 200) {
      // Menambahkan pesan baru secara lokal tanpa perlu fetch semua data
      setState(() {
        Messages newMessage = Messages(
          senderType: 'USER',
          message: inputMessageController.text,
          media: null,
          mediaLocal: _image,
          timestamp: DateTime.now().toIso8601String(), // timestamp lokal
        );
        // Tambahkan pesan baru ke dalam data yang sudah ada
        // dataChat?.messages?.add(newMessage);
        dataChat?.messages?.insert(0, newMessage);
        // Optional: Group ulang jika diperlukan
        dataChat?.messages = groupMessagesByDay(dataChat!.messages!)
            .values
            .expand((msg) => msg)
            .toList();
        _image = null;
        inputMessageController.clear();
      });
      log('Pesan berhasil ditambahkan secara lokal');
    }
  }

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        // imageChanged = true;
      }
    });
  }

//Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        // imageChanged = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Object? args = ModalRoute.of(context)!.settings.arguments;
    // setState(() {
    //   widget.isMerchant = args.isMerchant;
    // });

    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: backButtonCustom(context: context),
        forceMaterialTransparency: false,
        scrolledUnderElevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  // widget.isMerchant!
                  //     ? 'http://cfood.id/api/images/db27f20b-7573-4c65-840b-9340b4082f5f.jpg'
                  //     : './jpg',
                  dataChat == null
                      ? widget.profileImg.toString()
                      : '${AppConfig.URL_IMAGES_PATH}${dataChat!.photo}',
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Warna.abu,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              widget.isMerchant == true
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dataChat == null
                              ? widget.username.toString()
                              : dataChat!.name!,
                          style: AppTextStyles.subTitle,
                        ),
                        Text(
                          dataChat == null
                              ? widget.subname.toString()
                              : dataChat!.subName!,
                          style: TextStyle(
                            fontSize: 15,
                            color: Warna.abu2,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    )
                  : Text(
                      dataChat == null
                          ? widget.subname.toString()
                          : dataChat!.subName!,
                      style: AppTextStyles.subTitle,
                    ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Warna.pageBackgroundColor,
      body: Stack(
        children: [
          const BackgroundImageGenerated(),
          roomResponse == null
              ? Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Warna.biru,
                    size: 30,
                  ),
                )
              : dataChat == null
                  ? Container()
                  : chatBody(),
          // AnimatedContainer(
          //   duration: const Duration(milliseconds: 500),
          //   curve: Curves.easeIn,
          //   child: showInputOption ? inputMenuOption() : null,),
        ],
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: chatBoxInputContainer(isKeyboardOpen),
    );
  }

  Widget inputMenuOption() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              blurRadius: 20,
              spreadRadius: 0,
              color: Warna.shadow.withOpacity(0.12),
              offset: const Offset(0, 0)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  getImageFromGallery();
                  setState(() {
                    showInputOption = false;
                  });
                },
                icon: Icon(UIcons.solidRounded.picture),
                color: Colors.white,
                iconSize: 24,
                constraints: const BoxConstraints(
                  minHeight: 80,
                  minWidth: 80,
                  maxHeight: 80,
                  maxWidth: 80,
                ),
                style: IconButton.styleFrom(
                    backgroundColor: Warna.biru,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Galeri',
                style: AppTextStyles.textRegular,
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  getImageFromCamera();
                  setState(() {
                    showInputOption = false;
                  });
                },
                icon: Icon(UIcons.solidRounded.camera),
                color: Colors.white,
                iconSize: 24,
                constraints: const BoxConstraints(
                  minHeight: 80,
                  minWidth: 80,
                  maxHeight: 80,
                  maxWidth: 80,
                ),
                style: IconButton.styleFrom(
                    backgroundColor: Warna.biru,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Kamera',
                style: AppTextStyles.textRegular,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget chatBody() {
    // Mengelompokkan pesan berdasarkan hari
    Map<String, List<Messages>> groupedMessages =
        groupMessagesByDay(dataChat!.messages!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        controller: _scrolController,
        physics: const BouncingScrollPhysics(),
        dragStartBehavior: DragStartBehavior.down,
        reverse: true,
        child: Column(
          children: [
            ListView.builder(
              itemCount: groupedMessages.keys.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // dragStartBehavior: DragStartBehavior.down,
              reverse: true,
              itemBuilder: (context, dayIndex) {
                String dayKey = groupedMessages.keys.elementAt(dayIndex);
                List<Messages> dayMessages = groupedMessages[dayKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isFetching
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Warna.biru, size: 30),
                          )
                        : Container(),
                    // Menampilkan indicator hari
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: Warna.biru,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dayKey, // Format YYYY-MM-DD
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Menampilkan chat untuk hari tersebut
                    ListView.builder(
                      itemCount: dayMessages.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      dragStartBehavior: DragStartBehavior.down,
                      reverse: true,
                      itemBuilder: (context, index) {
                        Messages data = dayMessages[index];
                        return customChatBubble(
                          isSender: data.senderType == 'USER' ? true : false,
                          text: data.message,
                          times: formatTimestampToHour(
                              data.timestamp!), // Menampilkan jam
                          timePrevChat: formatTimestampToHour(data.timestamp!),
                          itsAutoSend: false,
                          sendingFailed: false,
                          sendingSuccess: true,
                          imgUrl: data.media,
                          mediaLocal: data.mediaLocal,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 120,
            ),
          ],
        ),
      ),
    );
  }

  // Widget chatBody() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 25),
  //     child: SingleChildScrollView(
  //       physics: const BouncingScrollPhysics(),
  //       dragStartBehavior: DragStartBehavior.down,
  //       reverse: true,
  //       child: Column(
  //         children: [
  //           ListView.builder(
  //             itemCount: dataChat!.messages!.length,
  //             shrinkWrap: true,
  //             physics: const NeverScrollableScrollPhysics(),
  //             dragStartBehavior: DragStartBehavior.down,
  //             reverse: true,
  //             itemBuilder: (context, index) {
  //               Messages data = dataChat!.messages![index];
  //               // menampilkan indicator hari
  //               return customChatBubble(
  //                 isSender: data.senderType == 'USER' ? true : false,
  //                 text: data.message,
  //                 times: data.timestamp,
  //                 timePrevChat: data.timestamp,
  //                 itsAutoSend: false,
  //                 sendingFailed: false,
  //                 sendingSuccess: true,
  //                 imgUrl: data.media,
  //               );
  //             },
  //           ),
  //           const SizedBox(
  //             height: 120,
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget chatBoxInputContainer(isKeyboardOpen) {
    return Padding(
      padding: isKeyboardOpen
          ? EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
          : const EdgeInsets.all(1.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            // visible: showInputOption,
            // child: inputMenuOption(),
            duration: const Duration(milliseconds: 300),
            curve: Curves.bounceOut,
            // height: showInputOption ? 180 : 0,
            padding: showInputOption
                ? const EdgeInsets.fromLTRB(20, 0, 0, 20)
                : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: showInputOption ? inputMenuOption() : null,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            width: double.infinity,
            height: _image == null ? 70 : 150,
            constraints: BoxConstraints(
              minHeight: _image == null ? 70 : 150,
              maxHeight: 200,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius: 20,
                    spreadRadius: 0,
                    color: Warna.shadow.withOpacity(0.12),
                    offset: const Offset(0, 0)),
              ],
            ),
            child: Column(
              children: [
                _image == null
                    ? Container()
                    : Container(
                        // height: 60,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        width: double.infinity,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Warna.abu),
                                    );
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _image = null;
                                });
                              },
                              icon: Icon(
                                UIcons.solidRounded.cross_circle,
                                color: Warna.like,
                              ),
                              color: Warna.like,
                            )
                          ],
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 50,
                      width: 50,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            showInputOption = !showInputOption;
                          });

                          if (showInputOption) {
                            setState(() {
                              inputOptionAnimationController.forward();
                            });
                          } else {
                            setState(() {
                              inputOptionAnimationController.reset();
                            });
                          }
                        },
                        icon: RotationTransition(
                            turns: Tween(begin: 0.0, end: 0.38)
                                .animate(inputOptionAnimationController),
                            child: Icon(
                              UIcons.solidRounded.plus_small,
                            )),
                        iconSize: 28,
                        color: showInputOption ? Colors.white : Warna.biru,
                        disabledColor: Colors.white,
                        focusColor: Warna.kuning,
                        style: IconButton.styleFrom(
                            animationDuration:
                                const Duration(milliseconds: 800),
                            backgroundColor:
                                showInputOption ? Warna.biru : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                              side: BorderSide(color: Warna.abu4, width: 1),
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextInputC(
                        controller: inputMessageController,
                        borderRadius: 61,
                        borderColor: Warna.abu4,
                        hintText: 'Ketik Pesan',
                        hintStyle: AppTextStyles.placeholderInput,
                        minLines: 1,
                        maxLines: 12,
                        onChanged: (p0) {
                          if (inputMessageController.text.isNotEmpty) {
                            setState(() {
                              sendMessage = true;
                            });
                          } else {
                            setState(() {
                              sendMessage = false;
                            });
                          }
                        },
                      ),
                    ),
                    sendMessage == true &&
                                inputMessageController.text.isNotEmpty ||
                            _image != null
                        ? AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.bounceOut,
                            padding: const EdgeInsets.only(left: 6),
                            child: IconButton(
                              onPressed: () {
                                postMessage();
                                // setState(() {
                                //   sendMessage = false;
                                //   inputMessageController.text = '';
                                //   isClick = true;
                                //   isClick1 = true;
                                // });
                              },
                              icon: const Icon(Icons.send_sharp),
                              iconSize: 30,
                              color: Warna.kuning,
                              padding: const EdgeInsets.all(10),
                            ),
                          )
                        : Container(
                            width: 0,
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget customChatBubble({
    bool? isSender,
    String? text,
    String? times,
    String? imgUrl,
    String? productImageUrl,
    String? productId,
    String? productName,
    String? productPrice,
    String? productTotal,
    bool? itsAutoSend,
    String? timePrevChat,
    bool sendingSuccess = false,
    bool sendingFailed = false,
    File? mediaLocal,
  }) {
    // log('${AppConfig.URL_IMAGES_PATH}$imgUrl');
    return ChatBubble(
      // User CLipper 1 and Clipper 5
      clipper: times! == timePrevChat
          ? ChatBubbleClipper5(
              type:
                  isSender! ? BubbleType.sendBubble : BubbleType.receiverBubble,
            )
          : ChatBubbleClipper1(
              type:
                  isSender! ? BubbleType.sendBubble : BubbleType.receiverBubble,
            ),
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      margin: times == timePrevChat
          ? isSender
              ? const EdgeInsets.only(top: 10, right: 15)
              : const EdgeInsets.only(top: 10, left: 15)
          : const EdgeInsets.only(top: 20),

      backGroundColor: isSender ? Warna.kuning : Colors.white,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        // width: 100,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          // maxWidth: double.infinity,
          // minWidth: 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Chat section
            productId == null
                ? const SizedBox(
                    width: 0,
                  )
                : Container(
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                      maxHeight: 110,
                      minHeight: 110,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Warna.abu,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.network(
                              '${AppConfig.URL_IMAGES_PATH}$imgUrl',
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Warna.abu,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  productId,
                                  style: AppTextStyles.placeholderInput,
                                ),
                                Text(
                                  productName!,
                                  style: AppTextStyles.productName,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  productPrice!,
                                  style: AppTextStyles.productPrice,
                                ),
                                Text(
                                  productTotal!,
                                  style: AppTextStyles.placeholderInput,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

            imgUrl == null || imgUrl == ''
                ? const SizedBox(
                    width: 0,
                  )
                : Container(
                    width: 200,
                    height: 200,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Warna.abu3,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '${AppConfig.URL_IMAGES_PATH}$imgUrl',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Warna.abu3,
                          ),
                        ),
                      ),
                    ),
                  ),

            mediaLocal == null
                ? const SizedBox(
                    width: 0,
                  )
                : Container(
                    width: 200,
                    height: 200,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Warna.abu3,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        mediaLocal,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Warna.abu3,
                          ),
                        ),
                      ),
                    ),
                  ),

            text == null || text == ''
                ? const SizedBox(
                    width: 0,
                  )
                : Flexible(
                    child: Text(
                      text,
                      style: AppTextStyles.textRegular,
                      textAlign: TextAlign.left,
                    ),
                  ),

            if (itsAutoSend!)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '[Pesan ini dikirimkan secara otomatis]',
                  style: TextStyle(
                    color: Warna.kuning,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            else
              Container(
                width: 0,
              ),

            // INDICATOR TIMES AND SENDED
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  times,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff737373),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  sendingFailed
                      ? CommunityMaterialIcons.message_alert_outline
                      : sendingSuccess
                          ? CommunityMaterialIcons.check
                          : CommunityMaterialIcons.timer_outline,
                  color: const Color(0xff4A4A4A),
                  size: 20,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
