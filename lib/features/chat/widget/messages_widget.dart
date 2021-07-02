import 'package:citizen_app/features/chat/api/firebase_api.dart';
import 'package:citizen_app/features/chat/model/message.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:citizen_app/features/chat/widget/message_widget.dart';
import 'package:flutter/material.dart';

import '../data.dart';

class MessagesWidget extends StatelessWidget {
  final String idUser;
  final User toUser;
  final String myUserId;
  const MessagesWidget({
    @required this.idUser,
    this.toUser,
    this.myUserId,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Message>>(
        stream: FirebaseApi.getMessages(idUser),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText('Không thể kết nối. Vui lòng thử lại sau');
              } else {
                final messages = snapshot.data;

                return messages.isEmpty
                    ? buildText('Bạn chưa có tin nhắn nào với ' + toUser.name +'\n Bắt đầu trò chuyện nào')
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return MessageWidget(
                            message: message,
                            isMe: message.idUser == myUserId,
                            toUser: toUser,
                          );
                        },
                      );
              }
          }
        },
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16,color: Colors.blue),
        ),
      );
}
