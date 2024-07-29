import 'dart:async';
import 'dart:developer';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/repository/login_repository.dart';
import 'package:cfood/screens/main.dart';
import 'package:cfood/screens/startup.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/auth.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';

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
      // AuthHelper().setUserData(); // Uncomment if needed
      Map<String, dynamic> dataUser = await AuthHelper().getkUserData();

      if (dataUser['userid'] != '') {
        AppConfig.USER_ID = int.parse(dataUser['userid']);
        AppConfig.NAME = dataUser['username'];
        AppConfig.EMAIL = dataUser['email'];
        AppConfig.USER_TYPE = dataUser['type'];
        AppConfig.IS_DRIVER = dataUser['isDriver'] == 'no' ? false : true;
      }

      if (dataUser['email'] != '' &&
          dataUser['password'] != '' &&
          dataUser['id'] != '') {
        LoginResponse loginResponse = await FetchController(
          endpoint: 'users/login',
          fromJson: (json) => LoginResponse.fromJson(json),
        ).postData({
          "email": dataUser['email'],
          "password": dataUser['password'],
        });

        setState(() {
          AppConfig.USER_ID = loginResponse.data!.userId!;
        });

        if (AppConfig.USER_TYPE == 'reguler') {
          // ignore: use_build_context_synchronously
          log('go to homepages');
          navigateToRep(context, const MainScreen());
          // context.pushReplacementNamed('main');
        } else if (AppConfig.USER_TYPE == 'kantin') {
          log('go to kantin pages');
        } else if (AppConfig.USER_TYPE == 'wirausaha') {
          log('go to wirausaha pages');
        } else if (AppConfig.USER_TYPE == 'kurir') {
          log('go to kurir pages');
        }
      } else {
        log('go to startup');
        // context.pushReplacementNamed('startup');
        Timer(const Duration(seconds: 3), () {
          // context.pushReplacementNamed('startup');
          navigateToRep(context, const StartUpScreen());
        });
      }
    } catch (e) {
      // Handle error and log it
      log('Error during startup: $e');
      Timer(const Duration(seconds: 3), () {
        // context.pushReplacementNamed('startup');
        navigateToRep(context, const StartUpScreen());
      });

      // Optional: Show an error message to the user or navigate to an error page
      // For example, you might navigate to an error page if needed:
      // navigateToRep(context, const ErrorScreen());
    }
  }

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
