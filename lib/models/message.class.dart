import 'package:uuid/uuid.dart';

class Message {
  final String id = const Uuid().v4();
  MessageStatus status = MessageStatus.pending;
  DateTime date;
  String userId;
  String? text;
  String? attachment;

  Message(
    this.userId,
    this.date, {
    this.text,
    this.attachment,
    this.status = MessageStatus.pending,
  });

  Message.empty()
      : userId = '0',
        date = DateTime.now();

  Message.newMessage(
    this.userId, {
    this.text,
    this.attachment,
  }) : date = DateTime.now();

  bool get hasAttachment {
    return attachment != null && attachment!.isNotEmpty;
  }

  bool get hasText {
    return length > 0;
  }

  bool get isEmpty {
    return !hasText && !hasAttachment;
  }

  int get length {
    return text == null ? 0 : text!.length;
  }
}

enum MessageStatus {
  pending,
  sent,
  read,
}
