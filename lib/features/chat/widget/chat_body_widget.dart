import 'package:cached_network_image/cached_network_image.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:citizen_app/features/chat/page/chat_page.dart';
import 'package:flutter/material.dart';

class ChatBodyWidget extends StatelessWidget {
  final List<User> users;

  const ChatBodyWidget({
    @required this.users,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: buildChats(),
        ),
      );

  Widget buildChats() => ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final user = users[index];

          return Container(
            height: 75,
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatPage(user: user),
                ));
              },
              leading: ClipOval(
                child: Container(
                  width: 45.0,
                  height: 45.0,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: user.urlAvatar,
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(strokeWidth: 2.0),
                    height: 15,
                    width: 15,
                    errorWidget: (context, url, error) => Image.asset(
                      ICONS_ASSETS + 'default-avatar.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ),
              title: Text(user.name),
            ),
          );
        },
        itemCount: users.length,
      );
}
