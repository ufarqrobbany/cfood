import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/check_verify_email_response.dart';
import 'package:cfood/repository/register_repository.dart';
import 'package:cfood/screens/verification.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool loadState = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void dataChecked(BuildContext context) {
    // bool checked = true;
    String emptyField = '';
    setState(() {
      loadState = true;
    });
    if (emailController.text.isEmpty) {
      setState(() {
        // checked = false;
        loadState = false;
        emptyField = 'Email tidak boleh kosong';
      });
      showToast(emptyField);
    } else {
      requestOTP(context, emailController.text);
    }
    // return checked;
  }

  Future<void> requestOTP(
    BuildContext context,
    String email,
  ) async {
    try {
      log('Email: ${email.runtimeType}');
      // CheckEmailResponse checkEmailResponse = await RegisterRepository()
      //     .checkPostEmail(email: email, context: context);

      CheckVerifyEmailResponse verifyEmailResponse =
          await RegisterRepository().checkGetVerifyEmail(
        // ignore: use_build_context_synchronously
        context: context,
        email: email,
      );
      // DataCheckEmailItem? checkedEmail = checkEmailResponse.data;
      DataVerifyEmail? verifyEmail = verifyEmailResponse.data;
      if (verifyEmail != null) {
        log('request otp');
        await RegisterRepository().sendPostOtp(
          context,
          userId: verifyEmail.userId!,
          type: "RESET_PASSWORD",
        );
        setState(() {
          loadState = false;
        });
        log('go to verification');
        navigateTo(
          context,
          VerificationScreen(
            forgotPass: true,
            userId: verifyEmail.userId,
          ),
        );
      }
    } on Exception catch (e) {
      setState(() {
        loadState = false;
      });
      log('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lupa Password',
          style: AppTextStyles.title,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leadingWidth: 90,
        leading: IconButton(
          onPressed: () => navigateBack(context),
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
          children: [
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Masukkan email kamu yang terkait dengan akunmu, dan kami akan mengirimkan kode OTP melalui email untuk mengatur ulang password kamu.',
                style: AppTextStyles.textRegular,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CTextField(
                controller: emailController,
                hintText: 'Masukkan email kamu',
                labelText: 'Email',
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
                  dataChecked(context);
                  // if (dataChecked(context)) {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => VerificationScreen(
                  //           forgotPass: true,
                  //         ),
                  //       ));
                  // }
                },
                text: 'Kirim OTP',
              ),
            )
          ],
        ),
      ),
    );
  }
}
