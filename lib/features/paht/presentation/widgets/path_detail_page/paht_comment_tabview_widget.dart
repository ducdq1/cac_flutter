import 'package:citizen_app/app_localizations.dart';
import 'package:citizen_app/core/functions/trans.dart';
import 'package:citizen_app/core/resources/colors.dart';
import 'package:citizen_app/core/resources/font_sizes.dart';
import 'package:citizen_app/core/resources/resources.dart';
import 'package:citizen_app/features/paht/presentation/bloc/comment_bloc/comment_bloc.dart';
import 'package:citizen_app/features/paht/presentation/bloc/comment_bloc/comment_event.dart';
import 'package:citizen_app/features/paht/presentation/bloc/comment_bloc/comment_state.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/paht_comment_widgets/comment_widget.dart';
import 'package:citizen_app/features/paht/presentation/widgets/path_detail_page/skeletons_widget.dart/skeleton_detailed_comment_path_widget.dart';
import 'package:citizen_app/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:citizen_app/features/common/widgets/widgets.dart';

import 'package:flutter_svg/flutter_svg.dart';

class PahtCommentTabViewWidget extends StatefulWidget {
  final String issueId;

  PahtCommentTabViewWidget({this.issueId});

  @override
  _PahtCommentTabViewWidgetState createState() =>
      _PahtCommentTabViewWidgetState();
}

class _PahtCommentTabViewWidgetState extends State<PahtCommentTabViewWidget> {
  TextEditingController _commentController = TextEditingController();
  FocusNode _commentFocusNode = FocusNode();
  GlobalKey<FormState> _formKey;
  bool _isShowClearContent = false;
  ScrollController _scrollController = ScrollController();
  String comment = '';
  String phoneNumber = '';
  int commentId = 0;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentBloc>(
        create: (context) => singleton<CommentBloc>()
          ..add(CommentFetchingEvent(
              pahtId: widget.issueId ??
                  'issue-report:5fcef2ba-dc39-4da6-9f83-ceb9e431ad2c')),
        child: Stack(children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder<CommentBloc, CommentState>(
              builder: (context, state) {
                if (state is CommentFetchedState) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 80),
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification:
                          (OverscrollIndicatorNotification overscroll) {
                        overscroll.disallowGlow();
                        return false;
                      },
                      child: state.comments.isNotEmpty
                          ? ListView.builder(
                              itemBuilder: (_, index) {
                                return CommentWidget(
                                  comment: state.comments[index],
                                  onReply: () {
                                    setState(() {
                                      comment = state.comments[index].content;
                                      phoneNumber =
                                          state.comments[index].phoneNumber;
                                      commentId = state.comments[index].id;
                                    });
                                  },
                                );
                              },
                              itemCount: state.comments.length,
                              controller: _scrollController,
                            )
                          : Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.add_comment,
                                    color: Colors.grey.withOpacity(0.27),
                                    size: 100,
                                  ),
                                  Text(trans(NO_COMMENT),
                                      style: GoogleFonts.inter(
                                        fontSize: FONT_EX_SMALL,
                                        color: SECONDARY_TEXT_COLOR,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(trans(FIRST_COMMENT),
                                      style: GoogleFonts.inter(
                                        fontSize: FONT_SMALL - 2,
                                        color: SECONDARY_TEXT_COLOR
                                            .withOpacity(0.5),
                                        fontWeight: FontWeight.bold,
                                      ))
                                ],
                              ),
                            ),
                    ),
                  );
                } else {
                  return SkeletonDetailedCommentPahtWidget();
                }
              },
            ),
          ),
          BlocBuilder<CommentBloc, CommentState>(builder: (context, state) {
            return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                        color: Colors.grey[100],
                      )),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                    height: comment != '' ? 100 : 80,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        comment != ''
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        trans(REPLY_TO),
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: FONT_SMALL,
                                          color: PRIMARY_TEXT_COLOR,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        comment.length <= 21
                                            ? comment
                                            : comment.substring(0, 20) + '...',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontSize: FONT_EX_SMALL,
                                          color: PRIMARY_TEXT_COLOR,
                                        ),
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    child: Text(
                                      trans(CANCEL),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: PRIMARY_TEXT_COLOR,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        comment = '';
                                        phoneNumber = '';
                                        commentId = 0;
                                      });
                                    },
                                  )
                                ],
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        Form(
                            key: _formKey,
                            child: Stack(children: [
                              TextFieldWidget(
                                hintText: trans(INPUT_CONTENT_COMMENT),
                                isShowSuffixIcon:
                                    _commentController.text.isNotEmpty
                                        ? _isShowClearContent
                                            ? true
                                            : false
                                        : false,
                                onChange: (value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      _isShowClearContent = false;
                                    });
                                  }
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      _isShowClearContent = true;
                                    });
                                  }
                                },
                                onTap: () {
                                  if (_commentController.text.isNotEmpty) {
                                    setState(() {
                                      _isShowClearContent = true;
                                    });
                                  }
                                },
                                color: Colors.white,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return trans(
                                        ERROR_VALIDATE_EMPTY_PASSWORD_LOGIN);
                                  } else
                                    return null;
                                },
                                onFieldSubmitted: (v) {
                                  _commentFocusNode.unfocus();
                                  setState(() {
                                    if (_commentController.text.isEmpty) {
                                      _isShowClearContent = false;
                                    }
                                    _isShowClearContent = false;
                                  });
                                },
                                focusNode: _commentFocusNode,
                                isDone: true,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 40),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isShowClearContent = false;
                                        });
                                        _commentController.clear();
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        child: SvgPicture.asset(
                                          SVG_ASSETS_PATH + 'icon_clear.svg',
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                controller: _commentController,
                                textInputType: TextInputType.text,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    if (_commentController.text.isNotEmpty) {
                                      _commentFocusNode.unfocus();
                                      if (comment == '') {
                                        BlocProvider.of<CommentBloc>(context)
                                            .add(CommentSentEvent(
                                                content:
                                                    _commentController.text,
                                                pahtId: widget.issueId));
                                      } else {
                                        BlocProvider.of<CommentBloc>(context)
                                            .add(CommentRepliedEvent(
                                                content:
                                                    _commentController.text,
                                                pahtId: widget.issueId,
                                                commentId: commentId));
                                      }
                                      _commentController.clear();
                                      if (state is CommentFetchedState) {
                                        _scrollController.animateTo(
                                            _scrollController
                                                .position.maxScrollExtent,
                                            duration: _scrollController
                                                        .position.pixels <
                                                    1000
                                                ? Duration(milliseconds: 5000)
                                                : Duration(milliseconds: 1000),
                                            curve: Curves.fastOutSlowIn);
                                      }
                                    }
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    size: 32,
                                    color: _commentController.text.isNotEmpty
                                        ? PRIMARY_COLOR
                                        : Colors.grey,
                                  ),
                                ),
                              )
                            ])),
                      ],
                    )));
          })
        ]));
  }
}
