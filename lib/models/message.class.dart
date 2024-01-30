import 'package:uuid/uuid.dart';

class Message {
  final String id = const Uuid().v4();
  DateTime date = DateTime.now();
  final String userId;
  String message;

  Message(this.userId, this.message);
  Message.withDate(this.userId, this.message, this.date);
}
