import 'package:flutter_messenger/models/message.class.dart';
import 'package:uuid/uuid.dart';

class Chat {
  final id = const Uuid().v4();
  List<String> userIds;
  List<Message> messages;

  Chat(this.userIds, this.messages);

  bool isEmpty() {
    return messages.isEmpty || userIds.isEmpty;
  }
}
