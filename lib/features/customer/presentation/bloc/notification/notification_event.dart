part of 'notification_bloc.dart';
abstract class BaseNotificationEvent{}

class NotificationEvent extends BaseNotificationEvent {
  final int value;
   NotificationEvent(this.value);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}


class LoginEvent extends BaseNotificationEvent {
  final String id;
   LoginEvent(this.id);
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
