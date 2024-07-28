import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CStylishHeder.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/campuses_list_reponse.dart';
import 'package:cfood/model/check_email_response.dart';
import 'package:cfood/model/check_verify_email_response.dart';
import 'package:cfood/model/validate_email_student_reponse.dart';
import 'package:cfood/repository/register_repository.dart';
import 'package:cfood/screens/create_password.dart';
import 'package:cfood/screens/login.dart';
import 'package:cfood/screens/main.dart';
import 'package:cfood/screens/signup_student.dart';
import 'package:cfood/screens/verification.dart';
import 'package:cfood/style.dart';
import 'package:flutter/gestures.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController campusController = TextEditingController();
  bool imStudent = true;
  String _selectedOptionStudent = 'ya';
  bool _showSuggestions = false;
  String selectedCampus = '';
  List<DataCampusesItem> campusesList = [];
  int selectedCampusesId = 0;
  bool loadButton = false;

  List<DataCampusesItem> _filteredCampusList = [];

  @override
  void initState() {
    super.initState();
    // campusController.addListener(
    //   _filterCampuses);
    _checkAndFetchData();
  }

  Future<void> _checkAndFetchData() async {
    // Cek dan panggil fetchData secara rekursif sampai campusesList tidak kosong
    while (campusesList.isEmpty) {
      await fetchData();
      await Future.delayed(
          Duration(seconds: 1)); // Tunggu sejenak sebelum cek lagi
    }
  }

  Future<void> fetchData() async {
    log('load campus list');
    CampusesListResponse dataCampusesResponse =
        await RegisterRepository().getDataCampuses();

    campusesList = dataCampusesResponse.data!;
    log(campusesList.toString());
  }

  Future<bool?> checkEmail(
    String email,
    BuildContext context,
  ) async {
    log('Email: ${email.runtimeType}');
    CheckEmailResponse checkEmailResponse = await RegisterRepository()
        .checkPostEmail(email: email, context: context);
    DataCheckEmailItem? checkedEmail = checkEmailResponse.data;

    log(checkedEmail.toString());

    return checkedEmail!.available;
  }

  // Future<bool?> checkVerifyEmail(String email, BuildContext context) async {
  //   CheckVerifyEmailResponse checkVerifyEmailResponse =
  //       await RegisterRepository().checkGetVerifyEmail(
  //     email: email,
  //     context: context,
  //   );
  //   DataVerifyEmail? checkVerifiedEmail = checkVerifyEmailResponse.data;

  //   log(checkVerifiedEmail.toString());

  //   return checkVerifiedEmail!.verified;
  // }

  Future<VerifyEmailResult?> checkVerifyEmail(String email, BuildContext context) async {
  CheckVerifyEmailResponse checkVerifyEmailResponse =
      await RegisterRepository().checkGetVerifyEmail(
    email: email,
    context: context,
  );
  DataVerifyEmail? checkVerifiedEmail = checkVerifyEmailResponse.data;

  log(checkVerifiedEmail.toString());

  if (checkVerifiedEmail != null) {
    return VerifyEmailResult(
      verified: checkVerifiedEmail.verified ?? false,
      userId: checkVerifiedEmail.userId ?? 0, // Pastikan DataVerifyEmail memiliki field userId
    );
  } else {
    return null;
  }
}

//   Future<DataVerifyEmail?> checkVerifyEmail(String email, BuildContext context) async {
//   CheckVerifyEmailResponse checkVerifyEmailResponse =
//       await RegisterRepository().checkGetVerifyEmail(
//     email: email,
//     context: context,
//   );
//   DataVerifyEmail? checkVerifiedEmail = checkVerifyEmailResponse.data;

//   log(checkVerifiedEmail.toString());

//   if (checkVerifiedEmail == null) {
//     return null;
//   }

//   return DataVerifyEmail(
//     userId: checkVerifiedEmail.userId,
//     email: checkVerifiedEmail.email,
//     verified: checkVerifiedEmail.verified ?? false,
//   );
// }


  Future<bool?> validateEmailStudent({
    required String email,
    required int id,
    required BuildContext context,
  }) async {
    log('id type: ${id.runtimeType}');
    ValidateEmailStudentReponse validateEmailStudentReponse =
        await RegisterRepository().validateEmailStudent(
      email: email,
      campusId: id,
      context: context,
    );
    DataValidateEmailStudent? validatedEmail = validateEmailStudentReponse.data;

    log(validatedEmail.toString());

    return validatedEmail!.valid;
  }

  void _filterCampuses() {
    String query = campusController.text.toLowerCase();
    log('Query: $query');
    if (query.isNotEmpty) {
      List<DataCampusesItem> filteredList = campusesList.where((campus) {
        return campus.campusName!.toLowerCase().contains(query);
      }).toList();

      filteredList.sort((a, b) {
        int indexA = a.campusName!.toLowerCase().indexOf(query);
        int indexB = b.campusName!.toLowerCase().indexOf(query);
        return indexA.compareTo(indexB);
      });

      setState(() {
        _filteredCampusList = filteredList.cast<DataCampusesItem>();
        _showSuggestions = true;
      });
      log('Filtered List: $_filteredCampusList');
    } else {
      setState(() {
        _filteredCampusList = [];
        _showSuggestions = false;
      });
      log('Filtered List cleared');
    }
  }

  void dataCheck(BuildContext context) {
    // bool checked = true;
    String emptyField = '';
    setState(() {
      loadButton = true;
    });
    // Check if the name field is empty
    if (nameController.text.isEmpty) {
      // checked = false;
      emptyField = 'Kolom Nama tidak boleh kosong';
      showToast(emptyField);
      log(emptyField);
      setState(() {
        loadButton = false;
      });
      return;
    }

    // Check if the campus field is empty
    if (campusController.text.isEmpty) {
      // checked = false;
      emptyField = 'Kolom Kampus tidak boleh kosong';
      showToast(emptyField);
      log(emptyField);
      setState(() {
        loadButton = false;
      });
      return;
    }

    if (selectedCampusesId == 0) {
      emptyField = 'Pilih Kampus';
      showToast(emptyField);
      log(emptyField);
      setState(() {
        loadButton = false;
      });
      return;
    }

    // Check if the email field is empty
    if (emailController.text.isEmpty) {
      // checked = false;
      emptyField = 'Kolom Email tidak boleh kosong';
      showToast(emptyField);
      log(emptyField);
      setState(() {
        loadButton = false;
      });
      return;
    }

    // Check if the user is a student and validate the student email format
    try {
      if (_selectedOptionStudent == 'ya') {
        log('id type: ${selectedCampusesId.runtimeType}');
        validateEmailStudent(
                email: emailController.text,
                id: selectedCampusesId,
                context: context)
            .then((emailStudentValidated) {
          if (emailStudentValidated != null && !emailStudentValidated) {
            // checked = false;
            emptyField = 'Email tidak valid untuk kampus yang dipilih';
            showToast(emptyField);
            log(emptyField);
            setState(() {
              loadButton = false;
            });
          } else {
            // Check if the email is available
            checkEmail(emailController.text, context).then((emailAvailable) {
              if (emailAvailable != null && emailAvailable) {
                log('to signup student');
                setState(() {
                  loadButton = false;
                });
                navigateTo(
                    context,
                    SignUpStudentScreen(
                      name: nameController.text,
                      email: emailController.text,
                      campusId: selectedCampusesId,
                      selectedUniversity: selectedCampus,
                    ));

                return;
              } else {
                // Check if the email is verified
                checkVerifyEmail(emailController.text, context)
                    .then((emailVerified) {
                      if(emailVerified != null) {
                        if (emailVerified.verified) {
                          showToast('Email Sudah Terverikasi');
                          setState(() {
                            loadButton = false;
                          });
                        } else {
                          emptyField = 'Email Belum Terverifikasi';
                          showToast(emptyField);
                          log(emptyField);
                          setState(() {
                            loadButton = false;
                          });
                          navigateTo(context, VerificationScreen(
                              forgotPass: false,
                              userId: emailVerified.userId,
                              email: emailController.text
                            ));
                        }
                      }
                });
              }
            });
          }
        });
      } else {
        // Check if the email is available
        // checkEmail(emailController.text, context).then((emailAvailable) {
        //   if (emailAvailable != null && emailAvailable) {
        //     setState(() {
        //       loadButton = false;
        //     });
        //     navigateTo(
        //         context,
        //         CreatePasswordScreen(
        //           email: emailController.text,
        //           name: nameController.text,
        //           campusId: selectedCampusesId,
        //           isStudent: false,
        //         ));
        //     return;
        //   } else {
        //     // Check if the email is verified
        //     checkVerifyEmail(emailController.text, context)
        //         .then((emailVerified) {
        //       if (emailVerified != null && emailVerified) {
        //         // checked = false;
        //         setState(() {
        //           loadButton = false;
        //         });
        //         emptyField = 'Email sudah terdaftar dan terverifikasi';
        //         showToast(emptyField);
        //         log(emptyField);
        //         navigateToRep(context, const LoginScreen());
        //       } else {
        //         setState(() {
        //           loadButton = false;
        //         });
        //         navigateTo(
        //             context,
        //             VerificationScreen(
        //               forgotPass: false,
        //               email: emailController.text,
        //             ));
        //       }
        //     });
        //   }
        // });
      }
    } on Exception catch (e) {
      setState(() {
        loadButton = false;
      });
      log(e.toString());
      showToast(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  void dispose() {
    campusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            const CStylishHeader(
              title: 'Daftar',
              description: 'Isi data berikut untuk membuat akun',
            ),
            const SizedBox(
              height: 30,
            ),
            // NAME
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CTextField(
                controller: nameController,
                hintText: 'Umar Faruq Robbany',
                labelText: 'Nama Lengkap',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // EMAIL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CTextField(
                controller: emailController,
                hintText: 'umar.faruq.tif423@polban.ac.id',
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // CAMPUS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CTextField(
                controller: campusController,
                hintText: 'Politeknik Negeri Bandung',
                labelText: 'Kampus',
                onChanged: (p0) {
                  _filterCampuses();
                },
                suffixIcon: IconButton(
                  icon: Icon(
                      _showSuggestions && campusController.text.isNotEmpty
                          ? Icons.arrow_drop_down_rounded
                          : Icons.arrow_left_rounded),
                  onPressed: () {
                    print(campusController.text);
                    print("not filter : $campusesList");
                    print("filtered : $_filteredCampusList");
                    setState(() {
                      _showSuggestions = !_showSuggestions;
                    });
                  },
                ),
              ),
            ),
            if (_showSuggestions && campusController.text.isNotEmpty)
              campusSelection(),

            // const SizedBox(
            //   height: 15,
            // ),
            // const Align(
            //   alignment: Alignment.centerLeft,
            //   child: Padding(
            //     padding: EdgeInsets.only(left: 25),
            //     child: Text(
            //       'Apakah Kamu Mahasiswa?',
            //       style: AppTextStyles.textRegular,
            //     ),
            //   ),
            // ),
            // studentSelection(),
            const SizedBox(
              height: 40,
            ),
            // SIGNIN BUTTON
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              height: 55,
              width: MediaQuery.of(context).size.width,
              child: CBlueButton(
                  isLoading: loadButton,
                  onPressed: () {
                    dataCheck(context);
                    // Sign up button logic
                    // if (dataCheck(context)) {
                    //   if (_selectedOption == 'ya') {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => SignUpStudentScreen(
                    //               selectedUniversity: selectedCampus),
                    //         ));
                    //   } else {
                    //     print('go to password screen');
                    //   }
                    // }
                  },
                  text: 'Lanjut'),
            ),
            const SizedBox(
              height: 40,
            ),
            // TEXT REGISTER
            RichText(
              text: TextSpan(
                text: 'Sudah punya akun? ',
                style: TextStyle(color: Colors.grey.shade900, fontSize: 15),
                children: [
                  TextSpan(
                    text: 'Masuk sekarang',
                    style: TextStyle(color: Warna.biru, fontSize: 15),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        navigateToRep(context, const LoginScreen());
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const LoginScreen()),
                        // );
                      },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  Widget campusSelection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _filteredCampusList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_filteredCampusList[index].campusName.toString()),
            onTap: () {
              setState(() {
                campusController.text = _filteredCampusList[index].campusName!;
                selectedCampus = campusController.text;
                selectedCampusesId = _filteredCampusList[index].id!;
                _showSuggestions = false;
                log('''
                    selceted campus : $selectedCampus,
                    campud id : $selectedCampusesId,
                    ''');
              });
            },
          );
        },
      ),
    );
  }

  // Widget studentSelection() {
  //   return Column(
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 20),
  //         height: 30,
  //         child: Row(
  //           children: [
  //             Radio<String>(
  //               value: 'ya',
  //               groupValue: _selectedOptionStudent,
  //               onChanged: (String? value) {
  //                 setState(() {
  //                   _selectedOptionStudent = value!;
  //                 });
  //               },
  //             ),
  //             const Text('Ya'),
  //           ],
  //         ),
  //       ),
  //       Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 20),
  //         height: 30,
  //         child: Row(
  //           children: [
  //             Radio<String>(
  //               value: 'tidak',
  //               groupValue: _selectedOptionStudent,
  //               onChanged: (String? value) {
  //                 setState(() {
  //                   _selectedOptionStudent = value!;
  //                 });
  //               },
  //             ),
  //             const Text('Tidak'),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
