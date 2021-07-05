import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/features/chat/api/firebase_api.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:citizen_app/features/chat/widget/chat_body_widget.dart';
import 'package:citizen_app/features/chat/widget/chat_header_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/paht_page/skeleton_paht_list_widget.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(color: PRIMARY_COLOR,
              child: ChatHeaderWidget(users: [])),
              StreamBuilder<List<User>>(
                  stream: FirebaseApi.getUsers(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Container(height:400,child: Center(child: CircularProgressIndicator()));
                      default:
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return buildText('Something Went Wrong Try later');
                        } else {
                          final users = snapshot.data;

                          if (users.isEmpty) {
                            return buildText('No Users Found');
                          }
                        return ChatBodyWidget(users: users);
                        }
                    }
                  }),
            ],
          ),
        ),
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      );
}
