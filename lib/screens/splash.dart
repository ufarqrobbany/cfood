import 'dart:async';
import 'dart:developer';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/popup_dialog.dart';
import 'package:cfood/model/check_app_version.dart';
import 'package:cfood/model/reponse_handler.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/repository/login_repository.dart';
import 'package:cfood/screens/main.dart';
import 'package:cfood/screens/startup.dart';
import 'package:cfood/screens/wirausaha_pages/main.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/auth.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    debugPrint('on splah');
    log("on splash screen");
    onStartUpAPP(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Timer(const Duration(seconds: 3), () {
  //   context.pushReplacementNamed('startup');
  // });

  Future<void> onStartUpAPP(BuildContext context) async {
    try {
      // Mengambil versi aplikasi yang tersimpan di preferensi
      // Map<String, dynamic> dataVersion = await AuthHelper().getPrefVersionApp();
      // Constant.appVersion = dataVersion['version'];
      // Constant.appVersion = '2.0.0';

      // Memeriksa versi aplikasi dengan endpoint versi
      CheckVersionAppResponse versionResponse = await FetchController(
        endpoint: 'version/check?currentVersion=${Constant.appVersion}',
        fromJson: (json) => CheckVersionAppResponse.fromJson(json),
      ).getData();

      if (versionResponse.data?.isLatest == true) {
        // Menyimpan versi aplikasi terbaru
        await AuthHelper()
            .setAppVersion(version: versionResponse.data!.latestVersion);
        Constant.appVersion = versionResponse.data!.latestVersion!;

        // Mengambil data pengguna
        Map<String, dynamic> dataUser = await AuthHelper().getkUserData();

        if (dataUser['id'] == ''  &&
            dataUser['email'] == ''  &&
            dataUser['password'] == '' ) {
          log('go to startup');
          navigateToRep(context, const StartUpScreen());
        } else {
          if (dataUser['userid'].isNotEmpty) {
            AppConfig.USER_ID = int.parse(dataUser['userid']);
            AppConfig.NAME = dataUser['username'];
            AppConfig.EMAIL = dataUser['email'];
            AppConfig.USER_TYPE = dataUser['type'];
            AppConfig.IS_DRIVER = dataUser['isDriver'] == 'no' ? false : true;
          }

          // Melakukan login otomatis
          LoginResponse loginResponse = await FetchController(
            endpoint: 'users/login',
            fromJson: (json) => LoginResponse.fromJson(json),
          ).postData({
            "email": dataUser['email'],
            "password": dataUser['password'],
          });

          AppConfig.USER_ID = loginResponse.data!.userId!;

          if (AppConfig.USER_TYPE == 'reguler') {
            log('go to homepages');
            navigateToRep(context, const MainScreen());
          } else if (AppConfig.USER_TYPE == 'kantin') {
            log('go to kantin pages');
          } else if (AppConfig.USER_TYPE == 'wirausaha') {
            try {
              Map<String, dynamic> merchantData =
                  await AuthHelper().getDataMerchantId();
              log('cek merchantId : ${merchantData['merchantId']}');
              if (merchantData['merchantId'].isNotEmpty) {
                AppConfig.MERCHANT_ID = int.parse(merchantData['merchantId']);
              }
              AppConfig.ON_DASHBOARD = true;
              log('go as wirausahawan');
              navigateToRep(context, const MainScreenMerchant());
            } catch (e) {
              log(e.toString());
              log('go to homepages');
              navigateToRep(context, const MainScreen());
            }
          } else if (AppConfig.USER_TYPE == 'kurir') {
            log('go to kurir pages');
          }
        }
      } else {
        await AuthHelper()
            .setAppVersion(version: versionResponse.data!.latestVersion);
        Constant.appVersion = versionResponse.data!.latestVersion!;
        showMyCustomDialog(context,
            text: 'Versi aplikasi C-Food terbaru telah tersedia ayo update!!',
            justYEs: true,
            onTapYes: () {
              openUrl(Uri.parse('https://campusfood.id'));
            });
      }
    } catch (e) {
      log('Error during startup: $e');
      navigateToRep(context, const StartUpScreen());
    }
  }

  Future<void> openUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  // Future<void> onStartUpAPP(BuildContext context) async {
  //   Map<String, dynamic> dataVersion = await AuthHelper().getPrefVersionApp();
  //   setState(() {
  //     Constant.appVersion = dataVersion['version'];
  //   });
  //   CheckVersionAppResponse versionResponse = await FetchController(
  //     endpoint: 'version/check?currentVersion=${Constant.appVersion}',
  //     fromJson: (json) => ResponseHendler.fromJson(json),
  //   ).getData();

  //   if(versionResponse.data?.isLatest == true) {
  //      setState(() {
  //     AuthHelper().setAppVersion(version: versionResponse.data!.latestVersion);
  //     Constant.appVersion = versionResponse.data!.latestVersion!;

  //     try {
  //     // AuthHelper().setUserData(); // Uncomment if needed
  //     Map<String, dynamic> dataUser = await AuthHelper().getkUserData();

  //     if (dataUser['id'] == '' &&
  //         dataUser['email'] == '' &&
  //         dataUser['password'] == '') {
  //       log('go to startup');
  //       // context.pushReplacementNamed('startup');
  //       Timer(const Duration(seconds: 1), () {
  //         // context.pushReplacementNamed('startup');
  //         navigateToRep(context, const StartUpScreen());
  //       });
  //     } else {
  //       if (dataUser['userid'] != '') {
  //         AppConfig.USER_ID = int.parse(dataUser['userid']);
  //         AppConfig.NAME = dataUser['username'];
  //         AppConfig.EMAIL = dataUser['email'];
  //         AppConfig.USER_TYPE = dataUser['type'];
  //         AppConfig.IS_DRIVER = dataUser['isDriver'] == 'no' ? false : true;
  //       }

  //       LoginResponse loginResponse = await FetchController(
  //         endpoint: 'users/login',
  //         fromJson: (json) => LoginResponse.fromJson(json),
  //       ).postData({
  //         "email": dataUser['email'],
  //         "password": dataUser['password'],
  //       });

  //       setState(() {
  //         AppConfig.USER_ID = loginResponse.data!.userId!;
  //       });

  //       if (AppConfig.USER_TYPE == 'reguler') {
  //         // ignore: use_build_context_synchronously
  //         log('go to homepages');
  //         navigateToRep(context, const MainScreen());
  //         // context.pushReplacementNamed('main');
  //       } else if (AppConfig.USER_TYPE == 'kantin') {
  //         log('go to kantin pages');
  //       } else if (AppConfig.USER_TYPE == 'wirausaha') {
  //         try {
  //           Map<String, dynamic> merchantData =
  //               await AuthHelper().getDataMerchantId();

  //           log('cek merchantId : ${merchantData['merchantId']}');
  //           if (merchantData['merchantId'] != null ||
  //               merchantData['merchantId'] != '') {
  //             AppConfig.MERCHANT_ID = int.parse(merchantData['merchantId']);
  //           }

  //           setState(() {
  //             AppConfig.ON_DASHBOARD = true;
  //           });
  //           log('go as wirausahawan');
  //           // navigateToRep(context, const MainScreen());
  //           navigateToRep(context, const MainScreenMerchant());
  //         } on Exception catch (e) {
  //           log(e.toString());
  //           log('go to homepages');
  //           navigateToRep(context, const MainScreen());
  //         }
  //       } else if (AppConfig.USER_TYPE == 'kurir') {
  //         log('go to kurir pages');
  //       }
  //     }
  //   } catch (e) {
  //     // Handle error and log it
  //     log('Error during startup: $e');
  //     Timer(const Duration(seconds: 3), () {
  //       // context.pushReplacementNamed('startup');
  //       navigateToRep(context, const StartUpScreen());
  //     });

  //     // Optional: Show an error message to the user or navigate to an error page
  //     // For example, you might navigate to an error page if needed:
  //     // navigateToRep(context, const ErrorScreen());
  //   }
  //   });

  //   } else {
  //   setState(() {
  //     AuthHelper().setAppVersion(version: versionResponse.data!.latestVersion);
  //     Constant.appVersion = versionResponse.data!.latestVersion!;
  //   });
  //     showMyCustomDialog(context, text: 'Versi aplikasi C-Food terbaru telah tersedia ayo update!!');
  //     return;
  //   }

  // }

  Future<void> checkAppVersion() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 15,
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          Container(
            padding: const EdgeInsets.only(
              bottom: 50,
            ),
            height: MediaQuery.of(context).size.height * 0.50,
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/logo.png',
                height: 200,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.10,
            ),
            height: MediaQuery.of(context).size.height * 0.25,
            child: const Column(
              children: [
                Text(
                  'Master Seafood',
                  style: AppTextStyles.labelInput,
                ),
                Text(
                  'v1.0.0',
                  style: AppTextStyles.textRegular,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
