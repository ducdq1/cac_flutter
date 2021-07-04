import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/features/chat/api/firebase_api.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:citizen_app/features/chat/widget/messages_widget.dart';
import 'package:citizen_app/features/chat/widget/new_message_widget.dart';
import 'package:citizen_app/features/chat/widget/profile_header_widget.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final User user;

  const ChatPage({
    @required this.user,
    Key key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String myId;
  User myUser;

  @override
  void initState() {
    super.initState();
  }

  Future<User> initFirebaseData() async {
    print('----------------1');
    myUser = await FirebaseApi.getMyUser();
    return myUser;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: FutureBuilder<User>(
              future: initFirebaseData(),
              builder: (context, snap) {
                if (snap.hasData) {
                  return Column(
                    children: [
                      ProfileHeaderWidget(
                        name: widget.user.name,
                        user: widget.user,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: MessagesWidget(
                              chatsId: widget.user.idUser,
                              toUser: widget.user,
                              fromUser: myUser),
                        ),
                      ),
                      NewMessageWidget(
                          idUser: widget.user.idUser, myUser: myUser,toUser: widget.user),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      );
}
