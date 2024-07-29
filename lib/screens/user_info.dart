import 'dart:io';
// import 'package:http/http.dart' as http;
import 'package:cfood/custom/CToast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/reload_indicator.dart';
import 'package:cfood/model/get_user_response.dart';
// import 'package:cfood/model/reponse_handler.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  DataUser? dataUser;
  DataUserCampus? userCampus;
  StudentInformation? studentInfo;
  DataUserMajor? studentMajor;
  StudyProgram? studentStudyProgram;

  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getUserData(context);
  }

  Future<void> refreshPage() async {
    await Future.delayed(const Duration(seconds: 3));

    // log('reload...');
    getUserData(context);
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
      studentMajor = studentInfo!.major;
      studentStudyProgram = studentInfo!.studyProgram;
    });
  }

  // Future<void> uploadPhotoProfile(BuildContext context) async {
  //   FetchController(
  //     endpoint: 'users/${AppConfig.USER_ID}/upload-photo',
  //     fromJson: (json) => ResponseHendler.fromJson(json),
  //     headers: {
  //       "Content-Type": 'multipart/form-data',
  //     },
  //   ).postData({
  //     "file": _image!,
  //   });
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
        print('Photo uploaded successfully');
        showToast('Berhasil Mengubah Foto');
        _image = null;
      } else {
        // Handle error response
        print('Failed to upload photo');
        showToast('Gagal Mengubah Foto');
      }
    } catch (e) {
      print('Error: $e');
      showToast(e.toString());
      _image = null;
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
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
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

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: backButtonCustom(context: context),
        leadingWidth: 90,
        title: const Text(
          'Informasi Mahasiswa',
          style: AppTextStyles.title,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: _image != null
          ? Transform.translate(
              offset: const Offset(0,
                  -80), // Adjust the second parameter to move it up (negative values move up, positive values move down)
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
            )
          : null,
      body: dataUser == null
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Warna.biru,
                  size: 30,
                ),
              ),
            )
          : ReloadIndicatorType1(
              onRefresh: refreshPage,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      profileBoxHeader(),
                      Text(
                        'NIM: ${studentInfo?.nim}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Angkatan: ${studentInfo?.admissionYear}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Program Studi : ${studentStudyProgram?.programName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Jurusan: ${studentMajor?.majorName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Kampus: ${userCampus?.campusName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
