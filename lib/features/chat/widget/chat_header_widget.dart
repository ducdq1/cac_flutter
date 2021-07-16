import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/authentication/signin/presentation/signin_page.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:citizen_app/features/chat/page/chat_page.dart';
import 'package:citizen_app/features/common/dialogs/input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:citizen_app/features/chat/api/firebase_api.dart';

class ChatHeaderWidget extends StatelessWidget {
  final List<User> users;

  const ChatHeaderWidget({
    @required this.users,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              Text(
                'Nhắn tin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
