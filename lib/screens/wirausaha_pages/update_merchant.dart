import 'dart:developer';
import 'dart:io';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/add_merchants_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/auth.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:toast/toast.dart';
import 'package:uicons/uicons.dart';

class UpdateMerchantScreen extends StatefulWidget {
  final int? merchantId;
  const UpdateMerchantScreen({super.key, this.merchantId});

  @override
  State<UpdateMerchantScreen> createState() => _UpdateMerchantScreenState();
}

class _UpdateMerchantScreenState extends State<UpdateMerchantScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String nameBeforeUpdate = '';
  String descBeforeUpdate = '';
  bool buttonLoad = false;
  String? photoMerchant;
  AddMerchantResponse? dataResponse;

  File? _image;
  File? _image_temp;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchSummaryMerchant();
  }

  Future<void> fetchSummaryMerchant() async {
    dataResponse = await FetchController(
      endpoint: 'merchants/${widget.merchantId}',
      fromJson: (json) => AddMerchantResponse.fromJson(json),
    ).getData();

    setState(() {
      nameBeforeUpdate = dataResponse!.data!.merchantName!;
      descBeforeUpdate = dataResponse!.data!.merchantDesc!;

      nameController.text = dataResponse!.data!.merchantName!;
      descriptionController.text = dataResponse!.data!.merchantDesc!;
      photoMerchant =
          AppConfig.URL_IMAGES_PATH + dataResponse!.data!.merchantPhoto!;
    });
    log(
      {
        "name": nameController.text,
        "desc": descriptionController.text,
        "photo": photoMerchant,
      }.toString(),
    );
  }

  void dataCheck(BuildContext context) async {
    setState(() {
      buttonLoad = true;
    });

    // if (_image == null) {
    //   setState(() {
    //     buttonLoad = false;
    //   });
    //   showToast('Pilih gambar untuk toko kamu');
    //   return;
    // }

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

    if(nameController.text == nameBeforeUpdate && descriptionController.text == descBeforeUpdate) {
      setState(() {
        buttonLoad = false;
      });
      showToast('Kamu belum melakukan perubahan apapun!');
      return;
    }

    try {
      log('image = $_image');
      AddMerchantResponse response = await FetchController(
        endpoint: 'merchants/update',
        headers: {
          "Content-Type": 'multipart/form-data',
          "Accept": "*/*",
        } ,
        fromJson: (json) => AddMerchantResponse.fromJson(json),
      ).puttMultipartData(
        dataKeyName: 'merchant',
        data: {
          "merchantId": widget.merchantId,
          "merchantName": nameController.text,
          "merchantDesc": descriptionController.text,
        },
        fileKeyName: 'photo',
        file: _image,
        withImage: _image == null ? false : true,
      );

      DataMerchant dataMerchant = response.data!;
      log(dataMerchant.toString());

      AuthHelper().setMerchantId(id: dataMerchant.merchantId.toString());
      setState(() {
        AppConfig.MERCHANT_ID = dataMerchant.merchantId!;
        AppConfig.MERCHANT_NAME = dataMerchant.merchantName!;
        AppConfig.MERCHANT_DESC = dataMerchant.merchantDesc!;
        AppConfig.MERCHANT_OPEN = dataMerchant.open!;
        AppConfig.MERCHANT_TYPE = dataMerchant.merchantType!;
        AppConfig.MERCHANT_PHOTO += dataMerchant.merchantPhoto!;
      });

      setState(() {
        buttonLoad = false;
      });
      log('go to profile');
      navigateBack(context);
      // navigateToRep(context, const VerificatioWirausahanSuccess());
    } on Exception catch (e) {
      setState(() {
        buttonLoad = false;
      });
      showToast(
        e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return dataResponse == null
        ? Container(
            width: double.infinity,
            height: double.infinity,
            color: Warna.pageBackgroundColor,
            child: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Warna.biru, size: 35),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leadingWidth: 90,
              leading: backButtonCustom(context: context),
              title: InkWell(
                onTap: () {
                  setState(() {
                    buttonLoad = false;
                  });
                },
                child: Text(
                  'Update Wirausaha',
                  style: AppTextStyles.appBarTitle,
                ),
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
                              : photoMerchant != null
                                  ? Image.network(
                                      photoMerchant!,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                      subLabelText: '  ${descriptionController.text.length}/100 karakter',
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
                        text: 'Update',
                      ),
                    ),
                    const SizedBox(
                      height: 60,
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
