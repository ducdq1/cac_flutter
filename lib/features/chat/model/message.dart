import 'package:flutter/material.dart';

import '../utils.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  final String idUser;
  final String urlAvatar;
  final String username;
  final String message;
  final DateTime createdAt;
  final String type;
  const Message({
    @required this.idUser,
    @required this.urlAvatar,
    @required this.username,
    @required this.message,
    @required this.createdAt,
    @required this.type
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
        idUser: json['idUser'],
        urlAvatar: json['urlAvatar'],
        username: json['username'],
        message: json['message'],
        type: json['type'],
        createdAt: Utils.toDateTime(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'urlAvatar': urlAvatar,
        'username': username,
        'message': message,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
    'type':type
      };
}
