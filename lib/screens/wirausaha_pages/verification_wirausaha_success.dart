import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/screens/kantin_pages/main.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VerificatioWirausahanSuccess extends StatelessWidget {
  const VerificatioWirausahanSuccess({super.key,});

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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                 'Selamat! Akun Wirausaha C-Food Kamu Berhasil Dibuat',
                  style: AppTextStyles.title,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Terima Kasih menjadi wirausahawan di C-Food. Semoga wirausaha kamu sukses selalu!',
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
                  //  navigateTo(context, const MainScreenCanteen());
                  navigateBack(context);
                  },
                  text: 'Masuk ke laman Wirausaha',
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
