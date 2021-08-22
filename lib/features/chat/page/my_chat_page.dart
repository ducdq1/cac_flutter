import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/features/chat/api/firebase_api.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:citizen_app/features/chat/widget/messages_widget.dart';
import 'package:citizen_app/features/chat/widget/new_message_widget.dart';
import 'package:citizen_app/features/chat/widget/profile_header_widget.dart';
import 'package:flutter/material.dart';

class MyChatPage extends StatefulWidget {
  const MyChatPage({
    Key key,
  }) : super(key: key);

  @override
  _MyChatPageState createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  String myId;
  User myUser;
  User toUser;

  @override
  void initState() {
    super.initState();
  }

  Future<User> initFirebaseData() async {
    if(myUser !=null){
      return myUser;
    }
   var tempMyUser = await FirebaseApi.getMyUser();
   var tempToUser = await FirebaseApi.getAdminUser();
   if(tempMyUser !=null) {
     setState(() {
       myUser = tempMyUser;
       toUser = tempToUser;
     });
   }
    return tempMyUser;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 260,
      child: FutureBuilder<User>(
        future: initFirebaseData(),
        builder: (_, snap) {
          if (snap.hasData) {
            return Column(
              children: [
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
                        chatsId: myUser.idUser,
                        toUser: toUser,
                        fromUser: myUser),
                  ),
                ),
                NewMessageWidget(idUser: myUser.idUser, myUser: myUser,toUser: toUser),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
