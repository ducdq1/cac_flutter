import 'package:cached_network_image/cached_network_image.dart';
import 'package:citizen_app/core/functions/functions.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/chat/model/message.dart';
import 'package:citizen_app/features/chat/model/user.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;
  final User toUser;
  final bool isLastMessage;
  const MessageWidget(
      {@required this.message, @required this.isMe, this.toUser,this.isLastMessage});

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            !isMe
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        //color: const Color(0xff7c94b6),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(80)),
                        border: new Border.all(
                          color: Color(0xff7c94b6),
                          width: toUser.urlAvatar == null ? 1.0 : 0,
                        ),
                      ),
                      child: ClipOval(
                        child: Container(
                          width: 28.0,
                          height: 28.0,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: toUser.urlAvatar,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(
                                    strokeWidth: 2.0),
                            height: 24,
                            width: 24,
                            errorWidget: (context, url, error) => Image.asset(
                              ICONS_ASSETS + 'default-avatar.png',
                              height: 28,
                              width: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(5),
              constraints: BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(
                color:
                    isMe ? Colors.grey[100] : Theme.of(context).accentColor,
                borderRadius: isMe
                    ? borderRadius
                        .subtract(BorderRadius.only(bottomRight: radius))
                    : borderRadius
                        .subtract(BorderRadius.only(bottomLeft: radius)),
              ),
              child: buildMessage(),
            ),
          ],
        ),
        (!isMe && isLastMessage)
            ? Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                  handleTime(message.createdAt.toString()),
                  style: TextStyle(color: Colors.grey,fontSize: 11),
                ),
            )
            : SizedBox(),
      ],
    );
  }

  Widget buildMessage() => Column(
        mainAxisSize: MainAxisSize.min,
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
