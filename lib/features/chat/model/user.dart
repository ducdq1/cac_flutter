import 'package:meta/meta.dart';

import '../utils.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
  static final String ROLE_MESSAGE = 'ROLE_MESSAGE';
}

class User {
  final String idUser;
  final String name;
  final String phone;
  final String role;
  final String urlAvatar;
  final DateTime lastMessageTime;
  final String status;
  final DateTime lastOnlineTime;
  final String processor;
  final bool messageHasRead;
  const User({
    this.idUser,
    @required this.name,
    @required this.urlAvatar,
    this.role,
    this.phone,
    this.lastMessageTime,
    this.lastOnlineTime,
    this.status,
    this.processor,
    this.messageHasRead
  });

  User copyWith({
    String idUser,
    String name,
    String urlAvatar,
    String phone,
    String role,
    DateTime lastMessageTime,
    String status,
    DateTime lastOnlineTime,
    String processor,
    bool messageHasRead
  }) =>
      User(
        idUser: idUser ?? this.idUser,
        name: name ?? this.name,
        urlAvatar: urlAvatar ?? this.urlAvatar,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
        role: this.role,
        phone: this.phone,
        status: this.status,
        processor : this.processor
      );

  static User fromJson(Map<String, dynamic> json) => User(
        idUser: json['idUser'],
        name: json['name'],
        urlAvatar: json['urlAvatar'],
        phone: json['phone'],
        role: json['role'],
        lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
         status: json['status'],
         lastOnlineTime:  Utils.toDateTime(json['lastOnlineTime']),
        processor: json['processor'],
        messageHasRead : json['messageHasRead']
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'name': name,
        'urlAvatar': urlAvatar,
        'phone' : phone,
        'role' : role,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
    'status' : status,
    'lastOnlineTime':  Utils.fromDateTimeToJson(lastOnlineTime),
    'processor': processor,
    'messageHasRead' : messageHasRead
      };
}
