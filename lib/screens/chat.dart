import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/background_image.dart';
import 'package:cfood/style.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:uicons/uicons.dart';

class ChatScreen extends StatefulWidget {
  final bool? isMerchant;
  final int? userId;
  final int? merchantId;
  const ChatScreen({super.key, this.isMerchant, this.userId, this.merchantId,});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  TextEditingController inputMessageController = TextEditingController();
  late final AnimationController inputOptionAnimationController; 
  bool sendMessage = false;
  bool showInputOption = false;

  @override
  void initState() {
    inputOptionAnimationController =  AnimationController(
      duration: const Duration(milliseconds: 500), 
      vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    inputOptionAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                  '/.jpg', 
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
              const SizedBox(width: 20,),
              widget.isMerchant! ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama toko / merchant', style: AppTextStyles.subTitle,),
                  Text('Nama Penjual disii', style: TextStyle(
                    fontSize: 15,
                    color: Warna.abu2,
                    fontWeight: FontWeight.w500,
                  ),)
                ],
              ) :
              const Text('Chat', style: AppTextStyles.subTitle,),
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
          chatBody(),
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
            offset: const Offset(0, 0)
          ),
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
              IconButton(onPressed: () {
                
              }, 
              icon: Icon(UIcons.solidRounded.picture),
              color: Colors.white,
              iconSize: 24,
              constraints: const BoxConstraints(
                minHeight: 80, minWidth: 80,
                maxHeight: 80, maxWidth: 80,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Warna.biru,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                )
              ),
              ),
              const SizedBox(height: 10,),
              const Text('Galeri', style: AppTextStyles.textRegular,),
            ],
          ),
          const SizedBox(width: 20,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: () {
                
              }, 
              icon: Icon(UIcons.solidRounded.camera),
              color: Colors.white,
              iconSize: 24,
              constraints: const BoxConstraints(
                minHeight: 80, minWidth: 80,
                maxHeight: 80, maxWidth: 80,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Warna.biru,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                )
              ),
              ),
              const SizedBox(height: 10,),
              const Text('Kamera', style: AppTextStyles.textRegular,),
            ],
          ),
        ],
      ),
      );
  }

  Widget chatBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
           
        
            customChatBubble(
              isSender: false,
              // imgUrl: '',
              productImageUrl: '/',
              productId: '0',
              productName: 'Nama Product nya disini',
              productPrice: '10.000',
              productTotal: '3x',
              text: 'Text Chat nya disini aja kayaknya dan kayak gini contoh nya',
              times: '12.00',
              timePrevChat: '11.00',
              itsAutoSend: true,
               sendingFailed: false,
              sendingSuccess: false
            ),
            customChatBubble(
              isSender: false,
              text: 'Text chat ',
              times: '12.00',
              timePrevChat: '12.00',
              itsAutoSend: true,
               sendingFailed: false,
              sendingSuccess: false
            ),
            customChatBubble(
              isSender: false,
              imgUrl: '/',
              // text: 'Text chat ',
              times: '12.00',
              timePrevChat: '12.00',
              itsAutoSend: false,
               sendingFailed: false,
              sendingSuccess: false
            ),
             customChatBubble(
              isSender: false,
              imgUrl: '/',
              // text: 'Text chat ',
              times: '12.00',
              timePrevChat: '12.00',
              itsAutoSend: false,
               sendingFailed: false,
              sendingSuccess: false
            ),

            customChatBubble(
              isSender: true,
              text: 'Text chat jawabannya juga disini dan ini contoh nya',
              times: '12.02',
              timePrevChat: '12.00',
              itsAutoSend: false,
              sendingFailed: false,
              sendingSuccess: false
            ),
             customChatBubble(
              isSender: true,
              // text: 'Text chat ',
              imgUrl: '/',
              times: '12.02',
              timePrevChat: '12.02',
              itsAutoSend: false,
              sendingSuccess: true,
            ),
            customChatBubble(
              isSender: true,
              text: 'Text chat ',
              times: '12.02',
              timePrevChat: '12.02',
              itsAutoSend: false,
              sendingFailed: true,
              sendingSuccess: false,
            ),


            const SizedBox(height: 120,)
          ],
        ),
      ),
    );
  }

  Widget chatBoxInputContainer(isKeyboardOpen) {
    return  Padding(
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
              padding: showInputOption ? const EdgeInsets.fromLTRB(20, 0, 0, 20) :  const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: showInputOption ? inputMenuOption() : null,
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              width: double.infinity,
              height: 70,
              constraints: const BoxConstraints(
                minHeight: 70,
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
                  offset: const Offset(0, 0)
                ),
                ],
              ),
              child: Row(
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
                        inputOptionAnimationController.forward();
                       } else {
                        inputOptionAnimationController.reset();
                       }
                      },
                      icon:  RotationTransition(
                        turns: Tween(begin: 0.0, end: 0.38).animate(inputOptionAnimationController),
                        child: Icon(UIcons.solidRounded.plus_small,)),
                      iconSize: 28,
                      color:  showInputOption ? Colors.white : Warna.biru,
                      disabledColor: Colors.white,
                      focusColor: Warna.kuning,
                      style: IconButton.styleFrom(
                        animationDuration: const Duration(milliseconds: 800),
                        backgroundColor: showInputOption ? Warna.biru : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                          side: BorderSide(color: Warna.abu4, width: 1),
                        )
                      ),
                    ),
                  ),
                  const SizedBox(width: 16,),
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
                        if(inputMessageController.text.isNotEmpty) {
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
                  sendMessage == true && inputMessageController.text.isNotEmpty ?
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.bounceOut,
                    padding: const EdgeInsets.only(left: 6),
                    child: IconButton(onPressed: () {
                      setState(() {
                        sendMessage = false;
                        inputMessageController.text = '';
                      });
                    }, icon: const Icon(Icons.send_sharp),
                    iconSize: 30,
                    color: Warna.kuning,
                    padding: const EdgeInsets.all(10),
                    ),
                  ) : Container(width: 0,),
                ],
              ),
            ),
          ],
        ),
      );
  }

  Widget customChatBubble(
    {
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
    }
  ){
    return ChatBubble(
      // User CLipper 1 and Clipper 5
            clipper: 
            times! == timePrevChat ?
               ChatBubbleClipper5(
              type: isSender! ? BubbleType.sendBubble : BubbleType.receiverBubble,
              )
            : ChatBubbleClipper1(
              type: isSender! ? BubbleType.sendBubble : BubbleType.receiverBubble,
              ),
            alignment: isSender ? Alignment.topRight : Alignment.topLeft,
            margin: times == timePrevChat ? 
            isSender ? const EdgeInsets.only(top: 10, right: 15)  : const EdgeInsets.only(top: 10, left: 15) 
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
                  productId == null ? const SizedBox(width: 0,) :
                  Container(
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
                            child: Image.network('',
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Warna.abu,
                              ),
                            ),
                            ),
                          ),
                          const SizedBox(width: 8,),
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

                  imgUrl == null ? const SizedBox(width: 0,) :
                  Container(
                    width: 200,
                    height: 200,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Warna.abu3,
                    ),
                    child: Image.network(
                      imgUrl,
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

                  text == null ? const SizedBox(width: 0,) :        
                  Flexible(
                    child: Text(
                     text,
                      style: AppTextStyles.textRegular,
                      textAlign: TextAlign.left,
                    ),
                  ),
              
                  if (itsAutoSend!) Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      '[Pesan ini dikirimkan secara otomatis]',
                      style: TextStyle(
                        color: Warna.kuning,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ) else Container(width: 0,),
                  
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
                      const SizedBox(width: 10,),
                      Icon(
                         sendingFailed ? CommunityMaterialIcons.message_alert_outline : sendingSuccess ? CommunityMaterialIcons.check : CommunityMaterialIcons.timer_outline,
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