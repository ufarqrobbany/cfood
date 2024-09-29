import 'package:cfood/custom/CToast.dart';
import 'package:cfood/screens/canteen.dart';
import 'package:cfood/screens/kantin_pages/order.dart';
import 'package:cfood/screens/kantin_pages/transaction.dart';
import 'package:cfood/screens/profile.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:uicons/uicons.dart';

class MainScreenCanteen extends StatefulWidget {
  const MainScreenCanteen({super.key});

  @override
  State<MainScreenCanteen> createState() => _MainScreenCanteenState();
}

List<dynamic> _pageMenuCanteen = [
  const OrderCanteenScreen(),
  const TransactionScreen(),
  const CanteenScreen(
    isOwner: true,
  ),
  ProfileScreen(
    userType: 'kantin',
  ),
];

List<String> _pageMenuNameCanteen = [
  'Pesanan',
  'Transakasi',
  'kantin',
  'Opsi',
];

class _MainScreenCanteenState extends State<MainScreenCanteen> {
  var selectedScreen = _pageMenuCanteen[0];
  DateTime? lastPressed;
  bool canPopNow = false;

  @override
  void initState() {
    super.initState();
  }

  void selectScreen(screen) {
    setState(() {
      selectedScreen = screen;
    });
  }

  void invokePopScope(bool diPop) {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackbarHasBeenClosed =
        lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2);

    if (backButtonHasNotBeenPressedOrSnackbarHasBeenClosed) {
      lastPressed = DateTime.now();
      // final snackBar = SnackBar(content: Text('Tekan sekali lagi untuk keluar'));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      showToast('Sekali lagi agar kamu bisa keluar',
          duration: Toast.lengthShort);
      setState(() {
        canPopNow = false;
      });
    } else {
      setState(() {
        canPopNow = true;
      });
    }
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
                page: _pageMenuCanteen[0],
                pageName: _pageMenuNameCanteen[0],
                iconsON: UIcons.solidRounded.home,
                iconsOff: UIcons.regularRounded.home,
              ),
              buttonMenu(
                  page: _pageMenuCanteen[1],
                  pageName: _pageMenuNameCanteen[1],
                  iconsON: UIcons.solidRounded.shopping_cart,
                  iconsOff: UIcons.regularRounded.shopping_cart),
              buttonMenu(
                page: _pageMenuCanteen[2],
                pageName: _pageMenuNameCanteen[2],
                iconsON: UIcons.solidRounded.receipt,
                iconsOff: UIcons.regularRounded.receipt,
              ),
              buttonMenu(
                page: _pageMenuCanteen[3],
                pageName: _pageMenuNameCanteen[3],
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
