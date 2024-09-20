import 'dart:developer';
import 'dart:io';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:toast/toast.dart';

class ProfileImageUpdateScreen extends StatefulWidget {
  String? imageProfile;

  ProfileImageUpdateScreen({super.key, this.imageProfile});

  @override
  State<ProfileImageUpdateScreen> createState() =>
      _ProfileImageUpdateScreenState();
}

class _ProfileImageUpdateScreenState extends State<ProfileImageUpdateScreen> {
  File? _image;
  File? _image_temp;
  final picker = ImagePicker();
  bool isLoading = false;
  bool isUpdated = false;
  bool imageChanged = false;
  bool canBack = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateProfile() {
    log('cek');
    if (_image != null && isUpdated == false) {
      log('upload');
      uploadPhotoProfile(context);
    } else {
      showOptionsPicker();
    }
  }

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
      setState(() {
        isLoading = true;
      });
      var response = await dio.post(
        '${AppConfig.BASE_URL}users/${AppConfig.USER_ID}/upload-photo',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      log("formdata file: ${formData.files}");

      if (response.statusCode == 200) {
        // Handle successful response
        // print('Photo uploaded successfully');
        showToast('Berhasil Mengubah Foto');
        setState(() {
          _image_temp = _image;
          _image = null; // Reset _image to null after successful upload
          isUpdated = true;
          isLoading = false;
        });
      } else {
        // Handle error response
        // print('Failed to upload photo');
        setState(() {
          isLoading = false;
        });
        showToast('Gagal Mengubah Foto');
      }
    } catch (e) {
      // print('Error: $e');
      // showToast(e.toString());
      if (e is DioException && e.response?.statusCode == 502) {
        showToast('Ukuran Gambar Terlalu Besar');
        setState(() {
          isLoading = false;
        });
      } else {
        showToast('Gagal Mengubah Foto');
        setState(() {
          isLoading = false;
        });
      }
      setState(() {
        _image = null; // Reset _image to null after successful upload
        isLoading = false;
      });
    }
  }

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageChanged = true;
      }
    });
  }

//Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageChanged = true;
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

  bool onPopInvoked(bool back) {
    if (imageChanged) {
      if (isUpdated) {
        setState(() {
          back = true;
        });
        log('Data updated');
        // Navigator.pop(context, 'updated'); // Return 'updated' result
        return back;
      } else {
        setState(() {
          back = false;
        });
        log('data not updated');
        showToast('Foto Belum di Upload');
        return back;
      }
    } else {
      setState(() {
        back = true;
      });
      // Navigator.pop(context); // Return without a result
      return back;
    }
  }

  void goBackk() {
    if (imageChanged) {
      if (isUpdated) {
        navigateBack(context, result: 'updated');
        // return true;
      } else {
        showToast('Foto Belum di Upload');
        // return false;
      }
    } else {
      navigateBack(context);
      // return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    var imageSize = MediaQuery.of(context).size.width - 20;
    return PopScope(
      canPop: true,
      onPopInvoked: onPopInvoked,
      child: Scaffold(
        appBar: AppBar(
          leading: backButtonCustom(
            context: context,
            customTap: () {
              goBackk();
            },
          ),
          leadingWidth: 90,
          backgroundColor: Colors.black,
          foregroundColor: Colors.black,
          scrolledUnderElevation: 0,
        ),
        backgroundColor: Colors.black,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Container(),
              ClipRRect(
                borderRadius: BorderRadius.circular(imageSize),
                child: Container(
                  height: imageSize,
                  width: imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(imageSize),
                    color: Warna.abu,
                  ),
                  child:
                      // AppConfig.URL_PHOTO_PROFILE != AppConfig.URL_IMAGES_PATH ? :
                      _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: imageSize,
                                  width: imageSize,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(imageSize),
                                    color: Warna.abu,
                                  ),
                                );
                              },
                            )
                          : _image_temp != null
                              ? Image.file(
                                  _image_temp!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: imageSize,
                                      width: imageSize,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(imageSize),
                                        color: Warna.abu,
                                      ),
                                    );
                                  },
                                )
                              : Image.network(
                                  widget.imageProfile != null
                                      ? '${AppConfig.URL_IMAGES_PATH}${widget.imageProfile}'
                                      // '${AppConfig.URL_PHOTO_PROFILE}}'
                                      : 'https://i.pinimg.com/originals/d9/d8/8e/d9d88e3d1f74e2b8ced3df051cecb81d.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: imageSize,
                                      width: imageSize,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(imageSize),
                                        color: Warna.abu,
                                      ),
                                    );
                                  },
                                ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: buttonUpdateImage(),
      ),
    );
  }

  Widget buttonUpdateImage() {
    return Container(
        height: 65,
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        color: Colors.black,
        child: CBlueButton(
          onPressed: () {
            updateProfile();
          },
          text: _image != null ? 'Update' : 'Change Image',
          isLoading: isLoading,
        ));
  }
}
