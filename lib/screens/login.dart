import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CStylishHeder.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/repository/login_repository.dart';
import 'package:cfood/screens/forgot_password.dart';
import 'package:cfood/screens/main.dart';
import 'package:cfood/screens/signup.dart';
import 'package:cfood/screens/verification.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/auth.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool passDisble = true;
  bool loadState = false;

  @override
  void initState() {
    super.initState();
  }

  bool dataCheck(BuildContext context) {
    bool checked = true;
    String emptyField = '';
    setState(() {
      loadState = true;
    });

    if (emailController.text.isEmpty) {
      setState(() {
        checked = false;
        emptyField = 'Kolom Email tidak boleh kosong';
        loadState = false;
      });
      showToast(emptyField);
      print(emptyField);
    } else if (passController.text.isEmpty) {
      // create function to check password
      setState(() {
        checked = false;
        emptyField = 'Kolom  tidak boleh kosong';
        loadState = false;
      });
      showToast(emptyField);
      print(emptyField);
    } else {
      pressLogin(context, loadState, checked);
    }
    // loadState = false;
    return checked;
  }

  Future<void> pressLogin(
      BuildContext context, bool buttonLoadState, bool checked) async {
    try {
      var loginResponse = await LoginRepository().loginUser(
        context,
        email: emailController.text,
        password: passController.text,
      );

      // showToast(loginResponse.message.toString());

      if (loginResponse.status.toString() == 'error') {
        // log(loginResponse.message.toString());
        if (loginResponse.message.toString() == 'Password salah') {
          showToast(loginResponse.message.toString());
          setState(() {
            buttonLoadState = false;
            checked = false;
            loadState = false;
          });
        } else if (loginResponse.data!.verified == false) {
          log('go to verification');
          setState(() {
            loadState = false;
          });
          navigateTo(
              context,
              VerificationScreen(
                forgotPass: false,
                userId: loginResponse.data!.userId,
                email: emailController.text,
              ));
        } else {
          log(loginResponse.statusCode.toString());
          setState(() {
            checked = true;
            buttonLoadState = false;
            loadState = false;
          });
        }
      } else {
        if (loginResponse.data != null) {
          DataLogin data = loginResponse.data!;
          setDataToLocal(
            userId: data.userId.toString(),
            email: data.email,
            password: passController.text,
          );

          setState(() {
            checked = true;
            buttonLoadState = false;
            loadState = false;
          });
          log('go to homepage');
          // context.pushReplacementNamed('main');
          navigateToRep(context, const MainScreen());
        }
      }
    } catch (e) {
      setState(() {
        buttonLoadState = false;
        checked = false;
        loadState = false;
      });
      // if() {
      //   showToast("Password salah");
      // }
      showToast(e.toString().replaceAll('Exception: ', ''));
      // showToast(e.toString().)
      log('Error: $e');

      setState(() {
        loadState = false;
      });
    }
  }

  // Future<bool?> checkEmail(
  //   String email,
  //   BuildContext context,
  // ) async {
  //   log('Email: ${email.runtimeType}');
  //   CheckEmailResponse checkEmailResponse = await RegisterRepository()
  //       .checkPostEmail(email: email, context: context);
  //   DataCheckEmailItem? checkedEmail = checkEmailResponse.data;

  //   log(checkedEmail.toString());

  //   return checkedEmail!.available;
  // }

  void setDataToLocal({
    String? userId,
    String? email,
    String? password,
  }) {
    setState(() {
      AppConfig.EMAIL = email!;
      AppConfig.USER_ID = int.parse(userId!);
    });
    AuthHelper().setEmailPassword(
      email: email,
      password: password,
    );

    log(AuthHelper().chackUserData().toString());
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        // ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // HEADER
              const CStylishHeader(
                title: 'Selamat Datang',
                description: 'Masuk ke akunmu untuk melanjutkan',
              ),
              const SizedBox(
                height: 30,
              ),
              // EMAIL
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: CTextField(
                  controller: emailController,
                  hintText: 'Masukkan email kamu',
                  labelText: 'Email',
                ),
              ),
              // PASSWORD
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: CTextField(
                  controller: passController,
                  labelText: 'Password',
                  textStyle: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                  hintText: '●●●●●●●●',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                  obscureText: passDisble,
                  maxLines: 1,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        if (passDisble) {
                          setState(() {
                            passDisble = false;
                          });
                        } else {
                          setState(() {
                            passDisble = true;
                          });
                        }
                      },
                      icon: FaIcon(
                        passDisble
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // FORGOT PASS
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 25),
              //     child: TextButton(
              //         onPressed: () {
              //           // setState(() {
              //           //   loadState = false;
              //           // });
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) =>
              //                     const ForgotPasswordScreen(),
              //               ));
              //         },
              //         style: TextButton.styleFrom(
              //           padding: EdgeInsets.zero,
              //         ),
              //         child: Text(
              //           'Lupa Password',
              //           style: TextStyle(
              //               color: Warna.biru1,
              //               fontSize: 15,
              //               fontWeight: FontWeight.bold),
              //         )),
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.only(left: 25), // Left padding of 25
                child: Align(
                  alignment: Alignment.centerLeft, // Align to the left
                  child: RichText(
                    text: TextSpan(
                      text: 'Lupa Password ',
                      style: TextStyle(
                          color: Warna.biru1,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ));
                        },
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 32,
              ),
              // SIGNIN BUTTON
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: CBlueButton(
                    isLoading: loadState,
                    onPressed: () {
                      // navigateToRep(context, const MainScreen());
                      dataCheck(context);
                      // if (dataCheck(context)) {
                      //   // print('go to home page');
                      //   navigateToRep(context, const MainScreen());
                      //   // context.pushReplacementNamed('/');
                      //   setState(() {
                      //     loadState = false;
                      //   });
                      //   // context.pushReplacement('/');
                      //   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(),));
                      // }
                      // FetchController(
                      //   baseUrl: 'http://cfood.id/',
                      //   endpoint: 'campuses/',
                      //   dataClass: CampusesListResponse,
                      //   fromJson: (json) => CampusesListResponse.fromJson(json),
                      // ).getData();
                    },
                    text: 'Masuk'),
              ),

              const SizedBox(
                height: 40,
              ),
              // TEXT REGISTER
              RichText(
                text: TextSpan(
                  text: 'Belum punya akun? ',
                  style: TextStyle(color: Colors.grey.shade900, fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'Daftar sekarang',
                      style: TextStyle(
                          color: Warna.biru1,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // context.pushReplacementNamed('register');
                          navigateToRep(context, const SignupScreen());
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
