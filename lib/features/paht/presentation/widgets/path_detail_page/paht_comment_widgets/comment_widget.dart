import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/paht/domain/entities/comment_entity.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/paht_comment_widgets/subcomment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:citizen_app/core/functions/handle_time.dart';

class CommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final Function onReply;
  CommentWidget({@required this.comment, @required this.onReply});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15, top: 5),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0xffB9B9B9), width: 0.3))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey,
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
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            SVG_ASSETS_PATH + 'icon_reply.svg',
                          ),
                          SizedBox(width: 7),
                          Text(
                            trans(ACT_REPLY),
                            style: GoogleFonts.inter(
                              color: SECONDARY_TEXT_COLOR,
                              fontSize: FONT_MIDDLE,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                      onTap: widget.onReply,
                    )
                  ],
                ),
                widget.comment?.children != null
                    ? Container(
                        // margin: EdgeInsets.only(top: 21),
                        child: Column(
                          children: widget.comment.children
                              .map(
                                  (subcmt) => SubCommentWidget(comment: subcmt))
                              .toList(),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
