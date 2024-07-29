import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/otp_check_response.dart';
import 'package:cfood/model/reponse_handler.dart';
import 'package:cfood/repository/register_repository.dart';
import 'package:cfood/screens/create_password.dart';
import 'package:cfood/screens/login.dart';
import 'package:cfood/screens/signup.dart';
import 'package:cfood/style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class VerificationScreen extends StatefulWidget {
  bool forgotPass;
  int? userId;
  String? email;
  VerificationScreen(
      {super.key, this.userId, this.forgotPass = false, this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final OtpFieldController otpController = OtpFieldController();
  bool loadState = false;
  int otpCode = 0;
  int userId = 0;

  @override
  void initState() {
    super.initState();
    log(
      {
        'userId': widget.userId,
      }.toString(),
    );
    // if (widget.email != null) {
    //   notVerifyYet();
    // }

    if (widget.userId != null) {
    // setState(() {
    //   userId = widget.userId!;
    // });
    requestOTP(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkData(BuildContext context) async {
    setState(() {
      loadState = true;
    });
    if (otpCode == 0 || otpCode.bitLength < 6) {
      showToast('Masukkan Kode OTP yang sudah terkirim');
      setState(() {
        loadState = false;
      });
    } else {
      try {
        OtpCheckResponse otpResponse = await RegisterRepository().checkPostOtp(
          context,
          userId: widget.userId!,
          otpCode: otpCode,
          otpType: widget.forgotPass ? "RESET_PASSWORD" : "REGISTER",
        );

        // if (otpResponse.status == 'success') {
        //   setState(() {
        //     loadState = false;
        //   });
        //   navigateToRep(context, VerificationSuccess(passChange: false,));
        // }

        if (widget.forgotPass) {
          if (otpResponse.data!.valid == true) {
            log('go to create pass');
            setState(() {
              loadState = false;
            });
            navigateTo(
                context,
                CreatePasswordScreen(
                  forgotPass: true,
                  userId: widget.userId,
                ));
          } else {
            log('otp problem');
            setState(() {
              loadState = false;
            });
          }
        } else {
          if (otpResponse.data!.valid == true || otpResponse.status == 'success') {
            ResponseHendler response = await RegisterRepository().verifyUser(
              context,
              userId: widget.userId!,
            );

            if (response.status == 'success') {
              log('go to verification success');
              setState(() {
                loadState = false;
              });
              navigateTo(
                  context,
                  VerificationSuccess(
                    passChange: false,
                  ));
            } else {
              log('verify problem');
              setState(() {
                loadState = false;
              });
            }
          }
        }
      } on Exception catch (e) {
        log(e.toString());
        setState(() {
          loadState = false;
        });
      }
    }
  }

  Future<void> requestOTP(BuildContext context) async {
    if (otpCode != 0) {
      otpController.clear();
    }
    log('request otp');
    await RegisterRepository().sendPostOtp(
      context,
      // userId: userId,
      // userId: userId,
      userId: widget.userId!,
      type: widget.forgotPass ? "RESET_PASSWORD" : "REGISTER",
    );
  }

  // Future<void> notVerifyYet() async {
  // log('load id');
  // CheckVerifyEmailResponse verifyEmailResponse =
  //     await RegisterRepository().checkGetVerifyEmail(
  //   // ignore: use_build_context_synchronously
  //   context: context,
  //   email: widget.email!,
  // );
  // DataCheckEmailItem? checkedEmail = checkEmailResponse.data;
  // DataVerifyEmail? verifyEmail = verifyEmailResponse.data;
  // setState(() {
  //   userId = verifyEmail!.userId!;
  // });
  //   log("id : $userId");
  //   requestOTP(context);
  // }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          !widget.forgotPass ? 'Verifikasi Email' : 'Kode OTP',
          style: AppTextStyles.title,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leadingWidth: 90,
        leading: IconButton(
          onPressed: widget.forgotPass ? () {
            navigateBack(context);
          } : () {
            printCurrentRoutes(context);
            navigateToRep(context, const SignupScreen());
            // Navigator.pop(context, 'goToRegister');
            // Navigator.popUntil(context, ModalRoute.withName('/register'),);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Warna.biru,
          ),
          padding: const EdgeInsets.all(10),
          style: IconButton.styleFrom(
              backgroundColor: Warna.abu, shape: const CircleBorder()),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: const Text(
                'Kode OTP telah dikirimkan ke Email kamu, masukkan kode untuk verifikasi.',
                textAlign: TextAlign.center,
                style: AppTextStyles.textRegular,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: OTPTextField(
                  controller: otpController,
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldWidth: 45,
                  fieldStyle: FieldStyle.box,
                  outlineBorderRadius: 15,
                  style: const TextStyle(fontSize: 17),
                  obscureText: false,
                  otpFieldStyle: OtpFieldStyle(
                      focusBorderColor: Warna.kuning,
                      borderColor: Warna.biru,
                      enabledBorderColor: Warna.biru,
                      disabledBorderColor: Warna.abu3),
                  onChanged: (pin) {
                    log("Changed: $pin");
                    setState(() {
                      otpCode = int.parse(pin);
                    });
                  },
                  onCompleted: (pin) {
                    log("Completed: $pin");
                    setState(() {
                      otpCode = int.parse(pin);
                    });
                  }),
            ),
            const SizedBox(
              height: 50,
            ),
            // SEND AGAIN
            RichText(
              text: TextSpan(
                text: 'Belum menerima pesan? ',
                style: TextStyle(color: Colors.grey.shade900, fontSize: 15),
                children: [
                  TextSpan(
                    text: 'Kirim ulang',
                    style: TextStyle(
                        color: Warna.biru,
                        // fontWeight: FontWeight.bold,
                        fontSize: 15),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        log('kirim ulang');
                        requestOTP(context);
                        // setState(() {
                        //   loadState = false;
                        // });
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CBlueButton(
                isLoading: loadState,
                onPressed: () {
                  checkData(context);
                  // navigateTo(
                  //     context,
                  //     CreatePasswordScreen(
                  //       forgotPass: true,
                  //       userId: widget.userId,
                  //     ));
                },
                text: 'Verifikasi',
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class VerificationSuccess extends StatelessWidget {
  bool passChange;
  VerificationSuccess({super.key, this.passChange = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Image.asset('assets/Logo Success.png'),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  !passChange
                      ? 'Selamat! Akun C-Food kamu Berhasil Dibuat'
                      : 'Password Akun Kamu Berhasil Diubah',
                  style: AppTextStyles.title,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  !passChange
                      ? 'Terimakasih telah bergabung dengan C-Food. Sekarang kamu bisa memesan makanan favorit di kampusmu dengan mudah dan cepat'
                      : 'Selalu catat dan simpan setiap password akun kamu di tempat yang aman.',
                  style: AppTextStyles.textRegular,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: CBlueButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ));
                  },
                  text: 'Kembali ke Halaman Login',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // ICON
              SizedBox(
                // height: MediaQuery.of(context).size.height * 0.15,
                height: 80,
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/logo.png',
                    height: 69,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
