import 'package:cached_network_image/cached_network_image.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/chat/model/message.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;
  final User toUser;

  const MessageWidget(
      {@required this.message, @required this.isMe, this.toUser});

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        !isMe
            ? Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: ClipOval(
                  child: Container(
                    width: 24.0,
                    height: 24.0,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: toUser.urlAvatar,
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(strokeWidth: 2.0),
                      height: 24,
                      width: 24,
                      errorWidget: (context, url, error) => Image.asset(
                        ICONS_ASSETS + 'default-avatar.png',
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 140),
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[100] : Theme.of(context).accentColor,
            borderRadius: isMe
                ? borderRadius.subtract(BorderRadius.only(bottomRight: radius))
                : borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
          ),
          child: buildMessage(),
        ),
      ],
    );
  }

  Widget buildMessage() => Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.message,
            style: TextStyle(color: isMe ? Colors.black : Colors.white),
            textAlign: isMe ? TextAlign.end : TextAlign.start,
          ),
        ],
      );
}
