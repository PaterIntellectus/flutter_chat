import 'package:flutter_messenger/models/message.class.dart';
import 'package:uuid/uuid.dart';

class Chat {
  final id = const Uuid().v4();
  List<String> userIds;
  List<Message> messages = [];

  Chat(this.userIds, this.messages);
  Chat.empty(this.userIds);

  bool get isEmpty {
    return messages.isEmpty;
  }

  int get length {
    return messages.length;
  }

  void addMessage(Message message) {
    messages.add(message);
  }

  Message getLastMessage() {
    return isEmpty ? Message.empty() : messages.last;
  }
}
