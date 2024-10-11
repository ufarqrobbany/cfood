class GetChatRoomResponse {
  int? statusCode;
  String? status;
  String? message;
  DataRoom? data;

  GetChatRoomResponse({this.statusCode, this.status, this.message, this.data});

  GetChatRoomResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DataRoom.fromJson(json['data']) : null;
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

class DataRoom {
  String? type;
  List<Rooms>? rooms;

  DataRoom({this.type, this.rooms});

  DataRoom.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['rooms'] != null) {
      rooms = <Rooms>[];
      json['rooms'].forEach((v) {
        rooms!.add(new Rooms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.rooms != null) {
      data['rooms'] = this.rooms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Rooms {
  String? roomId;
  String? name;
  String? photo;
  int? unreadMessages;
  String? latestChatMessage;
  String? latestUpdated;
  String? latestSenderType;

  Rooms(
      {this.roomId,
      this.name,
      this.photo,
      this.unreadMessages,
      this.latestChatMessage,
      this.latestUpdated,
      this.latestSenderType});

  Rooms.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    name = json['name'];
    photo = json['photo'];
    unreadMessages = json['unreadMessages'];
    latestChatMessage = json['latestChatMessage'];
    latestUpdated = json['latestUpdated'];
    latestSenderType = json['latestSenderType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['unreadMessages'] = this.unreadMessages;
    data['latestChatMessage'] = this.latestChatMessage;
    data['latestUpdated'] = this.latestUpdated;
    data['latestSenderType'] = this.latestSenderType;
    return data;
  }
}
