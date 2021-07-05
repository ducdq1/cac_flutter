import 'package:cached_network_image/cached_network_image.dart';
import 'package:citizen_app/core/functions/functions.dart';
import 'package:citizen_app/core/resources/strings.dart';
import 'package:citizen_app/features/chat/model/message.dart';
import 'package:citizen_app/features/chat/model/user.dart';

import 'package:citizen_app/features/customer/presentation/widgets/full_photo.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final bool isMe;
  final User toUser;
  final bool isLastMessage;

  const MessageWidget(
      {@required this.message,
      @required this.isMe,
      this.toUser,
      this.isLastMessage});

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
                                new CircularProgressIndicator(strokeWidth: 2.0),
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
            message.type == '1' ?
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              child: Container(
                width: 200.0,
                height: 200.0,
                child: InkWell(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Image.network(
                      message.message,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          width: 200.0,
                          height: 200.0,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null &&
                                  loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return Container(
                          width: 60.0,
                          child: Image.asset(
                            IMAGE_ASSETS_PATH + 'icon_none.png',
                            width: 60.0,
                            height: 60.0,
                            //fit: BoxFit.cover,
                          ),
                        );
                      },
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap:  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullPhoto(
                          url: message.message,
                        ),
                      ),
                    );
                  },
                ),
                //borderRadius: BorderRadius.all(Radius.circular(8.0)),
                //clipBehavior: Clip.hardEdge,
              ),
              //margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
            ) :
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              //width: 500,
               constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[100] : Theme.of(context).accentColor,
                borderRadius: isMe
                    ? borderRadius
                        .subtract(BorderRadius.only(bottomRight: radius))
                    : borderRadius
                        .subtract(BorderRadius.only(bottomLeft: radius)),
              ),
              child:  Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      message.message,
                      style: TextStyle(color: isMe ? Colors.black : Colors.white,fontSize: 16),
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        (!isMe && isLastMessage)
            ? Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  handleTime(message.createdAt.toString()),
                  style: TextStyle(color: Colors.grey, fontSize: 13,fontStyle: FontStyle.italic),
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
          Container(
            width: 500,
            child: Container(
              child: Text(
                message.message,
                style: TextStyle(color: isMe ? Colors.black : Colors.white,fontSize: 16),
                textAlign: isMe ? TextAlign.end : TextAlign.start,
                softWrap: true,
                //overflow: E,
              ),
            ),
          ),
        ],
      );
}
