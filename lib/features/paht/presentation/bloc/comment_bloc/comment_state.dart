import 'package:citizen_app/features/paht/data/models/comment_model.dart';

abstract class CommentState {}

class CommentInitState extends CommentState {}

class CommentFetchedState extends CommentState {
  final List<CommentModel> comments;
  CommentFetchedState({this.comments});
}

class CommentFetchFaildState extends CommentState {
  final String message;
  CommentFetchFaildState({this.message});
}

class CommentSentSuccessState extends CommentState {
  final String content;

  CommentSentSuccessState({this.content});

  @override
  String toString() => 'CommentSentSuccessState';
}

class CommentSentFailedState extends CommentState {
  final dynamic error;

  CommentSentFailedState({this.error});
  @override
  String toString() => 'CommentSentFailedState';
}

class CommentSentLoadingState extends CommentState {
  @override
  String toString() => 'CommentSentLoadingState';
}
