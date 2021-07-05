import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/authentication/signin/presentation/signin_page.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:citizen_app/features/chat/page/chat_page.dart';
import 'package:citizen_app/features/common/dialogs/input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChatHeaderWidget extends StatelessWidget {
  final List<User> users;

  const ChatHeaderWidget({
    @required this.users,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              IconButton(
                icon: SvgPicture.asset(
                  SVG_ASSETS_PATH + 'icon_arrow_back.svg',
                  width: SIZE_ARROW_BACK_ICON,
                  height: SIZE_ARROW_BACK_ICON,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    'Nhắn tin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Row(
                  children: [
                    Text(
                      'Tất cả',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                onTap: () {
                  showInputDialog(
                      context: context,
                      title: "Gửi tin nhắn cho mọi người",
                      value: '',
                      submitTitle: 'Gửi tin nhắn',
                      onSubmit: (value) {
                        if (value != null) {

                        }
                      });
                },
              ),
            ]),
            //SizedBox(height: 12),
            1 == 1
                ? SizedBox()
                : Container(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        if (index == 0) {
                          return Container(
                            margin: EdgeInsets.only(right: 12),
                            child: CircleAvatar(
                              radius: 24,
                              child: Icon(Icons.search),
                            ),
                          );
                        } else {
                          return Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ChatPage(user: users[index]),
                                ));
                              },
                              child: CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(user.urlAvatar),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  )
          ],
        ),
      );
}
