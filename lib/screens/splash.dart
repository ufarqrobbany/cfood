<<<<<<< HEAD
import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:app_links/app_links.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/popup_dialog.dart';
import 'package:cfood/model/check_app_version.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/repository/login_repository.dart';
import 'package:cfood/screens/canteen.dart';
import 'package:cfood/screens/main.dart';
import 'package:cfood/screens/organization.dart';
import 'package:cfood/screens/startup.dart';
import 'package:cfood/screens/wirausaha_pages/main.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/auth.dart';
import 'package:cfood/utils/constant.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  Uri? appLinkUri;
  Map<String, dynamic>? dataUser;
  String iniTialRoute = '/splash';
  String menuId = '';
  String merchantId = '';
  String merchantType = '';
  String danusId = '';
  String organizationId = '';
  String userId = '';
  String kurirId = '';
  String orderId = '';
  String chatId = '';

  @override
  void initState() {
    debugPrint('on splah');
    log("on splash screen");
    initDeepLinks();
    onStartUpAPP(context);
    super.initState();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      // openAppLink(uri);
      setState(() {
        appLinkUri = uri;
      });
    });
  }

  void openAppLink(Uri uri) async {
    dataUser = await AuthHelper().getkUserData();
    log("APP LINK URI: $uri############");

    String decryptedUri =
        decryptUrl(uri.toString().replaceAll(AppConfig.APPLINK_DOMAIN, ''));
    Uri realUri = Uri.parse('${AppConfig.APPLINK_DOMAIN}$decryptedUri');
    log('real uri : $realUri');
    if (realUri.pathSegments.contains('menu')) {
      setState(() {
        menuId = realUri.queryParameters['menuId']!;
        merchantId = realUri.queryParameters['merchantId']!;
        merchantType = realUri.queryParameters['merchantType']!;
        iniTialRoute = '/menu';
        AppConfig.FROM_LINK = true;
      });
      log('goto menu screen menuId=$menuId, merchantId=$merchantId');
      navigateToRep(
        context,
        CanteenScreen(
          menuId: menuId,
          merchantId: int.parse(merchantId),
          merchantType: merchantType,
        ),
      );
    } else if (realUri.pathSegments.contains('merchant')) {
      setState(() {
        merchantId = realUri.queryParameters['merchantId']!;
        merchantType = realUri.queryParameters['merchantType']!;
        iniTialRoute = '/merchant';
        AppConfig.FROM_LINK = true;
      });
      log('goto merchant id=$merchantId, merchanType=$merchantType');
      navigateToRep(
        context,
        CanteenScreen(
          isOwner: false,
          merchantId: int.parse(merchantId),
          merchantType: merchantType,
          itsDanusan: false,
        ),
      );
    } else if (realUri.pathSegments.contains('danus')) {
      setState(() {
        danusId = realUri.queryParameters['danusId']!;
        iniTialRoute = '/danus';
        AppConfig.FROM_LINK = true;
      });
      log('goto merchant id=$merchantId, merchanType=$merchantType');
      navigateToRep(
        context,
        OrganizationScreen(
          id: int.parse(danusId),
        ),
      );
    } else {
      log('goto mainscreen');
      navigateToRep(context, const MainScreen());
    }
  }

  String decryptUrl(String encryptedUrl) {
    String keyString =
        'campusfoodempireempirecampusfood'; // Example key (32 bytes)

    final key = encrypt.Key.fromUtf8(keyString);

    // Pisahkan IV dan data terenkripsi berdasarkan pemisah titik dua
    final parts = encryptedUrl.split(':');
    if (parts.length != 2) {
      throw const FormatException('Invalid encrypted URL format');
    }

    // final iv = encrypt.IV.fromBase64(parts[0]);
    // final encrypted = encrypt.Encrypted.fromBase64(parts[1]);
    final iv = encrypt.IV(Uint8List.fromList(base62Decode(parts[0])));
    final encrypted =
        encrypt.Encrypted(Uint8List.fromList(base62Decode(parts[1])));
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

  String base62Chars =
      '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

  String base62Encode(List<int> bytes) {
    BigInt value = BigInt.parse(hex.encode(bytes), radix: 16);
    String result = '';

    while (value > BigInt.zero) {
      var remainder = value % BigInt.from(62);
      result = base62Chars[remainder.toInt()] + result;
      value = value ~/ BigInt.from(62);
    }

    return result.padLeft(
        8, '0'); // Pad untuk memastikan panjang yang konsisten
  }

  List<int> base62Decode(String base62) {
    BigInt value = BigInt.zero;
    for (int i = 0; i < base62.length; i++) {
      value =
          value * BigInt.from(62) + BigInt.from(base62Chars.indexOf(base62[i]));
    }

    String hexString = value.toRadixString(16);
    // Pastikan panjang hexString genap
    if (hexString.length % 2 != 0) hexString = '0$hexString';
    return hex.decode(hexString);
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
        Map<String, dynamic> toDash = await AuthHelper().getToDashboard();

        if (dataUser['id'] == '' &&
            dataUser['email'] == '' &&
            dataUser['password'] == '') {
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

          if (appLinkUri != null) {
            log('open applink : $appLinkUri');
            openAppLink(appLinkUri!);
          } else {
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
                if (toDash['dashboard'] == 'yes') {
                  AppConfig.ON_DASHBOARD = true;
                  log('go as wirausahawan');
                  navigateToRep(context, const MainScreenMerchant());
                } else {
                  navigateToRep(context, const MainScreen());
                }
              } catch (e) {
                log(e.toString());
                log('go to homepages');
                navigateToRep(context, const MainScreen());
              }
            } else if (AppConfig.USER_TYPE == 'kurir') {
              log('go to kurir pages');
            }
          }
        }
      } else {
        await AuthHelper()
            .setAppVersion(version: versionResponse.data!.latestVersion);
        Constant.appVersion = versionResponse.data!.latestVersion!;
        showMyCustomDialog(context,
            text:
                'Versi terbaru aplikasi C-Food sudah tersedia. Ayo segera update!',
            justYEs: true,
            yesText: "Update Sekarang", onTapYes: () async {
          // openUrl(Uri.parse('https://campusfood.id'));
          log('open url');
          final Uri url = Uri(scheme: 'https', host: 'www.campusfood.id');
          if (!await launchUrl(url)) {
            throw Exception(
                'Could not launch $url');
          }
        });
      }
    } catch (e) {
      log('Error during startup: $e');
      navigateToRep(context, const StartUpScreen());
    }
  }

  Future<void> openUrl(Uri url) async {
    log('open url');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

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
            child: Column(
              children: [
                const Text(
                  'Master Seafood',
                  style: AppTextStyles.labelInput,
                ),
                Text(
                  Constant.appVersion,
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
=======
import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:app_links/app_links.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/popup_dialog.dart';
import 'package:cfood/model/check_app_version.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/repository/login_repository.dart';
import 'package:cfood/screens/canteen.dart';
import 'package:cfood/screens/main.dart';
import 'package:cfood/screens/organization.dart';
import 'package:cfood/screens/startup.dart';
import 'package:cfood/screens/wirausaha_pages/main.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/auth.dart';
import 'package:cfood/utils/constant.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  Uri? appLinkUri;
  Map<String, dynamic>? dataUser;
  String iniTialRoute = '/splash';
  String menuId = '';
  String merchantId = '';
  String merchantType = '';
  String danusId = '';
  String organizationId = '';
  String userId = '';
  String kurirId = '';
  String orderId = '';
  String chatId = '';

  @override
  void initState() {
    debugPrint('on splah');
    log("on splash screen");
    initDeepLinks();
    onStartUpAPP(context);
    super.initState();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      // openAppLink(uri);
      setState(() {
        appLinkUri = uri;
      });
    });
  }

  void openAppLink(Uri uri) async {
    dataUser = await AuthHelper().getkUserData();
    log("APP LINK URI: $uri############");

    String decryptedUri =
        decryptUrl(uri.toString().replaceAll(AppConfig.APPLINK_DOMAIN, ''));
    Uri realUri = Uri.parse('${AppConfig.APPLINK_DOMAIN}$decryptedUri');
    log('real uri : $realUri');
    if (realUri.pathSegments.contains('menu')) {
      setState(() {
        menuId = realUri.queryParameters['menuId']!;
        merchantId = realUri.queryParameters['merchantId']!;
        merchantType = realUri.queryParameters['merchantType']!;
        iniTialRoute = '/menu';
        AppConfig.FROM_LINK = true;
      });
      log('goto menu screen menuId=$menuId, merchantId=$merchantId');
      navigateToRep(
        context,
        CanteenScreen(
          menuId: menuId,
          merchantId: int.parse(merchantId),
          merchantType: merchantType,
        ),
      );
    } else if (realUri.pathSegments.contains('merchant')) {
      setState(() {
        merchantId = realUri.queryParameters['merchantId']!;
        merchantType = realUri.queryParameters['merchantType']!;
        iniTialRoute = '/merchant';
        AppConfig.FROM_LINK = true;
      });
      log('goto merchant id=$merchantId, merchanType=$merchantType');
      navigateToRep(
        context,
        CanteenScreen(
          isOwner: false,
          merchantId: int.parse(merchantId),
          merchantType: merchantType,
          itsDanusan: false,
        ),
      );
    } else if (realUri.pathSegments.contains('danus')) {
      setState(() {
        danusId = realUri.queryParameters['danusId']!;
        iniTialRoute = '/danus';
        AppConfig.FROM_LINK = true;
      });
      log('goto merchant id=$merchantId, merchanType=$merchantType');
      navigateToRep(
        context,
        OrganizationScreen(
          id: int.parse(danusId),
        ),
      );
    } else {
      log('goto mainscreen');
      navigateToRep(context, const MainScreen());
    }
  }

  String decryptUrl(String encryptedUrl) {
    String _keyString =
        'campusfoodempireempirecampusfood'; // Example key (32 bytes)

    final key = encrypt.Key.fromUtf8(_keyString);

    // Pisahkan IV dan data terenkripsi berdasarkan pemisah titik dua
    final parts = encryptedUrl.split(':');
    if (parts.length != 2) {
      throw FormatException('Invalid encrypted URL format');
    }

    // final iv = encrypt.IV.fromBase64(parts[0]);
    // final encrypted = encrypt.Encrypted.fromBase64(parts[1]);
    final iv = encrypt.IV(Uint8List.fromList(base62Decode(parts[0])));
    final encrypted =
        encrypt.Encrypted(Uint8List.fromList(base62Decode(parts[1])));
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

  String base62Chars =
      '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

  String base62Encode(List<int> bytes) {
    BigInt value = BigInt.parse(hex.encode(bytes), radix: 16);
    String result = '';

    while (value > BigInt.zero) {
      var remainder = value % BigInt.from(62);
      result = base62Chars[remainder.toInt()] + result;
      value = value ~/ BigInt.from(62);
    }

    return result.padLeft(
        8, '0'); // Pad untuk memastikan panjang yang konsisten
  }

  List<int> base62Decode(String base62) {
    BigInt value = BigInt.zero;
    for (int i = 0; i < base62.length; i++) {
      value =
          value * BigInt.from(62) + BigInt.from(base62Chars.indexOf(base62[i]));
    }

    String hexString = value.toRadixString(16);
    // Pastikan panjang hexString genap
    if (hexString.length % 2 != 0) hexString = '0' + hexString;
    return hex.decode(hexString);
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
        Map<String, dynamic> toDash = await AuthHelper().getToDashboard();

        if (dataUser['id'] == '' &&
            dataUser['email'] == '' &&
            dataUser['password'] == '') {
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

          if (appLinkUri != null) {
            log('open applink : $appLinkUri');
            openAppLink(appLinkUri!);
          } else {
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
                if (toDash['dashboard'] == 'yes') {
                  AppConfig.ON_DASHBOARD = true;
                  log('go as wirausahawan');
                  navigateToRep(context, const MainScreenMerchant());
                } else {
                  navigateToRep(context, const MainScreen());
                }
              } catch (e) {
                log(e.toString());
                log('go to homepages');
                navigateToRep(context, const MainScreen());
              }
            } else if (AppConfig.USER_TYPE == 'kurir') {
              log('go to kurir pages');
            }
          }
        }
      } else {
        await AuthHelper()
            .setAppVersion(version: versionResponse.data!.latestVersion);
        Constant.appVersion = versionResponse.data!.latestVersion!;
        showMyCustomDialog(context,
            text:
                'Versi terbaru aplikasi C-Food sudah tersedia. Ayo segera update!',
            justYEs: true,
            yesText: "Update Sekarang", onTapYes: () async {
          // openUrl(Uri.parse('https://campusfood.id'));
          log('open url');
          final Uri url = Uri(scheme: 'https', host: 'www.campusfood.id');
          if (!await launchUrl(url)) {
            throw Exception(
                'Could not launch $url');
          }
        });
      }
    } catch (e) {
      log('Error during startup: $e');
      navigateToRep(context, const StartUpScreen());
    }
  }

  Future<void> openUrl(Uri url) async {
    log('open url');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

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
            child: Column(
              children: [
                const Text(
                  'Master Seafood',
                  style: AppTextStyles.labelInput,
                ),
                Text(
                  Constant.appVersion,
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
>>>>>>> 3f9f3e01d190d91a8882ff0e46bacfd79ab2f602
