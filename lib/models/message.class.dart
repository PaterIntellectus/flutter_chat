import 'package:uuid/uuid.dart';

class Message {
  final String id = const Uuid().v4();
  DateTime date = DateTime.now();
  String userId;
  String message;
  MessageStatus status = MessageStatus.pending;

  Message(this.userId, this.message);
  Message.empty()
      : userId = '0',
        message = '';
  Message.withDate(this.userId, this.message, this.date);
}

enum MessageStatus {
  pending,
  sent,
  read,
}
