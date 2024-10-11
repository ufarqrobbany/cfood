import 'dart:io';

class GetChatMessageResponse {
  int? statusCode;
  String? status;
  String? message;
  DataChat? data;

  GetChatMessageResponse(
      {this.statusCode, this.status, this.message, this.data});

  GetChatMessageResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DataChat.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataChat {
  int? roomId;
  int? merchantId;
  String? name;
  String? subName;
  String? photo;
  List<Messages>? messages;
  int? pages;

  DataChat(
      {this.roomId,
      this.merchantId,
      this.name,
      this.subName,
      this.photo,
      this.messages,
      this.pages});

  DataChat.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    merchantId = json['id'];
    name = json['name'];
    subName = json['subName'];
    photo = json['photo'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
    pages = json['pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['name'] = this.name;
    data['subName'] = this.subName;
    data['photo'] = this.photo;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    data['pages'] = this.pages;
    return data;
  }
}

class Messages {
  String? senderType;
  String? message;
  String? media;
  String? timestamp;
  File? mediaLocal;

  Messages({this.senderType, this.message, this.media, this.timestamp, this.mediaLocal});

  Messages.fromJson(Map<String, dynamic> json) {
    senderType = json['senderType'];
    message = json['message'];
    media = json['media'];
    timestamp = json['timestamp'];
    mediaLocal = json['mediaLocal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderType'] = this.senderType;
    data['message'] = this.message;
    data['media'] = this.media;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
