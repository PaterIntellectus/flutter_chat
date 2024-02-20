import 'package:flutter/material.dart';
import 'package:flutter_messenger/models/message.class.dart';
import 'package:intl/intl.dart' as intl;

class MessageGroup {
  final DateTime date;
  final String userId;
  final Separator separator;
  List<Message> messages = [];

  MessageGroup(this.userId, this.date, this.separator);

  int get countMessages {
    return messages.length;
  }

  void addMessage(Message message) {
    if (canAdd(message)) {
      messages.add(message);
    } else {
      throw Exception(
        "Can't add the message to the group:\n"
        "Wrong message date = '${message.userId}'",
      );
    }
  }

  bool canAdd(Message message) {
    return switch (separator) {
      Separator.date => dateIsEqual(message),
      Separator.userId => userIdIsEqual(message),
    };
  }

  bool dateIsEqual(Message message) {
    return createDateString(message.date) == createDateString(date);
  }

  void debugShow() {
    debugPrint("MessageGroup: $date");
    for (var message in messages) {
      debugPrint(message.id);
    }
  }

  bool userIdIsEqual(Message message) {
    return message.userId == userId;
  }

  static String createDateString(DateTime date) {
    return intl.DateFormat("dd.MM.yy").format(date);
  }

  static List<MessageGroup> separateMessages(
    List<Message> messages,
    final Separator separator,
  ) {
    if (messages.isEmpty) {
      return [];
    }

    List<MessageGroup> messageGroupList = [];

    var messageGroup = MessageGroup(
      messages.elementAt(0).userId,
      messages.elementAt(0).date,
      separator,
    );

    for (Message message in messages) {
      if (!messageGroup.canAdd(message)) {
        messageGroupList.add(messageGroup);
        messageGroup = MessageGroup(
          message.userId,
          message.date,
          separator,
        );
      }
      messageGroup.addMessage(message);
    }
    messageGroupList.add(messageGroup);

    return messageGroupList;
  }
}

enum Separator { date, userId }
