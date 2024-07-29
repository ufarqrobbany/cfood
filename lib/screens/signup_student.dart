import 'dart:developer';

import 'package:cfood/custom/CButtons.dart';
import 'package:cfood/custom/CPageMover.dart';
import 'package:cfood/custom/CTextField.dart';
import 'package:cfood/custom/CToast.dart';
import 'package:cfood/model/campuses_list_reponse.dart';
import 'package:cfood/model/check_nim_response.dart';
import 'package:cfood/model/major_list_reponse.dart';
import 'package:cfood/model/study_program_list_reponse.dart';
import 'package:cfood/repository/register_repository.dart';
import 'package:cfood/screens/create_password.dart';
import 'package:cfood/style.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class SignUpStudentScreen extends StatefulWidget {
  final String? name;
  final String? selectedUniversity;
  final int? campusId;
  final String? email;
  const SignUpStudentScreen({
    super.key,
    this.name,
    this.selectedUniversity,
    this.campusId,
    this.email,
  });

  @override
  State<SignUpStudentScreen> createState() => _SignUpStudentScreenState();
}

class _SignUpStudentScreenState extends State<SignUpStudentScreen> {
  final TextEditingController nimController = TextEditingController();
  final TextEditingController admissionController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController departementController = TextEditingController();
  String? selectedDepartment;
  String? selectedMajor;
  int? selectedMajorId;
  int? selectedStudyProgramId;
  bool _showMajorSuggestion = false;
  bool _showDepartementSuggestion = false;
  List<DataMajorItem> _filteredMajorList = [];
  List<DataStudyProgram> _filteredDepartementList = [];
  List<DataCampusesItem> campusesList = [];
  bool loadButton = false;

  List<DataMajorItem> majorItems = [];
  List<DataStudyProgram> studyProgramItems = [];

  // final Map<String, Map<String, List<String>>> universities = {
  //   'Universitas Indonesia': {
  //     'Fakultas Teknik': ['Teknik Mesin', 'Teknik Elektro', 'Teknik Kimia'],
  //     'Fakultas Ekonomi': ['Akuntansi', 'Manajemen', 'Ilmu Ekonomi'],
  //     'Fakultas Tiktok': [
  //       'Afilitas Startegy',
  //       'Tobrut Theory',
  //       'Content Science'
  //     ]
  //   },
  //   'Institut Teknologi Bandung': {
  //     'Fakultas Teknik': [
  //       'Teknik Sipil',
  //       'Teknik Informatika',
  //       'Teknik Industri'
  //     ],
  //     'Fakultas Seni Rupa': ['Desain Komunikasi Visual', 'Desain Interior'],
  //     'Fakultas Bisnis': ['Mangement Bisnis', 'Bisnis Teknologi']
  //   },
  //   'Universitas Gadjah Mada': {
  //     'Fakultas Kedokteran': ['Kedokteran Umum', 'Kedokteran Gigi'],
  //     'Fakultas Pertanian': ['Agronomi', 'Agroteknologi'],
  //     'Falultas keanimean': ['Cosplay', 'Bahasa Jepang', 'Isekai Sains']
  //   },
  //   'Politeknik Negeri Bandung': {
  //     'Fakultas Teknik': [
  //       'Teknik Sipil',
  //       'Teknik Informatika',
  //       'Teknik Industri'
  //     ],
  //     'Fakultas Seni Rupa': [
  //       'Desain Komunikasi Visual',
  //     ],
  //   },
  // };

  // List<String> getDepartments() {
  //   if (widget.selectedUniversity == null) {
  //     return [];
  //   }
  //   return universities[widget.selectedUniversity]!.keys.toList();
  // }

  // List<String> getStudyPrograms() {
  //   if (widget.selectedUniversity == null || selectedDepartment == null) {
  //     return [];
  //   }
  //   return universities[widget.selectedUniversity]![selectedDepartment]!;
  // }

  @override
  void initState() {
    super.initState();
    log({
      "email": widget.email,
      "name": widget.name,
      "campusName": widget.selectedUniversity,
      "campusId": widget.campusId,
    }.toString());
    fetchData();

    // if (selectedMajorId != null || selectedMajorId != 0) {
    //   fetchStudyProgramItems();
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchData() async {
    MajorListReponse majorListItems =
        await RegisterRepository().getDataMajorList(campusId: widget.campusId);

    majorItems = majorListItems.data!;
  }

  Future<void> fetchStudyProgramItems() async {
    if (studyProgramItems.isNotEmpty) {
      studyProgramItems.clear();
    }

    StudyProgramListReponse studyProgramListReponse = await RegisterRepository()
        .getStudyProgramList(majorId: selectedMajorId);

    studyProgramItems = studyProgramListReponse.data!;
  }

  Future<bool> checkNIM(BuildContext? context, {int? nim}) async {
    setState(() {
      loadButton = true;
    });
    CheckNimResponse response =
        await RegisterRepository().checkPostNIM(context, nim: nim!);

    DataCheckNim dataNim = response.data!;
    setState(() {
      loadButton = false;
    });
    log('data nim availalble is : ${dataNim.available}');
    return dataNim.available!;
  }

  void _majorItenmsFilter() {
    String query = majorController.text.toLowerCase();
    log('Query: $query');
    log('not filter data : $majorItems');
    if (query.isNotEmpty) {
      List<DataMajorItem> filteredList = majorItems.where((campus) {
        return campus.majorName!.toLowerCase().contains(query);
      }).toList();

      filteredList.sort((a, b) {
        int indexA = a.majorName!.toLowerCase().indexOf(query);
        int indexB = b.majorName!.toLowerCase().indexOf(query);
        return indexA.compareTo(indexB);
      });

      setState(() {
        _filteredMajorList = filteredList.cast<DataMajorItem>();
        _showMajorSuggestion = true;
      });
      log('Filtered List: $_filteredMajorList');
    } else {
      setState(() {
        _filteredMajorList = [];
        _showMajorSuggestion = false;
      });
      log('Filtered List cleared');
    }
  }

  void _departementItenmsFilter() {
    String query = departementController.text.toLowerCase();
    log('Query: $query');
    if (query.isNotEmpty) {
      List<DataStudyProgram> filteredList = studyProgramItems.where((campus) {
        return campus.programName!.toLowerCase().contains(query);
      }).toList();

      filteredList.sort((a, b) {
        int indexA = a.programName!.toLowerCase().indexOf(query);
        int indexB = b.programName!.toLowerCase().indexOf(query);
        return indexA.compareTo(indexB);
      });

      setState(() {
        _filteredDepartementList = filteredList.cast<DataStudyProgram>();
        _showDepartementSuggestion = true;
      });
      log('Filtered List: $_filteredDepartementList');
    } else {
      setState(() {
        _filteredDepartementList = [];
        _showDepartementSuggestion = false;
      });
      log('Filtered List cleared');
    }
  }

  void dataChecked(BuildContext context) {
    bool checked = true;
    String emptyField = '';
    setState(() {
      loadButton = true;
    });

    if (nimController.text.isEmpty) {
      setState(() {
        checked = false;
        loadButton = false;
        emptyField = 'NIM tidak boleh kosong';
      });
      showToast(emptyField);
    } else {
      checkNIM(
        context,
        nim: int.parse(nimController.text),
      ).then((nimAvailable) {
        if (nimAvailable == false) {
          setState(() {
            loadButton = false;
            checked = true;
          });
          log('and data nim availalble is : $nimAvailable');
          log('stay in signup student');
        } else {
          setState(() {
            loadButton = false;
            checked = false;
          });
          log('and data nim availalble is : $nimAvailable');
           log('go to create pass');
            navigateTo(
              context,
              CreatePasswordScreen(
                email: widget.email,
                name: widget.name,
                campusId: widget.campusId,
                nim: int.parse(nimController.text),
                addmissionYear: int.parse(admissionController.text),
                majorId: selectedMajorId,
                studyProgramId: selectedStudyProgramId,
                forgotPass: false,
                isStudent: true,
              ),
            );
        }
      });
    }

    if (admissionController.text.isEmpty) {
      setState(() {
        checked = false;
        loadButton = false;
        emptyField = 'Angkatan tidak boleh kosong';
      });
      showToast(emptyField);
    }

    if (majorController.text.isEmpty) {
      setState(() {
        checked = false;
        loadButton = false;
        emptyField = 'Jurusan tidak boleh kosong';
      });
      showToast(emptyField);
    }

    if (selectedMajorId == 0) {
      setState(() {
        checked = false;
        loadButton = false;
        emptyField = 'Pilih Jurusan';
      });
      showToast(emptyField);
    }

    if (departementController.text.isEmpty) {
      setState(() {
        checked = false;
        loadButton = false;
        emptyField = 'Program Studi tidak boleh kosong';
      });
      showToast(emptyField);
    }

    if (selectedStudyProgramId == 0) {
      setState(() {
        checked = false;
        loadButton = false;
        emptyField = 'Pilih Program Studi';
      });
      showToast(emptyField);
    }

  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: InkWell(
          onTap: () {
            setState(() {
              loadButton = false;
            });
          },
          child: const Text(
            'Informasi Mahasiswa',
            style: AppTextStyles.title,
          ),
        ),
        leadingWidth: 90,
        leading: IconButton(
          onPressed: () => navigateBack(context),
          icon: Icon(
            Icons.arrow_back,
            color: Warna.biru,
          ),
          padding: const EdgeInsets.all(10),
          style: IconButton.styleFrom(
              backgroundColor: Warna.abu, shape: const CircleBorder()),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            // NIM
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CTextField(
                keyboardType: TextInputType.number,
                controller: nimController,
                hintText: '231524028',
                labelText: 'NIM',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // ADMISSION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CTextField(
                keyboardType: TextInputType.number,
                controller: admissionController,
                hintText: '2023',
                labelText: 'Angkatan',
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // MAJOR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CTextField(
                controller: majorController,
                hintText: 'Teknik Komputer dan Informatika',
                labelText: 'Jurusan',
                onChanged: (p0) {
                  _majorItenmsFilter();
                },
                suffixIcon: IconButton(
                  icon: Icon(
                      _showMajorSuggestion && majorController.text.isNotEmpty
                          ? Icons.arrow_drop_down_rounded
                          : Icons.arrow_left_rounded),
                  onPressed: () {
                    log(majorController.text);
                    log(widget.selectedUniversity!);
                    // print("not filter : " + _major.toString());
                    log("filtered : $_filteredMajorList");
                    setState(() {
                      _showMajorSuggestion = !_showMajorSuggestion;
                    });
                  },
                ),
              ),
            ),
            if (_showMajorSuggestion && majorController.text.isNotEmpty)
              majorSelection(),

            const SizedBox(
              height: 20,
            ),

            // DEPARTEMENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CTextField(
                controller: departementController,
                hintText: 'D4 Teknik Informatika',
                labelText: 'Program Studi',
                onChanged: (p0) {
                  _departementItenmsFilter();
                },
                suffixIcon: IconButton(
                  icon: Icon(_showDepartementSuggestion &&
                          departementController.text.isNotEmpty
                      ? Icons.arrow_drop_down_rounded
                      : Icons.arrow_left_rounded),
                  onPressed: () {
                    log(departementController.text);
                    // print("not filter : " + _campusList.toString());
                    log("filtered : $_filteredMajorList");
                    setState(() {
                      _showDepartementSuggestion = !_showDepartementSuggestion;
                    });
                  },
                ),
              ),
            ),
            if (_showDepartementSuggestion &&
                departementController.text.isNotEmpty)
              departementSelection(),

            const SizedBox(
              height: 40,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CBlueButton(
                isLoading: loadButton,
                onPressed: () {
                  dataChecked(context);

                  // if (dataChecked(context)) {
                  //   log('go to create password');
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) =>
                  //       ));

                  // } else {
                  //   setState(() {
                  //     loadButton = false;
                  //   });
                  // }
                },
                text: 'Lanjut',
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget majorSelection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _filteredMajorList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_filteredMajorList[index].majorName!),
            onTap: () {
              setState(() {
                majorController.text = _filteredMajorList[index].majorName!;
                selectedMajor = majorController.text;
                selectedMajorId = _filteredMajorList[index].id!;
                _showMajorSuggestion = false;

                departementController.text = "";
                selectedDepartment = "";
                selectedStudyProgramId = null;
              });
              fetchStudyProgramItems();
            },
          );
        },
      ),
    );
  }

  Widget departementSelection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _filteredDepartementList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_filteredDepartementList[index].programName!),
            onTap: () {
              setState(() {
                departementController.text =
                    _filteredDepartementList[index].programName!;
                selectedDepartment = departementController.text;
                selectedStudyProgramId = _filteredDepartementList[index].id!;
                _showDepartementSuggestion = false;
              });
            },
          );
        },
      ),
    );
  }
}
