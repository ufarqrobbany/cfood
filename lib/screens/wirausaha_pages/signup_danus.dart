import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/all_activity_response.dart';
import 'package:cfood/model/all_organization_response.dart';
import 'package:cfood/model/register_danus_response.dart';
import 'package:cfood/repository/fetch_controller.dart';
import 'package:cfood/screens/wirausaha_pages/activity_add.dart';
import 'package:cfood/screens/wirausaha_pages/organization_add.dart';
import 'package:cfood/style.dart';
import 'package:cfood/utils/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class SignUpDanusScreen extends StatefulWidget {
  final int? campusId;
  const SignUpDanusScreen({
    super.key,
    this.campusId,
  });

  @override
  State<SignUpDanusScreen> createState() => _SignUpDanusScreenState();
}

class _SignUpDanusScreenState extends State<SignUpDanusScreen> {
  TextEditingController organizationController = TextEditingController();
  TextEditingController programController = TextEditingController();
  bool organizationSuggestion = false;
  bool showProgramSuggestion = false;

  List<DataGetOrganization>? organizationList;
  String selectedOrganization = '';
  int selectedOrganizationId = 0;

  List<DataGetActivity>? activityList;
  List<DataGetActivity>? filteredActivityList;
  String selectedActivity = '';
  int selectedActivityId = 0;

  bool buttonLoad = false;

  @override
  void initState() {
    super.initState();
    log('campusId ${widget.campusId}');
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

  Future<void> getActivity(
    BuildContext context,
  ) async {
    GetAllActivityResponse? dataResponse = await FetchController(
      endpoint: 'organizations/$selectedOrganizationId/activities',
      fromJson: (json) => GetAllActivityResponse.fromJson(json),
    ).getData();

    if (dataResponse != null && dataResponse.data != null) {
      setState(() {
        activityList = dataResponse.data;
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

    if (programController.text.isEmpty || selectedActivityId == 0) {
      setState(() {
        buttonLoad = false;
        emptyField = 'Kolom kegiatan tidak boleh kosong';
      });
      showToast(emptyField);
      return;
    }

    try {
      await FetchController(
        endpoint: 'organizations/merchants_danus',
        fromJson: (json) => RegisterDanusResponse.fromJson(json),
      ).postData({
        "merchantId": AppConfig.MERCHANT_ID,
        "organizationId": selectedOrganizationId,
        "activityId": selectedActivityId,
      });

      setState(() {
        buttonLoad = false;
      });
      log('got to merchant');
      navigateBack(context);
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
          'Daftar Danus',
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
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
              RichText(
                text: TextSpan(
                  text: '',
                  style: TextStyle(color: Colors.grey.shade900, fontSize: 15),
                  children: [
                    TextSpan(
                      text: 'Tambah Organisasi',
                      style: TextStyle(color: Warna.biru, fontSize: 15),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          log('go to add Organization');
                          navigateTo(
                              context,
                              OrganizationAddScreen(
                                campusId: widget.campusId!,
                              )).then((result) {
                            if (result == 'load org') {
                              getOrganizations(context);
                            }
                          });
                          // context.pushReplacementNamed('register');
                          // navigateToRep(context, );
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CTextField(
                hintText: 'Masukkan nama kegiatan',
                labelText: 'Program Kerja/Kegiatan',
                controller: programController,
                onChanged: (p0) {
                  _activityItenmsFilter();
                  // getActivity(context, id: selectedActivityId);
                },
                suffixIcon: IconButton(
                  icon: Icon(
                      showProgramSuggestion && programController.text.isNotEmpty
                          ? Icons.arrow_drop_down_rounded
                          : Icons.arrow_left_rounded),
                  onPressed: () {
                    log(programController.text);
                    // print("not filter : " + _campusList.toString());
                    log("filtered : $filteredActivityList");
                    setState(() {
                      showProgramSuggestion = !showProgramSuggestion;
                    });
                  },
                ),
              ),
              if (showProgramSuggestion && programController.text.isNotEmpty)
                activitySelection(),
              const SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  text: '',
                  style: TextStyle(color: Colors.grey.shade900, fontSize: 15),
                  children: [
                    TextSpan(
                      text: 'Tambah Kegiatan',
                      style: TextStyle(color: Warna.biru, fontSize: 15),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          log('go to add Kegiatan');
                          // context.pushReplacementNamed('register');

                          navigateTo(
                              context,
                              ActivityAddScreen(
                                campusId: widget.campusId!,
                              ));
                        },
                    ),
                  ],
                ),
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
                  },
                  text: 'Daftar',
                ),
              )
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
              getActivity(context);
            },
          );
        },
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
        itemCount: filteredActivityList?.length,
        itemBuilder: (context, index) {
          return ListTile(
            dense: false,
            title: Text(filteredActivityList![index].activityName!),
            onTap: () {
              setState(() {
                programController.text =
                    filteredActivityList![index].activityName!;
                selectedActivity = programController.text;
                selectedActivityId = filteredActivityList![index].id!;
                showProgramSuggestion = false;
              });
            },
          );
        },
      ),
    );
  }

  void _activityItenmsFilter() {
    String query = programController.text.toLowerCase();
    log('Query: $query');
    if (query.isNotEmpty) {
      List<DataGetActivity> filteredList = activityList!.where((activity) {
        return activity.activityName!.toLowerCase().contains(query);
      }).toList();

      filteredList.sort((a, b) {
        int indexA = a.activityName!.toLowerCase().indexOf(query);
        int indexB = b.activityName!.toLowerCase().indexOf(query);
        return indexA.compareTo(indexB);
      });

      setState(() {
        filteredActivityList = filteredList.cast<DataGetActivity>();
        showProgramSuggestion = true;
      });
      log('Filtered List: $filteredActivityList');
    } else {
      setState(() {
        filteredActivityList = [];
        showProgramSuggestion = false;
      });
      log('Filtered List cleared');
    }
  }
}
