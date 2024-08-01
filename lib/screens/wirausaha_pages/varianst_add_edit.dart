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
  final int? indexVarian;
  const AddEditVariantsScreen({super.key, this.isEdit = false, this.indexVarian});

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

  @override
  void initState() {
    super.initState();

    if(widget.isEdit) {
      isEditVariant();
    }
  }

  void isEditVariant(){
    variantNameController.text = MenuConfig.variants[widget.indexVarian!].variantName!;
    minController.text = MenuConfig.variants[widget.indexVarian!].minimal!.toString();
    maxController.text = MenuConfig.variants[widget.indexVarian!].maximal!.toString();
    variantRequired = MenuConfig.variants[widget.indexVarian!].isRequired!;
    listOpsiVarian = MenuConfig.variants[widget.indexVarian!].variantOption!;
  }

  void tapEditVariant(){
    MenuConfig.variants[widget.indexVarian!] = VariantDatas(
      variantName: variantNameController.text,
      isRequired: variantRequired,
      minimal: int.parse(minController.text),
      maximal: int.parse(maxController.text),
      variantOption: listOpsiVarian,
    );

    log(MenuConfig.variants[widget.indexVarian!].toString());
    navigateBack(context);
  }

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

    if(listOpsiVarian == []) {
      setState(() {
        buttonLoad = false;
        emptyField = 'Opsi Varian Tidak boleh kosong';
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
    navigateBack(context);
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

  void editVariantOption(int index) {
    setState(() {
      listOpsiVarian[index] = VariantOption(
        variantOptionName: varianOptionController.text,
        variantOptionPrice: int.parse(varianOptionPriceController.text),
      );
    });
    log(listOpsiVarian.toString());
    varianOptionController.clear();
    varianOptionPriceController.clear();
  }

  void deleteVariantOption(int index) {
    setState(() {
      listOpsiVarian.removeAt(index);
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
                labelText: 'Nama Varian',
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
              const SizedBox(
                height: 10,
              ),
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
                            price: listOpsiVarian[idx]
                                .variantOptionPrice
                                .toString(),
                            onTapEdit: () {
                              variantOptionSheet(
                                context,
                                editIndex: idx,
                                editName: listOpsiVarian[idx].variantOptionName,
                                editPrice: listOpsiVarian[idx]
                                    .variantOptionPrice
                                    .toString(),
                              );
                            },
                            onTapDelete: () {
                              deleteVariantOption(idx);
                            },
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
                  onPressed: widget.isEdit ? () {
                    tapEditVariant();
                  } : () {
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
    BuildContext context, {
    int? editIndex,
    String? editName,
    String? editPrice,
  }) {
    varianOptionController.text = editName ?? '';
    varianOptionPriceController.text = editPrice ?? '';

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
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
                  scrollController.jumpTo(0.1);
                } else if (details.primaryDelta! < 0) {
                  scrollController.jumpTo(0.45);
                }
              },
              child: DraggableScrollableSheet(
                  shouldCloseOnMinExtent: false,
                  controller: scrollController,
                  initialChildSize: 0.5,
                  minChildSize: 0.2,
                  maxChildSize: 0.9,
                  expand: false,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 25,
                          right: 25,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              editIndex == null
                                  ? 'Tambah Opsi Varian'
                                  : 'Edit Opsi Varian',
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
                                  if (editIndex == null) {
                                    addVariantOption();
                                  } else {
                                    editVariantOption(editIndex);
                                  }
                                  navigateBack(context);
                                },
                                text: editIndex == null ? 'Tambah' : 'Edit',
                                borderRadius: 55,
                              ),
                            ),
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
