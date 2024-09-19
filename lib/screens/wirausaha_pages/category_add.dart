import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/add_category_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  TextEditingController namaCategoryController =TextEditingController();
  bool buttonLoad = false;

    Future<void> dataCheck(BuildContext context) async {
    String emptyField = '';
    setState(() {
      buttonLoad = true;
    });
    if (namaCategoryController.text.isEmpty) {
      setState(() {
        buttonLoad = false;
        emptyField = 'Kolom Organisasi tidak boleh kosong';
      });
      showToast(emptyField);
      return;
    }

    try {
      await FetchController(
        endpoint: 'menus/categories',
        fromJson: (json) => AddCategoryResponse.fromJson(json),
      ).postData({
        "merchantId": AppConfig.MERCHANT_ID,
        "categoryMenuName": namaCategoryController.text,
      });

      setState(() {
        buttonLoad = false;
      });
      log('got to add product');
      navigateBack(context, result: true);
    } on Exception catch (e) {
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
          'Tambah Kategori',
          style: AppTextStyles.appBarTitle,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 25), child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25,),

            CTextField(
              labelText: 'Nama Kategori',
              hintText: '',
              controller: namaCategoryController,
            ),

            const SizedBox(height: 40,),

            SizedBox(
              height: 50,
              width: double.infinity,
              child: CBlueButton(
                isLoading: buttonLoad,
                onPressed: () {
                  dataCheck(context);
                }, text: 'Tambah'),
            )
          ],
        ),),
      ),
    );
  }
}