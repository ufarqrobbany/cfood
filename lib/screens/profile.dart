// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

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
import 'package:cfood/screens/kurir_pages/chat_seller.dart';
import 'package:cfood/screens/kurir_pages/order_available.dart';
import 'package:cfood/screens/kurir_pages/order_status.dart';
import 'package:cfood/screens/login.dart';
import 'package:cfood/screens/main.dart';
import 'package:cfood/screens/user_info.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/auth.dart';
import 'package:cfood/utils/constant.dart';
import 'package:cfood/utils/prefs.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:uicons/uicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

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
  bool? isStudent;

  File? _image;
  File? _image_temp;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    isStudent = false;
    getUserData(context);
    log('usertype : ${AppConfig.USER_TYPE}\n userId : ${AppConfig.USER_ID}\n${AppConfig.NAME}');
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 10));

    log('reload...');
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

      if (studentInfo != null) {
        isStudent = true;
      } else {
        isStudent = false;
      }
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

    if (dataResponse.data != null) {
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
      floatingActionButton: _image != null
          ? Stack(
              children: [
                Positioned(
                  bottom:
                      80, // Adjust this value to move it up (higher values move it up)
                  right: 0, // Adjust this value to place it at the right edge
                  child: SizedBox(
                    height: 45,
                    child: DynamicColorButton(
                      onPressed: () {
                        uploadPhotoProfile(context);
                      },
                      icon: const Icon(Icons.save, color: Colors.white),
                      text: 'Simpan foto profil',
                      fontWeight: FontWeight.w500,
                      backgroundColor: Warna.biru,
                      borderRadius: 30,
                    ),
                  ),
                ),
              ],
            )
          : null,
      body: ReloadIndicatorType1(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              profileBoxHeader(),
              joinWirausahaNotifBox(),
              studentInfo?.id != null
                  ? AppConfig.IS_DRIVER == true
                      ? Container()
                      : joinDriverNotifBox()
                  : Container(),
              AppConfig.IS_DRIVER == true ? boxDriverTasks() : Container(),
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
                            // context.pushReplacementNamed('main');
                            navigateToRep(context, const MainScreen());
                          },
                        ),
                      ],
                    )
                  : sectionMenuBox(
                      title: 'Akun',
                      items: [
                        isStudent == true
                            ? menuItemContainer(
                                icons: UIcons.solidRounded.graduation_cap,
                                showBorder: true,
                                text: 'Informasi Mahasiwa',
                                onTap: () {
                                  navigateTo(
                                      context, const UserInformationScreen());
                                },
                              )
                            : const SizedBox.shrink(),
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

  // Widget profileBoxHeader() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 24),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         profileBox(),
  //         const SizedBox(
  //           height: 10,
  //         ),
  //         Text(
  //           AppConfig.NAME == '' ? '' : AppConfig.NAME,
  //           style: const TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.w700,
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 8,
  //         ),
  //         Text(
  //           AppConfig.EMAIL == '' ? '' : AppConfig.EMAIL,
  //           style: const TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Future<void> uploadPhotoProfile(BuildContext context) async {
    if (_image == null) return;

    var dio = Dio();
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        _image!.path,
        filename: path.basename(_image!.path),
        contentType: MediaType(
            'image', path.extension(_image!.path).replaceAll('.', '')),
      ),
    });

    try {
      var response = await dio.post(
        '${AppConfig.BASE_URL}users/${AppConfig.USER_ID}/upload-photo',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        // print('Photo uploaded successfully');
        showToast('Berhasil Mengubah Foto');
        setState(() {
          _image_temp = _image;
          _image = null; // Reset _image to null after successful upload
        });
      } else {
        // Handle error response
        // print('Failed to upload photo');
        showToast('Gagal Mengubah Foto');
      }
    } catch (e) {
      // print('Error: $e');
      // showToast(e.toString());
      if (e is DioException && e.response?.statusCode == 502) {
        showToast('Ukuran Gambar Terlalu Besar');
      } else {
        showToast('Gagal Mengubah Foto');
      }
      setState(() {
        _image = null; // Reset _image to null after successful upload
      });
    }
  }

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

//Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future showOptionsPicker() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  Widget profileBoxHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              showOptionsPicker();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  color: Warna.abu,
                ),
                child: _image != null
                    ? Image.file(
                        _image!,
                        fit: BoxFit.cover,
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
                      )
                    : _image_temp != null
                        ? Image.file(
                            _image_temp!,
                            fit: BoxFit.cover,
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
                          )
                        : Image.network(
                            dataUser?.userPhoto != null
                                ? '${AppConfig.URL_IMAGES_PATH}${dataUser?.userPhoto}'
                                : 'https://i.pinimg.com/originals/d9/d8/8e/d9d88e3d1f74e2b8ced3df051cecb81d.jpg',
                            fit: BoxFit.cover,
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
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            dataUser?.name ?? AppConfig.NAME,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            dataUser?.email ?? AppConfig.EMAIL,
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

  Widget boxDriverTasks() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          color: Warna.kuning.withOpacity(0.10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Kurir',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Warna.regulerFontColor,
                ),
              ),
            ],
          ),
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
            color: Warna.kuning.withOpacity(0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                driverItemsMenu(
                  onTap: () {
                    navigateTo(context, const OrderAvailableScreen());
                  },
                  icons: Icons.move_to_inbox,
                  text: 'Pesanan Tersedia',
                  notifCount: 7,
                ),
                driverItemsMenu(
                  onTap: () {
                    navigateTo(
                        context,
                        const DriverOrderStatusScreen(
                          orderId: 1,
                        ));
                  },
                  icons: UIcons.solidRounded.bike,
                  text: 'Pengantaran',
                  notifCount: 7,
                ),
                driverItemsMenu(
                  onTap: () {
                    navigateTo(context, ChatSellerScreen());
                  },
                  icons: UIcons.solidRounded.comment,
                  text: 'Chat Pembeli',
                  notifCount: 7,
                ),
              ],
            )),
      ],
    );
  }

  Widget driverItemsMenu(
      {VoidCallback? onTap,
      IconData? icons,
      String? text,
      int notifCount = 0}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icons,
                size: 30,
                color: Warna.biru,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                text!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: 15,
                height: 15,
                // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                  color: Warna.kuning,
                  borderRadius: BorderRadius.circular(33),
                ),
                child: Center(
                  child: Text(
                    notifCount.toString(),
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
