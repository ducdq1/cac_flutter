import 'package:flutter/material.dart';

import '../utils.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  final String idMsg;
  final String idUser;
  final String urlAvatar;
  final String username;
  final String message;
  final DateTime createdAt;
  final String type;
  final bool hasRead;
  const Message({
    this.idMsg,
    @required this.idUser,
    @required this.urlAvatar,
    @required this.username,
    @required this.message,
    @required this.createdAt,
    @required this.type,
    this.hasRead
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
        idMsg: json['idMsg'],
        idUser: json['idUser'],
        urlAvatar: json['urlAvatar'],
        username: json['username'],
        message: json['message'],
        type: json['type'],
        hasRead: json['hasRead'],
        createdAt: Utils.toDateTime(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'idMsg' : idMsg,
        'idUser': idUser,
        'urlAvatar': urlAvatar,
        'username': username,
        'message': message,
        'hasRead' : hasRead,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
        'type':type
      };
}
