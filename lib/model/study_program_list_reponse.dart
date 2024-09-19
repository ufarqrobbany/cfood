import 'dart:convert';

StudyProgramListReponse studyProgramListReponseFromJson(String str) => StudyProgramListReponse.fromJson(json.decode(str));

String studyProgramListReponseToJson(StudyProgramListReponse data) => json.encode(data.toJson());

class StudyProgramListReponse {
  int? statusCode;
  String? status;
  String? message;
  List<DataStudyProgram>? data;

  StudyProgramListReponse(
      {this.statusCode, this.status, this.message, this.data});

  StudyProgramListReponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataStudyProgram>[];
      json['data'].forEach((v) {
        data!.add(DataStudyProgram.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataStudyProgram {
  int? id;
  String? programName;

  DataStudyProgram({this.id, this.programName});

  DataStudyProgram.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    programName = json['programName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['programName'] = programName;
    return data;
  }
}
