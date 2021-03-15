abstract class CommentEvent {}

class CommentFetchingEvent extends CommentEvent {
  final String pahtId;

  CommentFetchingEvent({this.pahtId});
}

class CommentSentEvent extends CommentEvent {
  final String pahtId;
  final String content;

  CommentSentEvent({this.pahtId, this.content});
}

class CommentRepliedEvent extends CommentEvent {
  final String pahtId;
  final String content;
  final int commentId;

  CommentRepliedEvent({this.pahtId, this.content, this.commentId});
}
