import 'package:citizen_app/features/chat/api/firebase_api.dart';
import 'package:citizen_app/features/chat/model/message.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:citizen_app/features/chat/widget/message_widget.dart';
import 'package:flutter/material.dart';

import '../data.dart';
import 'package:citizen_app/core/resources/api.dart';
class MessagesWidget extends StatelessWidget {
  final String chatsId;
  final User toUser;
  final User fromUser;

  const MessagesWidget({
    @required this.chatsId,
    this.toUser,
    this.fromUser,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Message>>(
        stream: FirebaseApi.getMessages(chatsId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText('Không thể kết nối. Vui lòng thử lại sau');
              } else {
                final messages = snapshot.data;

                return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: messages.isEmpty
                        ? buildText('Bạn chưa có tin nhắn nào với ' +
                            toUser.name +
                            '\n Bắt đầu trò chuyện nào')
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            reverse: true,
                            shrinkWrap: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              return MessageWidget(
                                message: message,
                                isMe: message.idUser == fromUser.idUser,
                                toUser: toUser,
                                isLastMessage: message.idUser == toUser.idUser
                                    ? isLastMessage(messages, index)
                                    : false,
                              );
                            },
                          ));
              }
          }
        },
      );

  bool isLastMessage(List<Message> messages, int index) {
    if (messages == null || messages.isEmpty) {
      return false;
    }

    // for (int i = 0; i < messages.length; i++) {
    //   if (messages[i].idUser == toUser.idUser) {
    //     if(index == i){
    //       return true;
    //     }
    //     break;
    //   }
    // }

    if(index==0 || messages[index-1].idUser != toUser.idUser){
      return true;
    }

    return false;
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.blue),
        ),
      );
}
