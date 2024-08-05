import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/add_menu_response.dart';
// import 'package:cfood/model/data_variants_local.dart';
import 'package:cfood/model/get_category_response.dart';
import 'package:cfood/model/get_detail_merchant_response.dart';
import 'package:cfood/model/get_specific_menu_response.dart';
import 'package:cfood/model/reponse_handler.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/wirausaha_pages/category_add.dart';
import 'package:cfood/screens/wirausaha_pages/varianst_add_edit.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:toast/toast.dart';
import 'package:uicons/uicons.dart';
import 'package:cfood/model/get_detail_merchant_response.dart'
    as detailmerchant;

class AddEditMenuScreen extends StatefulWidget {
  final bool isEdit;
  final bool merchantIsDanus;
  final int menuId;
  const AddEditMenuScreen({
    super.key,
    this.isEdit = false,
    this.merchantIsDanus = false,
    this.menuId = 0,
  });

  @override
  State<AddEditMenuScreen> createState() => _AddEditMenuScreenState();
}

class _AddEditMenuScreenState extends State<AddEditMenuScreen> {
  TextEditingController nameProductController = TextEditingController();
  TextEditingController produckCategoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  File? _image;
  File? _image_temp;
  String img_url = '';
  final picker = ImagePicker();
  bool buttonLoad = false;
  bool isDanusan = false;

  GetCategoryResponse? categoryResponse;
  List<DataCategory>? dataCategoryList;
  List<DataCategory>? filterCategoryList;
  String selectedCategory = '';
  int selectedCategoryId = 0;
  bool showCategoryBox = false;
  // List<VariantDatas> dataListVariant = [];
  List<detailmerchant.Variant> dataListVariant = [];

  DataSpecificMenu? dataSpecificMenu;
  String nameMenuBefore = '';
  String descMenuBefore = '';
  String priceMenuBefore = '';
  String stockMenuBefore = '';

  @override
  void initState() {
    super.initState();
    getCategory();
    setState(() {
      dataListVariant = MenuConfig.variants;
    });
    if (widget.isEdit) {
      getDataMenu(BuildContext);
    }
  }

  Future<void> getCategory() async {
    log(AppConfig.MERCHANT_ID.toString());
    categoryResponse = await FetchController(
      endpoint: 'menus/categories/${AppConfig.MERCHANT_ID}',
      fromJson: (json) => GetCategoryResponse.fromJson(json),
    ).getData();

    if (categoryResponse != null) {
      dataCategoryList = categoryResponse!.data;
    }
  }

  Future<void> dataCheck(BuildContext context) async {
    String emptyField = '';
    setState(() {
      buttonLoad = true;
    });
    if (_image == null) {
      setState(() {
        buttonLoad = false;
        emptyField = 'Gambar tidak boleh kosong';
      });
      showToast(emptyField);
      return;
    }

    if (nameProductController.text.isEmpty) {
      setState(() {
        buttonLoad = false;
        emptyField = 'Kolom Nama tidak boleh kosong';
      });
      showToast(emptyField);
      return;
    }

    if (produckCategoryController.text.isEmpty && selectedCategoryId == 0) {
      setState(() {
        buttonLoad = false;
        emptyField = 'Kolom Kategori tidak boleh kosong';
      });
      showToast(emptyField);
      return;
    }

    if (descriptionController.text.isEmpty) {
      setState(() {
        buttonLoad = false;
        emptyField = 'Kolom Deskripsi tidak boleh kosong';
      });
      showToast(emptyField);
      return;
    }

    if (priceController.text.isEmpty) {
      setState(() {
        buttonLoad = false;
        emptyField = ' Harga tidak boleh kosong';
      });
      showToast(emptyField);
      return;
    }

    if (stockController.text.isEmpty) {
      setState(() {
        buttonLoad = false;
        emptyField = 'Kolom Stok tidak boleh kosong';
      });
      showToast(emptyField);
      return;
    }

    log('variant : ${json.encode(dataListVariant)}');
    log('variant data type : ${json.encode(dataListVariant).runtimeType}');
    log('variant : ${json.encode(dataListVariant.map((variant) => variant.toJson()).toList())}');

    try {
      await FetchController(
        endpoint: 'menus/',
        fromJson: (json) => AddMenuResponse.fromJson(json),
        headers: {
          "Content-Type": 'multipart/form-data',
          "Accept": "*/*",
          // "Accept-Encoding": 'gzip, deflate, br',
        },
      ).postMultipartData(
        dataKeyName: 'menu',
        data: {
          "menuName": nameProductController.text,
          "categoryMenuId": selectedCategoryId,
          "menuDesc": descriptionController.text,
          "menuPrice": int.parse(priceController.text),
          "menuStock": int.parse(stockController.text),
          "isDanus": isDanusan,
          "merchantId": AppConfig.MERCHANT_ID,
          // "variants": dataListVariant,
          "variants":
              dataListVariant.map((variant) => variant.toJson()).toList(),
        },
        fileKeyName: 'photo',
        file: _image!,
      );

      setState(() {
        buttonLoad = false;
      });
      MenuConfig.variants.clear();
      dataListVariant.clear();
      log('go to canteen');
      navigateBack(context);
    } on Exception catch (e) {
      // TODO
      setState(() {
        buttonLoad = false;
      });
      log({
        "menuName": nameProductController.text,
        "categoryMenuId": selectedCategoryId,
        "menuDesc": descriptionController.text,
        "menuPrice": int.parse(priceController.text),
        "menuStock": int.parse(stockController.text),
        "isDanus": isDanusan,
        "merchantId": AppConfig.MERCHANT_ID,
        // "variants": dataListVariant,
        "variants": dataListVariant.map((variant) => variant.toJson()).toList(),
      }.toString());
      log('somthing wong in $e');
    }
  }

  void deleteVariant(int index) {
    setState(() {
      MenuConfig.variants.removeAt(index);
      dataListVariant.removeAt(index);
    });
  }

  Future<void> updateMenu(BuildContext context) async {
    log('update menu');
    String emptyField = '';
    setState(() {
      buttonLoad = true;
    });

    if (nameProductController.text == nameMenuBefore &&
        descriptionController.text == descMenuBefore &&
        priceController.text == priceMenuBefore &&
        stockController.text == stockMenuBefore) {
      setState(() {
        buttonLoad = false;
        emptyField = 'Kamu belum melakukan perubahan apapun';
      });
      showToast(emptyField);
      return;
    }

    try {
      // await FetchController(
      //   endpoint: 'menus/',
      //   fromJson: (json) => AddMenuResponse.fromJson(json),
      //   headers: {
      //     "Content-Type": 'multipart/form-data',
      //     "Accept": "*/*",
      //     // "Accept-Encoding": 'gzip, deflate, br',
      //   },
      // ).postMultipartData(
      //   dataKeyName: 'menu',
      //   data: {
      //     "menuName": nameProductController.text,
      //     "categoryMenuId": selectedCategoryId,
      //     "menuDesc": descriptionController.text,
      //     "menuPrice": int.parse(priceController.text),
      //     "menuStock": int.parse(stockController.text),
      //     "isDanus": isDanusan,
      //     "merchantId": AppConfig.MERCHANT_ID,
      //     "variants": dataListVariant,
      //   },
      //   fileKeyName: 'photo',
      //   file: _image!,
      // );

      setState(() {
        buttonLoad = false;
      });
      MenuConfig.variants.clear();
      dataListVariant.clear();
      log('go to canteen');
      navigateBack(context);
    } on Exception catch (e) {
      // TODO
      setState(() {
        buttonLoad = false;
      });
      log('somthing wong in $e');
    }
  }

  Future<void> getDataMenu(BuildContext) async {
    GetSpecificMenuResponse? response = await FetchController(
        endpoint: 'menus/${widget.menuId}?userId=${AppConfig.USER_ID}',
        fromJson: (json) => GetSpecificMenuResponse.fromJson(json)).getData();

    log('specific menu > ${response?.data}');
    if (response != null) {
      setState(() {
        dataSpecificMenu = response.data!;
        img_url = '${AppConfig.URL_IMAGES_PATH}${dataSpecificMenu!.menuPhoto!}';
        nameProductController.text = dataSpecificMenu!.menuName!;
        produckCategoryController.text = dataSpecificMenu!.categoryMenuName!;
        descriptionController.text = dataSpecificMenu!.menuDesc!;
        priceController.text = dataSpecificMenu!.menuPrice!.toString();
        stockController.text = dataSpecificMenu!.menuStock!.toString();
        isDanusan = dataSpecificMenu!.isDanus!;
        MenuConfig.variants = dataSpecificMenu!.variants!;
        dataListVariant = MenuConfig.variants;

        nameMenuBefore = dataSpecificMenu!.menuName!;
        descMenuBefore = dataSpecificMenu!.menuDesc!;
        priceMenuBefore = dataSpecificMenu!.menuPrice!.toString();
        stockMenuBefore = dataSpecificMenu!.menuStock!.toString();
      });
    }
  }

  void deleteDataVariant(int index) {
    setState(() {
      // dataListVariant.removeAt(index);
      MenuConfig.variants.removeAt(index);
      dataListVariant = MenuConfig.variants;
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        MenuConfig.variants.clear();
        dataListVariant.clear();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: backButtonCustom(
              context: context,
              customTap: () {
                MenuConfig.variants.clear();
                dataListVariant.clear();
                navigateBack(context);
              }),
          leadingWidth: 90,
          title: Text(
            widget.isEdit ? 'Edit Menu' : 'Tambah Menu',
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: widget.isEdit
                          ? Image.network(
                              img_url,
                              fit: BoxFit.cover,
                            )
                          : _image != null
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
                  controller: nameProductController,
                  hintText: '',
                  labelText: 'Nama Produk',
                ),
                const SizedBox(
                  height: 20,
                ),
                CTextField(
                  controller: produckCategoryController,
                  hintText: '',
                  labelText: 'Kategori Produk',
                  onChanged: (p0) {
                    _categoryItemsFilter();
                    // getActivity(context, id: selectedActivityId);
                  },
                  suffixIcon: IconButton(
                    icon: Icon(showCategoryBox &&
                            produckCategoryController.text.isNotEmpty
                        ? Icons.arrow_drop_down_rounded
                        : Icons.arrow_left_rounded),
                    onPressed: () {
                      log(produckCategoryController.text);
                      // print("not filter : " + _campusList.toString());
                      log("filtered : $filterCategoryList");
                      setState(() {
                        showCategoryBox = !showCategoryBox;
                      });
                    },
                  ),
                ),
                if (showCategoryBox &&
                    produckCategoryController.text.isNotEmpty)
                  activitySelection(),

                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                      onPressed: () {
                        // setState(() {
                        //   loadState = false;
                        // });
                        navigateTo(context, const AddCategoryScreen())
                            .then((result) {
                          if (result == true) {
                            getCategory();
                          }
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Tambah Kategori',
                        style: TextStyle(
                          color: Warna.biru,
                          fontSize: 15,
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                CTextField(
                  controller: descriptionController,
                  hintText: '',
                  labelText: 'Deskripsi',
                  subLabelText:
                      '  ${descriptionController.text.length}/100 karakter',
                  minLines: 5,
                ),
                const SizedBox(
                  height: 20,
                ),
                CTextField(
                  controller: priceController,
                  hintText: '',
                  labelText: 'Harga Produk',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 20,
                ),
                CTextField(
                  controller: stockController,
                  hintText: '',
                  labelText: 'Stok',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 20,
                ),

                const Text(
                  'Varian Produk',
                  style: AppTextStyles.labelInput,
                ),

                dataListVariant.isEmpty
                    ? const SizedBox(
                        height: 10,
                      )
                    : ListView.builder(
                        itemCount: dataListVariant.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemBuilder: (context, index) {
                          // VariantDatas variant = dataListVariant[index];
                          detailmerchant.Variant variant =
                              dataListVariant[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: varianProductBox(
                              varianName: variant.variantName,
                              listOption: variant.variantOptions,
                              varianIdx: index,
                            ),
                          );
                        },
                      ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: DynamicColorButton(
                    onPressed: () {
                      navigateTo(context, const AddEditVariantsScreen())
                          .then((value) {
                        if (value == true) {
                          log('load variant');
                          // initState();
                          setState(() {
                            dataListVariant = MenuConfig.variants;
                          });
                        }
                      });
                    },
                    text: 'Tambah Varian',
                    textColor: Warna.biru1,
                    backgroundColor: Colors.white,
                    borderRadius: 55,
                    border: BorderSide(color: Warna.biru1, width: 1),
                    icon: Icon(
                      Icons.add,
                      color: Warna.biru1,
                    ),
                  ),
                ),

                // kerjain
                widget.merchantIsDanus
                    ? const SizedBox(
                        height: 20,
                      )
                    : Container(),
                widget.merchantIsDanus
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: isDanusan,
                            onChanged: (value) {
                              setState(() {
                                isDanusan = value!;
                              });
                            },
                          ),
                          const SizedBox(
                              width:
                                  8), // Add some spacing between checkbox and text
                          const Text('Produk Danus'),
                        ],
                      )
                    : Container(),

                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 90,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 20,
                  spreadRadius: 0,
                  color: Warna.shadow.withOpacity(0.12),
                  offset: const Offset(0, 0))
            ],
          ),
          child: CBlueButton(
            isLoading: buttonLoad,
            onPressed: () {
              if (widget.isEdit) {
                updateMenu(context);
              } else {
                dataCheck(context);
              }
            },
            text: 'Tambah',
          ),
        ),
      ),
    );
  }

  Widget varianProductBox(
      {String? varianName, List<VariantOption>? listOption, int? varianIdx}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: Warna.abu, width: 1),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 10, 5),
              child: Text(
                varianName!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ListView.builder(
              itemCount: listOption!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              itemBuilder: (context, index) {
                VariantOption item = listOption[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.5),
                  child: Text(
                    '${item.variantOptionName} - ${Constant.currencyCode} ${item.variantOptionPrice}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: DynamicColorButton(
                      onPressed: () {
                        navigateTo(
                          context,
                          AddEditVariantsScreen(
                            isEdit: true,
                            indexVarian: varianIdx,
                          ),
                        );
                      },
                      text: 'Edit',
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      textColor: Warna.regulerFontColor,
                      icon: Icon(
                        UIcons.solidRounded.pencil,
                        size: 15,
                      ),
                      backgroundColor: Warna.kuning,
                      borderRadius: 0,
                    ),
                  ),
                  Expanded(
                    child: DynamicColorButton(
                      onPressed: () {
                        // deleteVariant(varianIdx!);
                        log(varianIdx!.toString());
                        deleteDataVariant(varianIdx);
                      },
                      text: 'Hapus',
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      textColor: Warna.regulerFontColor,
                      icon: Icon(
                        UIcons.solidRounded.trash,
                        size: 15,
                      ),
                      backgroundColor: Warna.like,
                      borderRadius: 0,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget activitySelection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: filterCategoryList?.length,
        itemBuilder: (context, index) {
          return ListTile(
            dense: false,
            title: Text(filterCategoryList![index].categoryMenuName!),
            onTap: () {
              setState(() {
                produckCategoryController.text =
                    filterCategoryList![index].categoryMenuName!;
                selectedCategory = produckCategoryController.text;
                selectedCategoryId = filterCategoryList![index].id!;
                showCategoryBox = false;
              });
            },
          );
        },
      ),
    );
  }

  void _categoryItemsFilter() {
    String query = produckCategoryController.text.toLowerCase();
    log('Query: $query');
    if (query.isNotEmpty) {
      List<DataCategory> filteredList = dataCategoryList!.where((activity) {
        return activity.categoryMenuName!.toLowerCase().contains(query);
      }).toList();

      filteredList.sort((a, b) {
        int indexA = a.categoryMenuName!.toLowerCase().indexOf(query);
        int indexB = b.categoryMenuName!.toLowerCase().indexOf(query);
        return indexA.compareTo(indexB);
      });

      setState(() {
        filterCategoryList = filteredList.cast<DataCategory>();
        showCategoryBox = true;
      });
      log('Filtered List: $filterCategoryList');
    } else {
      setState(() {
        filterCategoryList = [];
        showCategoryBox = false;
      });
      log('Filtered List cleared');
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
