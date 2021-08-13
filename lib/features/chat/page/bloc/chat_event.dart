abstract class ChatEvent {}


class ChatSentEvent extends ChatEvent {
  final int workerId;
  final String processor;

  ChatSentEvent({this.workerId, this.processor});
}
