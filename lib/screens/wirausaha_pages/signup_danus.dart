import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/model/all_organization_response.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';

class SignUpDanusScreen extends StatefulWidget {
  const SignUpDanusScreen({super.key});

  @override
  State<SignUpDanusScreen> createState() => _SignUpDanusScreenState();
}

class _SignUpDanusScreenState extends State<SignUpDanusScreen> {
  TextEditingController organizationController = TextEditingController();
  TextEditingController programController = TextEditingController();
  bool organizationSuggestion = false;
  bool showProgramSuggestion = false;

  List<DataGetOrganization>? organizationList;
  List<DataGetOrganization>? filteredOrganization;

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Warna.pageBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 25,),

              CTextField(
                hintText: 'Himpunan Mahasiswa Komputer',
                labelText: 'Organisasi',
                controller: organizationController,
                suffixIcon: IconButton(
                  icon: Icon(organizationSuggestion &&
                          organizationController.text.isNotEmpty
                      ? Icons.arrow_drop_down_rounded
                      : Icons.arrow_left_rounded),
                  onPressed: () {
                    log(organizationController.text);
                    // print("not filter : " + _campusList.toString());
                    // log("filtered : $_filteredMajorList");
                    setState(() {
                      organizationSuggestion = !organizationSuggestion;
                    });
                  },
                ),
              ),
              if (organizationSuggestion &&
                organizationController.text.isNotEmpty)
              // departementSelection(),

              CTextField(
                hintText: 'Tisigram',
                labelText: 'Program kerja/Kegiatan',
                controller: programController,
              ),
            ],
          ),
          
        ),
      ),
    );
  }

  //   Widget departementSelection() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.grey),
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: ListView.builder(
  //       shrinkWrap: true,
  //       itemCount: _filteredDepartementList.length,
  //       itemBuilder: (context, index) {
  //         return ListTile(
  //           title: Text(_filteredDepartementList[index].programName!),
  //           onTap: () {
  //             setState(() {
  //               departementController.text =
  //                   _filteredDepartementList[index].programName!;
  //               selectedDepartment = organizationController.text;
  //               selectedStudyProgramId = _filteredDepartementList[index].id!;
  //               organizationSuggestion = false;
  //             });
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  //   void _departementItenmsFilter() {
  //   String query = departementController.text.toLowerCase();
  //   log('Query: $query');
  //   if (query.isNotEmpty) {
  //     List<DataStudyProgram> filteredList = studyProgramItems.where((campus) {
  //       return campus.programName!.toLowerCase().contains(query);
  //     }).toList();

  //     filteredList.sort((a, b) {
  //       int indexA = a.programName!.toLowerCase().indexOf(query);
  //       int indexB = b.programName!.toLowerCase().indexOf(query);
  //       return indexA.compareTo(indexB);
  //     });

  //     setState(() {
  //       _filteredDepartementList = filteredList.cast<DataStudyProgram>();
  //       _showDepartementSuggestion = true;
  //     });
  //     log('Filtered List: $_filteredDepartementList');
  //   } else {
  //     setState(() {
  //       _filteredDepartementList = [];
  //       _showDepartementSuggestion = false;
  //     });
  //     log('Filtered List cleared');
  //   }
  // }
}
