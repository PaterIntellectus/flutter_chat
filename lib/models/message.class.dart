import 'package:uuid/uuid.dart';

class Message {
  final String id = const Uuid().v4();
  DateTime date = DateTime.now();
  MessageStatus status = MessageStatus.pending;
  String userId;
  String text;
  String? attachment;

  Message(this.userId, this.text, this.date,
      {this.attachment, this.status = MessageStatus.pending});
  Message.empty()
      : userId = '0',
        text = '';
  Message.newMessage(this.userId, this.text, this.attachment);
}

enum MessageStatus {
  pending,
  sent,
  read,
}
