import 'dart:developer';

import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/get_user_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/cart.dart';
import 'package:cfood/screens/home.dart';
import 'package:cfood/screens/order.dart';
import 'package:cfood/screens/profile.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/auth.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:uicons/uicons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

List<dynamic> _pageMenu = [
  const HomeScreen(),
  const CartScreen(),
  const OrderScreen(),
  ProfileScreen(
    userType: 'reguler',
  ),
];

List<String> _pageMenuName = [
  'Beranda',
  'Keranjang',
  'Pesanan',
  'Akun',
];

class _MainScreenState extends State<MainScreen> {
  var selectedScreen = _pageMenu[0];
  DateTime? lastPressed;
  bool canPopNow = false;

  DataUser? dataUser;
  DataUserCampus? userCampus;
  StudentInformation? studentInfo;
  DataUserMajor? studentMajor;
  StudyProgram? studentStudyProgram;

  @override
  void initState() {
    super.initState();

    if (dataUser == null) {
      log(AppConfig.USER_ID.toString());
      getUserData(context);
    }
  }

  Future<void> getUserData(BuildContext context) async {
    try {
      GetUserResponse userResponse = await FetchController(
        endpoint: 'users/${AppConfig.USER_ID}',
        fromJson: (json) => GetUserResponse.fromJson(json),
      ).getData();

      if (userResponse.data != null) {
        setState(() {
          dataUser = userResponse.data;
          userCampus = dataUser?.campus;
          studentInfo = dataUser?.studentInformation;
          studentMajor = studentInfo?.major;
          studentStudyProgram = studentInfo?.studyProgram;

          AppConfig.NAME = dataUser?.name ?? '';
          AppConfig.USER_ID = dataUser?.id ?? 0;
          AppConfig.STUDENT_ID = studentInfo?.id ?? 0;
          AppConfig.USER_CAMPUS_ID = userCampus!.id!;
          AppConfig.USER_TYPE = dataUser?.isPenjual ?? 'reguler';
          AppConfig.IS_DRIVER = dataUser?.kurir ?? false;
          AppConfig.URL_PHOTO_PROFILE =
              '${AppConfig.URL_PHOTO_PROFILE}${dataUser?.userPhoto ?? ''}';
        });

        AuthHelper().setUserData(
          userId: dataUser?.id.toString(),
          studentId: studentInfo?.id.toString(),
          username: dataUser?.name,
          isDriver: dataUser?.kurir == false ? 'no' : 'yes',
          type: dataUser?.isPenjual,
          userPhoto: dataUser?.userPhoto,
        );
      } else {
        log('Data user is null');
      }
    } catch (e) {
      log('Failed to fetch user data: $e');
    }
  }

  // Future<void> getUserData(BuildContext context) async {
  //   GetUserResponse userResponse = await FetchController(
  //     endpoint: 'users/${AppConfig.USER_ID}',
  //     fromJson: (json) => GetUserResponse.fromJson(json),
  //   ).getData();

  //   setState(() {
  //     dataUser = userResponse.data;
  //     userCampus = dataUser?.campus;
  //     studentInfo = dataUser?.studentInformation;
  //     studentMajor = studentInfo?.major;
  //     studentStudyProgram = studentInfo?.studyProgram;

  //     AppConfig.NAME = dataUser!.name!;
  //     AppConfig.USER_ID = dataUser!.id!;
  //     AppConfig.STUDENT_ID = studentInfo!.id!;
  //     AppConfig.USER_TYPE = dataUser?.isPenjual ?? 'reguler';
  //     AppConfig.IS_DRIVER = dataUser!.kurir!;
  //     AppConfig.URL_PHOTO_PROFILE = '${AppConfig.URL_PHOTO_PROFILE}${dataUser!.userPhoto}';
  //   });

  //   AuthHelper().setUserData(
  //     userId: dataUser?.id.toString(),
  //     studentId: studentInfo?.id.toString(),
  //     username: dataUser?.name,
  //     isDriver: dataUser?.kurir == false ? 'no' : 'yes',
  //     type: dataUser?.isPenjual,
  //     userPhoto: dataUser?.userPhoto,
  //   );
  // }

  void selectScreen(screen) {
    setState(() {
      selectedScreen = screen;
    });
  }

  bool invokePopScope(bool diPop) {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackbarHasBeenClosed =
        lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2);

    if (backButtonHasNotBeenPressedOrSnackbarHasBeenClosed) {
      lastPressed = DateTime.now();
      // final snackBar = SnackBar(content: Text('Tekan sekali lagi untuk keluar'));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      showToast('Sekali lagi agar kamu bisa keluar hehe',
          duration: Toast.lengthShort);
      setState(() {
        canPopNow = false;
      });
    } else {
      setState(() {
        canPopNow = true;
      });
    }

    return canPopNow;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPopNow,
      onPopInvoked: invokePopScope,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          child: selectedScreen,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          height: 80,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                blurRadius: 20,
                spreadRadius: 0,
                color: Warna.shadow.withOpacity(0.10),
                offset: const Offset(0, 0))
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buttonMenu(
                page: _pageMenu[0],
                pageName: _pageMenuName[0],
                iconsON: UIcons.solidRounded.home,
                iconsOff: UIcons.regularRounded.home,
              ),
              buttonMenu(
                  page: _pageMenu[1],
                  pageName: _pageMenuName[1],
                  iconsON: UIcons.solidRounded.shopping_cart,
                  iconsOff: UIcons.regularRounded.shopping_cart),
              buttonMenu(
                page: _pageMenu[2],
                pageName: _pageMenuName[2],
                iconsON: UIcons.solidRounded.receipt,
                iconsOff: UIcons.regularRounded.receipt,
              ),
              buttonMenu(
                page: _pageMenu[3],
                pageName: _pageMenuName[3],
                iconsON: UIcons.solidRounded.user,
                iconsOff: UIcons.regularRounded.user,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonMenu(
      {Widget? page, IconData? iconsON, IconData? iconsOff, String? pageName}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        // decoration: BoxDecoration(
        //   color: page == selectedScreen ? Warna.abu2.withOpacity(0.20) : Colors.white,
        //   border:  page == selectedScreen ? Border(top: BorderSide(color: Warna.biru, width: 4)) : null,
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => selectScreen(page),
              padding: EdgeInsets.zero,
              icon: Icon(
                page == selectedScreen ? iconsON : iconsOff,
              ),
              color: page == selectedScreen ? Warna.kuning : Warna.biru,
              iconSize: 24,
            ),
            Text(
              pageName!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: page == selectedScreen ? Warna.kuning : Warna.biru,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            )
          ],
        ),
      ),
    );
  }
}
