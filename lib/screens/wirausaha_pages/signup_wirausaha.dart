import 'dart:developer';
import 'dart:io';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/add_merchants_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/wirausaha_pages/verification_wirausaha_success.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:toast/toast.dart';
import 'package:uicons/uicons.dart';

class SignupWirausahaScreen extends StatefulWidget {
  const SignupWirausahaScreen({super.key});

  @override
  State<SignupWirausahaScreen> createState() => _SignupWirausahaScreenState();
}

class _SignupWirausahaScreenState extends State<SignupWirausahaScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool buttonLoad = false;

  File? _image;
  File? _image_temp;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  void dataCheck(BuildContext context) async {
    setState(() {
      buttonLoad = true;
    });

    if (_image == null) {
      setState(() {
        buttonLoad = false;
      });
      showToast('Pilih gambar untuk toko kamu');
      return;
    }

    if (nameController.text.isEmpty) {
      setState(() {
        buttonLoad = false;
      });
      showToast('Kolom Nama tidak boleh kosong');
      return;
    }

    if (descriptionController.text.isEmpty) {
      setState(() {
        buttonLoad = false;
      });
      showToast('Kolom Deskripsi tidak boleh kosong');
      return;
    }

    try {
      AddMerchantResponse response = await FetchController(
        endpoint: 'merchants/',
        headers: {
          "Content-type": 'multipart/form-data',
          "Accept": "*/*",
        },
        fromJson: (json) => AddMerchantResponse.fromJson(json),
      ).postMultipartData(
        dataKeyName: 'merchant',
        data: {
          "merchantName": nameController.text,
          "merchantDesc": descriptionController.text,
          "merchantType": "WIRAUSAHA",
          "userId": AppConfig.USER_ID,
        },
        fileKeyName: 'photo',
        file: _image!,
      );

      setState(() {
        buttonLoad = false;
      });
      log('go to verification success');
      // navigateTo(context, const VerificatioWirausahanSuccess());
    } on Exception catch (e) {
      setState(() {
        buttonLoad = false;
      });
      showToast(e.toString().replaceAll('Exception: ', ''),);
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: backButtonCustom(context: context),
        title: Text(
          'Daftar Wirausaha',
          style: AppTextStyles.appBarTitle,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Warna.pageBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 25,
              ),
              // Upload photo
              InkWell(
                onTap: () {
                  showOptionsPicker();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Warna.abu,
                      borderRadius: BorderRadius.circular(8),
                      border: _image == null ? DashedBorder.fromBorderSide(
                        dashLength: 12,
                        side: BorderSide(
                          color: Warna.biru,
                          width: 3,
                        ),
                      ) : null,
                    ),
                    child: _image != null ? Image.file(_image!, fit: BoxFit.cover,) : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            UIcons.solidRounded.camera,
                            color: Warna.biru,
                            size: 30,
                          ),
                          Text(
                            'Tambah foto',
                            style: TextStyle(
                              color: Warna.biru,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CTextField(
                controller: nameController,
                hintText: '',
                labelText: 'Nama Toko/Wirausaha',
              ),
              const SizedBox(
                height: 20,
              ),
              CTextField(
                controller: descriptionController,
                hintText: '',
                labelText: 'Deskripsi',
                minLines: 5,
              ),
              const SizedBox(
                height: 35,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: CBlueButton(
                  isLoading: buttonLoad,
                  onPressed: () {
                    dataCheck(context);
                    // navigateTo(context, const VerificatioWirausahanSuccess());
                  },
                  text: 'Daftar',
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            child: const Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
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
}
