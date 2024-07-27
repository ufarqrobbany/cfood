import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/add_driver_response.dart';
import 'package:cfood/model/get_user_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/app_setting_info.dart';
import 'package:cfood/screens/inbox.dart';
import 'package:cfood/screens/kantin_pages/main.dart';
import 'package:cfood/screens/login.dart';
import 'package:cfood/screens/user_info.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/auth.dart';
import 'package:cfood/utils/constant.dart';
import 'package:cfood/utils/prefs.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toast/toast.dart';
import 'package:uicons/uicons.dart';

class ProfileScreen extends StatefulWidget {
  String? userType;
  ProfileScreen({super.key, this.userType});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DataUser? dataUser;
  DataUserCampus? userCampus;
  StudentInformation? studentInfo;

  @override
  void initState() {
    super.initState();
    // getUserData(context);
    log('usertype : ${AppConfig.USER_TYPE}\n userId : ${AppConfig.USER_ID}');
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 10));

    print('reload...');
  }

  Future<void> getUserData(BuildContext context) async {
    GetUserResponse userResponse = await FetchController(
      endpoint: 'users/${AppConfig.USER_ID}',
      fromJson: (json) => GetUserResponse.fromJson(json),
    ).getData();

    setState(() {
      dataUser = userResponse.data;
      userCampus = dataUser!.campus;
      studentInfo = dataUser!.studentInformation;
    });
  }

  void tapLogOut(BuildContext context) {
    AuthHelper().clearUserData();
    AuthHelper().chackUserData();
    navigateToRep(context, const LoginScreen());
    // context.pushReplacementNamed('login');
  }



  Future<void> addDriver(BuildContext context) async {
    AddDriverResponse dataResponse = await FetchController(
      endpoint: 'drivers/',
      fromJson: (json) => AddDriverResponse.fromJson(json),
    ).postData({
      'studentId': studentInfo?.id,
    });

    showToast(dataResponse.message!);

    if(dataResponse.data != null) {
      log('$dataResponse');

      setState(() {
        AppConfig.IS_DRIVER = true;
        SessionManager().setIsDriver('yes');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 25,
        leading: Container(
          width: 0,
        ),
        title: const Text(
          'Akun',
          style: AppTextStyles.title,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        actions: [
          notifIconButton(
            icons: UIcons.solidRounded.bell,
            iconColor: Warna.biru,
            notifCount: '22',
          ),
          const SizedBox(
            width: 10,
          ),
          notifIconButton(
            icons: UIcons.solidRounded.comment,
            notifCount: '5',
            iconColor: Warna.biru,
            onPressed: () => navigateTo(
                context,
                InboxScreen(
                  canBack: true,
                )),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ReloadIndicatorType1(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              profileBoxHeader(),
              joinWirausahaNotifBox(),
              studentInfo?.id != null ?
              joinDriverNotifBox() : Container(),
              widget.userType == 'kantin'
                  ? sectionMenuBox(
                      title: 'Akun',
                      items: [
                        menuItemContainer(
                          icons: UIcons.solidRounded.store_alt,
                          showBorder: true,
                          text: 'Informasi Kantin',
                          onTap: () {
                            // navigateToRep(context, const MainScreenCanteen());
                          },
                        ),
                        menuItemContainer(
                          icons: UIcons.solidRounded.credit_card,
                          showBorder: true,
                          text: 'Rekening',
                          onTap: () {},
                        ),
                        menuItemContainer(
                          icons: UIcons.solidRounded.exit,
                          showBorder: false,
                          text: 'Keluar',
                          onTap: () {
                            context.pushReplacementNamed('main');
                          },
                        ),
                      ],
                    )
                  : sectionMenuBox(
                      title: 'Akun',
                      items: [
                        menuItemContainer(
                          icons: UIcons.solidRounded.graduation_cap,
                          showBorder: true,
                          text: 'Informasi Mahasiwa',
                          onTap: () {
                            navigateTo(context, const UserInformationScreen());
                          },
                        ),
                        menuItemContainer(
                          icons: UIcons.solidRounded.marker,
                          showBorder: true,
                          text: 'Lokasi Antar',
                          onTap: () {},
                        ),
                        menuItemContainer(
                          icons: UIcons.solidRounded.sign_out_alt,
                          showBorder: false,
                          text: 'Keluar',
                          onTap: () {
                            tapLogOut(context);
                          },
                        ),
                      ],
                    ),
              sectionMenuBox(
                title: 'Info Lainnya',
                items: [
                  menuItemContainer(
                    icons: UIcons.solidRounded.shield,
                    showBorder: true,
                    text: 'Kebijakan Privasi',
                    onTap: () {
                      navigateTo(
                        context,
                        const AppSettingsInformation(
                          type: 'Kebijakan Privasi',
                          title: 'Kebijakan Privasi',
                        ),
                      );
                    },
                  ),
                  menuItemContainer(
                    icons: UIcons.solidRounded.document,
                    showBorder: true,
                    text: 'Ketentuan Layanan',
                    onTap: () {
                      navigateTo(
                        context,
                        const AppSettingsInformation(
                          type: 'Ketentuan Layanan',
                          title: 'Ketentuan Layanan',
                        ),
                      );
                    },
                  ),
                  menuItemContainer(
                    icons: UIcons.solidRounded.map_marker,
                    showBorder: true,
                    text: 'Atribusi Data',
                    onTap: () {
                      navigateTo(
                        context,
                        const AppSettingsInformation(
                          type: 'Atribusi Data',
                          title: 'Atribusi Data',
                        ),
                      );
                    },
                  ),
                  menuItemContainer(
                    icons: UIcons.solidRounded.star,
                    showBorder: false,
                    text: 'Beri Bintang',
                    onTap: () {},
                  ),
                ],
              ),
              sectionMenuBox(
                title: 'dev shortcut',
                items: [
                  menuItemContainer(
                    icons: UIcons.solidRounded.store_alt,
                    showBorder: true,
                    text: 'Halaman Canteens',
                    onTap: () {
                      navigateToRep(context, const MainScreenCanteen());
                      // context.pushReplacementNamed('main-canteen');
                    },
                  ),
                  menuItemContainer(
                    icons: UIcons.solidRounded.bike,
                    showBorder: true,
                    text: 'Halaman Kurir',
                    onTap: () {},
                  ),
                  menuItemContainer(
                    icons: UIcons.solidRounded.business_time,
                    showBorder: false,
                    text: 'Halaman Wirausaha',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileBoxHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              color: Warna.abu,
            ),
            child: Image.asset(
              '/.jpg',
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    color: Warna.abu,
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            AppConfig.NAME == '' ? '' : AppConfig.NAME,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            AppConfig.EMAIL == '' ? '' : AppConfig.EMAIL,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  Widget joinWirausahaNotifBox() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        // contentPadding: EdgeInsets.zero,
        dense: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        tileColor: Warna.kuning.withOpacity(0.10),
        leading: Icon(
          CommunityMaterialIcons.handshake,
          color: Warna.kuning,
        ),
        title: const Text(
          'Gabung Menjadi Wirausaha',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: const Text(
          'Buat akun wirausaha kamu untuk mulai berjualan',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward_ios_rounded),
          iconSize: 18,
          style: IconButton.styleFrom(
              backgroundColor: Warna.kuning,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
        ),
      ),
    );
  }

  Widget joinDriverNotifBox() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        // contentPadding: EdgeInsets.zero,
        dense: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        tileColor: Warna.kuning.withOpacity(0.10),
        leading: Icon(
          // CommunityMaterialIcons.box_cutter,
          UIcons.regularRounded.running,
          color: Warna.kuning,
        ),
        title: const Text(
          'Gabung Menjadi Kurir',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: const Text(
          'Tambah Penghasilanmu dengan menjadi kurir',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        trailing: IconButton(
          onPressed: () {
            _showMyDialog();
          },
          icon: const Icon(Icons.arrow_forward_ios_rounded),
          iconSize: 18,
          style: IconButton.styleFrom(
              backgroundColor: Warna.kuning,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: const EdgeInsets.all(10),
          title: const Text(
            'Apakah Anda siap menjadi kurir?',
            style: AppTextStyles.textRegular,
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actionsOverflowAlignment: OverflowBarAlignment.end,
          actionsOverflowDirection: VerticalDirection.down,
          actions: <Widget>[
            SizedBox(
              height: 50,
              width: 120,
              child: DynamicColorButton(
                onPressed: () {
                  navigateBack(context);
                },
                text: 'Tidak',
                textColor: Warna.regulerFontColor,
                backgroundColor: Warna.abu,
                borderRadius: 8,
              ),
            ),
            SizedBox(
              height: 50,
              width: 120,
              child: DynamicColorButton(
                onPressed: () {
                  addDriver(context);
                  navigateBack(context);
                },
                text: 'Ya',
                backgroundColor: Warna.kuning,
                borderRadius: 8,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget sectionMenuBox({String? title, List<Widget>? items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
          child: Text(
            title!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Warna.regulerFontColor,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: items!,
        )
      ],
    );
  }

  Widget menuItemContainer({
    IconData? icons,
    String? text,
    VoidCallback? onTap,
    bool showBorder = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 25,
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: showBorder
              ? Border(
                  bottom: BorderSide(
                    color: Warna.abu,
                    width: 1.5,
                  ),
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                icons!,
                size: 20,
                color: Warna.biru,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                text!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Warna.regulerFontColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
