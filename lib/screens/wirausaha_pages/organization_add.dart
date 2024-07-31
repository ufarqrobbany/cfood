import 'dart:developer';
import 'dart:io';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/add_organization_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:toast/toast.dart';
import 'package:uicons/uicons.dart';

class OrganizationAddScreen extends StatefulWidget {
  final int campusId;
  const OrganizationAddScreen({super.key, this.campusId = 0});

  @override
  State<OrganizationAddScreen> createState() => _OrganizationAddScreenState();
}

class _OrganizationAddScreenState extends State<OrganizationAddScreen> {
  TextEditingController nameController = TextEditingController();
  bool buttonLoad = false;

  File? _image;
  File? _image_temp;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future<void> dataCheck(BuildContext context) async {
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

    try {
      await FetchController(
        endpoint: 'organizations/',
        fromJson: (json) => AddOrganizationResponse.fromJson(json),
      ).postMultipartData(
        dataKeyName: 'organization',
        data: {
          "organizationName": nameController.text,
          "campusId": widget.campusId,
        },
        file: _image!,
        fileKeyName: 'logo',
      );
      setState(() {
        buttonLoad = false;
      });
      log('back to add danusan');
      navigateBack(context, result: 'load org');
    } on Exception catch (e) {
      // TODO
      setState(() {
        buttonLoad = false;
      });
      log(e.toString());
      showToast(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: backButtonCustom(context: context),
        leadingWidth: 90,
        title: Text(
          'Tambah Organisasi',
          style: AppTextStyles.appBarTitle,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
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
                      border: _image == null
                          ? DashedBorder.fromBorderSide(
                              dashLength: 12,
                              side: BorderSide(
                                color: Warna.biru,
                                width: 3,
                              ),
                            )
                          : null,
                    ),
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )
                        : Center(
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
                labelText: 'Nama Organisasi',
              ),
              const SizedBox(
                height: 40,
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
