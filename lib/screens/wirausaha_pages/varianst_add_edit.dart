import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/data_variants_local.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'package:uicons/uicons.dart';

class AddEditVariantsScreen extends StatefulWidget {
  final bool isEdit;
  const AddEditVariantsScreen({super.key, this.isEdit = false});

  @override
  State<AddEditVariantsScreen> createState() => _AddEditVariantsScreenState();
}

class _AddEditVariantsScreenState extends State<AddEditVariantsScreen> {
  TextEditingController variantNameController = TextEditingController();
  TextEditingController minController = TextEditingController();
  TextEditingController maxController = TextEditingController();
  TextEditingController varianOptionController = TextEditingController();
  TextEditingController varianOptionPriceController = TextEditingController();
  bool variantRequired = false;
  bool addOption = false;
  bool buttonLoad = false;
  List<VariantOption> listOpsiVarian = [];

  void dataCheck() {
    String emptyField = '';
    setState(() {
      buttonLoad = true;
    });
    if (variantNameController.text.isEmpty) {
      setState(() {
        buttonLoad = false;
        emptyField = 'Kolom Nama Varian tidak boleh kosong';
      });
      showToast(emptyField);
      return;
    }

    if (minController.text.isEmpty) {
      setState(() {
        buttonLoad = false;
        emptyField = 'Kolom Minimal tidak boleh kosong';
      });
      showToast(emptyField);
      return;
    }

    if (maxController.text.isEmpty) {
      setState(() {
        buttonLoad = false;
        emptyField = 'Kolom Maksimal tidak boleh kosong';
      });
      showToast(emptyField);
      return;
    }

    VariantDatas newVariant = VariantDatas(
      variantName: variantNameController.text,
      isRequired: variantRequired,
      minimal: int.parse(minController.text),
      maximal: int.parse(maxController.text),
      variantOption: listOpsiVarian,
    );

    setState(() {
      MenuConfig.variants.add(newVariant);
      buttonLoad = false;
    });
    log(MenuConfig.variants.toString());
  }

  void addVariantOption() {
    VariantOption opsiVarian = VariantOption(
      variantOptionName: varianOptionController.text,
      variantOptionPrice: int.parse(varianOptionPriceController.text),
    );

    setState(() {
      listOpsiVarian.add(opsiVarian);
    });
    log(listOpsiVarian.toString());
    setState(() {
      varianOptionController.clear();
      varianOptionPriceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: backButtonCustom(context: context),
        leadingWidth: 90,
        title: InkWell(
          onTap: () {
            setState(() {
              MenuConfig.variants.clear();
            });
          },
          child: Text(
            'Tambah Varian',
            style: AppTextStyles.appBarTitle,
          ),
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
              CTextField(
                controller: variantNameController,
                labelText: 'Nama Vraian',
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: variantRequired,
                    onChanged: (value) {
                      setState(() {
                        variantRequired = value!;
                      });
                    },
                  ),
                  const SizedBox(
                      width: 8), // Add some spacing between checkbox and text
                  const Text('Varian Wajib Dipilih'),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CTextField(
                      controller: minController,
                      labelText: 'Minimal Pilihan Opsi',
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: CTextField(
                      controller: maxController,
                      labelText: 'Maksimal Pilihan Opsi',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
               const Text(
                      'Opsi Varian',
                      style: AppTextStyles.labelInput,
                    ),
                    const SizedBox(height: 10,),
              listOpsiVarian.isNotEmpty
                  ? ListView.builder(
                      itemCount: listOpsiVarian.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, idx) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: opsiVarianItem(
                            name: listOpsiVarian[idx].variantOptionName,
                            price:
                                listOpsiVarian[idx].variantOptionPrice.toString(),
                            onTapEdit: () {},
                            onTapDelete: () {},
                          ),
                        );
                      })
                  : Container(),
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
                      // setState(() {
                      //   addOption = !addOption;
                      // });
                      variantOptionSheet(context);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'Tambah Opsi',
                      style: TextStyle(
                        color: Warna.biru,
                        fontSize: 15,
                      ),
                    )),
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
                    dataCheck();
                  },
                  text: 'Simpan',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget opsiVarianItem(
      {String? name,
      String? price,
      VoidCallback? onTapEdit,
      VoidCallback? onTapDelete}) {
    return Container(
      // height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Warna.abu, width: 1),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${name!} - ${price!}',
            style: AppTextStyles.textInput,
          ),
          const Spacer(),
          InkWell(
            onTap: onTapEdit,
            child: Icon(
              UIcons.solidRounded.pencil,
              size: 20,
              color: Warna.kuning,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: onTapDelete,
            child: Icon(
              UIcons.solidRounded.trash,
              size: 20,
              color: Warna.like,
            ),
          ),
        ],
      ),
    );
  }

  Future variantOptionSheet(
    BuildContext? context,
  ) {
    return showModalBottomSheet(
      context: context!,
      // barrierColor: Colors.transparent,
      backgroundColor: Colors.white,
      // isDismissible: false,
      enableDrag: false,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        final DraggableScrollableController scrollController =
            DraggableScrollableController();
        return StatefulBuilder(
          builder: (context, setState) {
            return GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! > 0) {
                  // Dragging down
                  scrollController.jumpTo(
                      0.1); // Set to minimum size (10% of screen height)
                } else if (details.primaryDelta! < 0) {
                  // Dragging up
                  scrollController.jumpTo(
                      0.45); // Set to initial size (45% of screen height)
                }
              },
              child: DraggableScrollableSheet(
                  shouldCloseOnMinExtent: false,
                  controller: scrollController,
                  initialChildSize:
                      0.5, // Initial height when sheet is first opened
                  minChildSize: 0.2, // Minimum height when sheet is collapsed
                  maxChildSize:
                      0.9, // Maximum height when sheet is fully expanded
                  expand: false, // Set to false to prevent full expansion
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tambah Opsi Varian',
                              style: AppTextStyles.labelInput,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CTextField(
                              controller: varianOptionController,
                              labelText: 'Nama Opsi',
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CTextField(
                              controller: varianOptionPriceController,
                              labelText: 'Harga Tambahan (Opsional)',
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: CBlueButton(
                                  onPressed: () {
                                    addVariantOption();
                                    navigateBack(context);
                                  },
                                  text: 'Tambah',
                                  borderRadius: 55,
                                )),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          },
        );
      },
    );
  }
}
