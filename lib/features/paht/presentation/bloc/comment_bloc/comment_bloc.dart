import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:citizen_app/features/paht/domain/usecases/usecases.dart';

import 'package:flutter/material.dart';

import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final GetComments getComments;
  final CreateComment createComment;
  final ReplyComment replyComment;
  CommentBloc(
      {@required this.getComments,
      @required this.createComment,
      @required this.replyComment})
      : super(CommentInitState());

  @override
  Stream<CommentState> mapEventToState(
    CommentEvent event,
  ) async* {
    if (event is CommentFetchingEvent) {
      try {
        await Future.delayed(Duration(milliseconds: 200));
        final comments =
            await getComments.call(CommentParams(pahtId: event.pahtId));
        yield CommentFetchedState(comments: comments);
      } catch (error) {
        yield CommentFetchFaildState(message: error.message.toString());
      }
    }
    if (event is CommentSentEvent) {
      try {
        await Future.delayed(Duration(milliseconds: 200));

        print(event.content);
        await createComment.call(Params(
          issueId: event.pahtId,
          content: event.content,
        ));

        final comments =
            await getComments.call(CommentParams(pahtId: event.pahtId));
        yield CommentSentSuccessState();
        yield CommentFetchedState(comments: comments);
      } catch (error) {
        yield CommentSentFailedState(error: error.message);
      }
    }
    if (event is CommentRepliedEvent) {
      try {
        await Future.delayed(
          Duration(milliseconds: 200),
        );
        await replyComment.call(
          Params(
              issueId: event.pahtId,
              content: event.content,
              commentId: event.commentId),
        );

        final comments = await getComments.call(
          CommentParams(pahtId: event.pahtId),
        );
        yield CommentSentSuccessState();
        yield CommentFetchedState(comments: comments);
      } catch (error) {
        yield CommentSentFailedState(error: error.message);
      }
    }
  }
}
