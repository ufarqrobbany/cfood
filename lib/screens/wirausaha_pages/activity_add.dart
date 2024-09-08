import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/add_activity_response.dart';
import 'package:cfood/model/all_organization_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ActivityAddScreen extends StatefulWidget {
  final int organizationId;
  final int campusId;
  const ActivityAddScreen(
      {super.key, this.organizationId = 0, this.campusId = 0});

  @override
  State<ActivityAddScreen> createState() => _ActivityAddScreenState();
}

class _ActivityAddScreenState extends State<ActivityAddScreen> {
  TextEditingController organizationController = TextEditingController();
  TextEditingController programController = TextEditingController();
  bool organizationSuggestion = false;
  List<DataGetOrganization>? organizationList;
  String selectedOrganization = '';
  int selectedOrganizationId = 0;

  bool buttonLoad = false;

  @override
  void initState() {
    super.initState();
    log('campusId ${widget.organizationId}');
    getOrganizations(context, name: '');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getOrganizations(BuildContext context,
      {String name = ''}) async {
    GetAllOrganizationResponse? dataResponse = await FetchController(
      endpoint: 'organizations/?campusId=${widget.campusId}&name=$name',
      fromJson: (json) => GetAllOrganizationResponse.fromJson(json),
    ).getData();

    if (dataResponse != null && dataResponse.organizations != null) {
      setState(() {
        organizationList = dataResponse.organizations;
      });
    }
  }

  Future<void> dataCheck(BuildContext context) async {
    String emptyField = '';
    setState(() {
      buttonLoad = true;
    });
    if (organizationController.text.isEmpty || selectedOrganizationId == 0) {
      setState(() {
        buttonLoad = false;
        emptyField = 'Kolom Organisasi tidak boleh kosong';
      });
      showToast(emptyField);
      return;
    }

    if (programController.text.isEmpty) {
      setState(() {
        buttonLoad = false;
        emptyField = 'Kolom Kegiatan tidak boleh kosong';
      });
      showToast(emptyField);
      return;
    }

    try {
      await FetchController(
        endpoint: 'organizations/activities',
        fromJson: (json) => AddActivityResponse.fromJson(json),
      ).postData(
        {
          "activityName": programController.text,
          "organizationId": selectedOrganizationId,
        },
      );
      setState(() {
        buttonLoad = false;
      });
      log('back to add danusan');
      navigateBack(context, result: 'load act');
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
          'Tambah Kegiatan',
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
            children: [
              const SizedBox(
                height: 25,
              ),
              CTextField(
                hintText: 'Masukkan nama organisasi',
                labelText: 'Organisasi',
                controller: organizationController,
                onChanged: (p0) {
                  getOrganizations(context, name: p0);
                },
                suffixIcon: IconButton(
                  icon: Icon(organizationSuggestion &&
                          organizationController.text.isNotEmpty
                      ? Icons.arrow_drop_down_rounded
                      : Icons.arrow_left_rounded),
                  onPressed: () {
                    log(organizationController.text);
                    // print("not filter : " + _campusList.toString());
                    log("filtered : $organizationList");
                    setState(() {
                      organizationSuggestion = !organizationSuggestion;
                    });
                  },
                ),
              ),
              if (organizationSuggestion &&
                  organizationController.text.isNotEmpty)
                organizationSelection(),
              const SizedBox(
                height: 20,
              ),
              CTextField(
                controller: programController,
                hintText: '',
                labelText: 'Nama Program Kerja/Kegiatan',
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
                  text: 'Tambah',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget organizationSelection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: organizationList?.length,
        itemBuilder: (context, index) {
          return ListTile(
            dense: false,
            title: Text(organizationList![index].organizationName!),
            onTap: () {
              setState(() {
                organizationController.text =
                    organizationList![index].organizationName!;
                selectedOrganization = organizationController.text;
                selectedOrganizationId = organizationList![index].id!;
                organizationSuggestion = false;
              });
              log(selectedOrganizationId.toString());
              // getActivity(context);
            },
          );
        },
      ),
    );
  }
}
