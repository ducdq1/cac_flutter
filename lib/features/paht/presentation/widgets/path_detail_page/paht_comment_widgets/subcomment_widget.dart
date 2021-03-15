import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/paht/domain/entities/comment_entity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:citizen_app/core/functions/handle_time.dart';

class SubCommentWidget extends StatefulWidget {
  final CommentEntity comment;

  SubCommentWidget({this.comment});

  @override
  _SubCommentWidgetState createState() => _SubCommentWidgetState();
}

class _SubCommentWidgetState extends State<SubCommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15, top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage(
              'https://images.pexels.com/photos/3323163/pexels-photo-3323163.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: widget.comment.phoneNumber == null
                        ? 'xxxxxxxxx'
                        : widget.comment.phoneNumber.substring(
                                0, widget.comment.phoneNumber.length - 3) +
                            'xxx',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: FONT_MIDDLE,
                      color: PRIMARY_TEXT_COLOR,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' ${widget.comment.content}',
                        style: GoogleFonts.inter(
                          color: PRIMARY_TEXT_COLOR,
                          fontSize: FONT_MIDDLE,
                          fontWeight: FontWeight.normal,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  handleTime(widget.comment.createdAt),
                  style: GoogleFonts.inter(
                    color: SECONDARY_TEXT_COLOR,
                    fontSize: FONT_SMALL,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
