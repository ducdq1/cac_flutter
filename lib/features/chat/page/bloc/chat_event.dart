abstract class ChatEvent {}


class ChatSentEvent extends ChatEvent {
  final String workerId;
  final String processor;

  ChatSentEvent({this.workerId, this.processor});
}
