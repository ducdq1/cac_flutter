import 'package:citizen_app/features/paht/data/models/comment_model.dart';

abstract class ChatState {}

class ChatInitState extends ChatState {}

class ChatSentSuccessState extends ChatState {
  final String content;

  ChatSentSuccessState({this.content});

  @override
  String toString() => 'ChatSentSuccessState';
}

class ChatSentFailedState extends ChatState {
  final dynamic error;

  ChatSentFailedState({this.error});
  @override
  String toString() => 'ChatSentFailedState';
}