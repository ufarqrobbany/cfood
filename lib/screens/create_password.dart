import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/add_student_response.dart';
import 'package:cfood/model/add_user_response.dart';
import 'package:cfood/model/check_verify_email_response.dart';
import 'package:cfood/model/reponse_handler.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/repository/fetch_interceptor_controller.dart';
import 'package:cfood/repository/register_repository.dart';
import 'package:cfood/screens/verification.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class CreatePasswordScreen extends StatefulWidget {
  bool forgotPass;
  final int? userId;
  final String? name;
  final String? email;
  final int? campusId;
  final int? nim;
  final int? majorId;
  final int? studyProgramId;
  final int? addmissionYear;
  final bool isStudent;
  CreatePasswordScreen({
    super.key,
    this.forgotPass = false,
    this.userId,
    this.name,
    this.email,
    this.campusId,
    this.nim,
    this.majorId,
    this.studyProgramId,
    this.addmissionYear,
    this.isStudent = false,
  });

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController pass1Controller = TextEditingController();
  final TextEditingController pass2Controller = TextEditingController();
  bool passDisable = true;
  bool loadButton = false;
  int? userId;

  @override
  void initState() {
    super.initState();

    log({
      "userId": widget.userId,
      "name": widget.name,
      "email": widget.email,
      "campusId": widget.campusId,
      "nim": widget.nim,
      "majorId": widget.majorId,
      "studyProgram": widget.studyProgramId,
      "addmissionYear": widget.addmissionYear,
      "isStudent": widget.isStudent,
    }.toString());

    if (widget.forgotPass) {
      checkUserInfoFromEmail();
    }
  }

  void dataCheck(BuildContext context) {
    bool checked = true;
    String emptyField = '';
    setState(() {
      loadButton = true;
      log('load button is $loadButton');
    });
    if (pass1Controller.text.isEmpty) {
      setState(() {
        checked = false;
        loadButton = false;
        emptyField = 'Kolom Password tidak boleh kosong';
      });
      showToast(emptyField);
    } else if (pass1Controller.text.length <= 8) {
      setState(() {
        checked = false;
        loadButton = false;
        emptyField = 'Password minimal 8 karakter';
      });
      showToast(emptyField);
    } else if (pass2Controller.text.isEmpty) {
      setState(() {
        checked = false;
        loadButton = false;
        emptyField = 'Isi Kolom Konfirmasi Password!';
      });
      showToast(emptyField);
    } else if (pass1Controller.text != pass2Controller.text) {
      setState(() {
        checked = false;
        loadButton = false;
        emptyField = 'Password anda tidak sesuai';
      });
      showToast(emptyField);
    } else {
      if (widget.forgotPass) {
        log('request reset password');
        resetPassword(context);
      } else {
        addUserStudent(context);
      }
    }

    // return checked;
  }

  Future<void> checkUserInfoFromEmail() async {
    CheckVerifyEmailResponse emailResponse = await RegisterRepository()
        .checkGetVerifyEmail(context: context, email: widget.email!);

    userId = emailResponse.data!.userId;
    log("user id: $userId");
  }

  Future<void> resetPassword(BuildContext context) async {
    setState(() {
      loadButton = true;
    });
    ResponseHendler response = await FetchController(
      endpoint: 'users/reset-password',
      fromJson: (json) => ResponseHendler.fromJson(json),
    ).putData({
      "userId": widget.userId,
      "newPassword": pass2Controller.text,
    });
    if (response.status != 'error') {
      log('password change success');
      setState(() {
        loadButton = false;
      });
      navigateTo(
          context,
          VerificationSuccess(
            passChange: true,
          ));
    } else {
      log('password change failed');
      setState(() {
        loadButton = false;
      });
    }
  }

  Future<void> addUserStudent(BuildContext context) async {
    // Mengaktifkan indikator loading (jika diperlukan)

    try {
      log('add user');
      setState(() {
        loadButton = true;
        log('load button is $loadButton');
      });

      AddUserResponse userResponse = await RegisterRepository().addPostUser(
        context,
        email: widget.email!,
        name: widget.name!,
        campusId: widget.campusId!,
        password: pass2Controller.text,
      );

      DataAddUser? dataUser = userResponse.data;
      log(dataUser!.id.toString());

      if (dataUser != null) {
        if (widget.isStudent) {
          log('add student');
          await RegisterRepository().addPostStudent(
            // ignore: use_build_context_synchronously
            context,
            userId: dataUser.id!,
            campusId: widget.campusId!,
            // campusId: 2,
            majorId: widget.majorId!,
            nim: widget.nim!,
            studyProgramId: widget.studyProgramId!,
            admissionYear: widget.addmissionYear!,
          );
        }

        log('request otp');
        await RegisterRepository().sendPostOtp(
          context,
          userId: dataUser.id!,
          name: dataUser.name,
          to: dataUser.email,
          type: widget.forgotPass ? "RESET_PASSWORD" : "REGISTER",
        );

        setState(() {
          loadButton = false;
          log('load button is $loadButton');
        });
        log('go to verification email');
        //
        navigateTo(
            context,
            VerificationScreen(
              userId: dataUser.id!,
            ));
      }

      // log('request otp');
      // await RegisterRepository().sendPostOtp(
      //   context,
      //   userId: dataUser.id!,
      //   name: dataUser.name,
      //   to: dataUser.email,
      //   type: widget.forgotPass ? "RESET_PASSWORD" : "REGISTER",
      // );

      // log('go to verification email');
      // setState(() {
      //   loadButton = false;
      // });
      // navigateTo(
      //     context,
      //     VerificationScreen(
      //       userId: dataUser.id!,
      //     ));
    } on Exception catch (e) {
      // Menonaktifkan indikator loading (jika diperlukan)
      setState(() {
        loadButton = false;
        log('load button is $loadButton');
      });
      showToast(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Buat Password${widget.forgotPass ? " Baru" : ''}',
          style: AppTextStyles.title,
        ),
        backgroundColor: Colors.white,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CTextField(
                controller: pass1Controller,
                labelText: 'Password',
                subLabelText: '   Minimal 8 karakter',
                textStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
                hintText: '●●●●●●●●',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                ),
                obscureText: passDisable,
                maxLines: 1,
                onChanged: (p0) {},
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      if (passDisable) {
                        setState(() {
                          passDisable = false;
                        });
                      } else {
                        setState(() {
                          passDisable = true;
                        });
                      }
                    },
                    icon: FaIcon(
                      passDisable
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CTextField(
                controller: pass2Controller,
                labelText: 'Konfirmasi Password',
                textStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
                hintText: '●●●●●●●●',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                ),
                obscureText: passDisable,
                maxLines: 1,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      if (passDisable) {
                        setState(() {
                          passDisable = false;
                        });
                      } else {
                        setState(() {
                          passDisable = true;
                        });
                      }
                    },
                    icon: FaIcon(
                      passDisable
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CBlueButton(
                isLoading: loadButton,
                onPressed: () {
                  dataCheck(context);
                  // if (!widget.forgotPass) {
                  //   if (dataCheck(context)) {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => VerificationScreen(),
                  //         ));
                  //   }
                  // } else {
                  //   navigateTo(
                  //       context,
                  //       VerificationSuccess(
                  //         passChange: true,
                  //       ));
                  // }
                },
                text: 'Lanjut',
              ),
            )
          ],
        ),
      ),
    );
  }
}
