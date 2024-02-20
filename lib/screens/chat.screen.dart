import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_messenger/flutter_chat_icons_icons.dart';
import 'package:flutter_messenger/main.dart';
import 'package:flutter_messenger/models/chat.class.dart';
import 'package:flutter_messenger/models/message.class.dart';
import 'package:flutter_messenger/models/message_group.class.dart';
import 'package:flutter_messenger/models/user.class.dart';
import 'package:flutter_messenger/widgets/chat_footer.widget.dart';
import 'package:flutter_messenger/widgets/message_box.widget.dart';
import 'package:flutter_messenger/widgets/standard_divider.widget.dart';
import 'package:flutter_messenger/widgets/time_difference.widget.dart';
import 'package:flutter_messenger/widgets/user_avatar.widget.dart';
import 'package:flutter_messenger/widgets/user_name.widget.dart';
import 'package:provider/provider.dart';

class ChatBar extends StatelessWidget implements PreferredSizeWidget {
  final User user;

  @override
  final Size preferredSize = const Size.fromHeight(62);

  const ChatBar({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: theme.colorScheme.background,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      backgroundColor: theme.colorScheme.background,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          FlutterChatIcons.arrow_left_s,
        ),
      ),
      title: Row(
        children: [
          UserAvatar(user: user),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserNameWidget(user: user),
              user.isOnline
                  ? Text(
                      'В сети',
                      style: TextStyle(
                        color: theme.colorScheme.onTertiary,
                        fontSize: 12,
                      ),
                    )
                  : TimeDifferenceWidget(dateTime: user.lastLogin),
            ],
          )
        ],
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(10.0),
        child: StandardDivider(),
      ),
    );
  }
}

class ChatDateDivider extends StatelessWidget {
  final DateTime date;

  const ChatDateDivider({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: StandardDivider(
            indent: 6,
            endIndent: 10,
          ),
        ),
        TimeDifferenceWidget(
          dateTime: date,
          formatType: FormatType.days,
          defaultText: 'Сегодня',
        ),
        const Expanded(
          child: StandardDivider(
            indent: 10,
            endIndent: 6,
          ),
        ),
      ],
    );
  }
}

class ChatScreen extends StatelessWidget {
  final User user;

  const ChatScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatBar(user: user),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: MessageList(
              userId: user.id,
            ),
          ),
          ChatFooter(
            user: user,
          ),
        ],
      ),
    );
  }
}

class GroupedMessages extends StatelessWidget {
  final List<Message> messages;

  const GroupedMessages({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    final first = messages.first;
    final last = messages.last;

    return switch (messages.length) {
      0 => const SizedBox.shrink(),
      1 => MessageBox(
          message: last,
        ),
      2 => Column(
          children: [
            MessageBox(
              message: first,
              messageBoxType: MessageBoxType.up,
            ),
            const SizedBox(
              height: 6,
            ),
            MessageBox(
              message: last,
              messageBoxType: MessageBoxType.bottom,
            )
          ],
        ),
      _ => Column(
          children: [
            MessageBox(
              message: first,
              messageBoxType: MessageBoxType.up,
            ),
            const SizedBox(
              height: 6,
            ),
            for (var i = 1; i < messages.length - 1; i++)
              Column(
                children: [
                  MessageBox(
                    message: messages.elementAt(i),
                    messageBoxType: MessageBoxType.middle,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                ],
              ),
            MessageBox(
              message: last,
              messageBoxType: MessageBoxType.bottom,
            ),
          ],
        ),
    };
  }
}

class MessageGroupedByUser extends StatelessWidget {
  final List<Message> messages;

  const MessageGroupedByUser({
    super.key,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    final messageGroupedByUser = MessageGroup.separateMessages(
      messages,
      Separator.userId,
    );

    // List<List<Message>> listOfGroupedMessages = [];
    // int start = 0;
    // String currentUserId = messages[0].userId;
    // for (int i = 1; i < messages.length; i++) {
    //   if (messages.elementAt(i).userId != currentUserId) {
    //     listOfGroupedMessages.add(messages.sublist(start, i));
    //     start = i;
    //   }
    // }
    //
    // listOfGroupedMessages.add(messages.sublist(start));
    // debugPrint("listOfGroupedMessages: ${listOfGroupedMessages.length}");
    // for (var groups in listOfGroupedMessages) {
    //   for (final message in groups) {
    //     debugPrint("${message.text} ${message.userId}");
    //   }
    // }

    return Column(
      children: [
        for (final messageGroup in messageGroupedByUser)
          Column(
            children: [
              GroupedMessages(messages: messageGroup.messages),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
      ],
    );
  }
}

class MessageList extends StatelessWidget {
  final String userId;

  const MessageList({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MessengerAppState>();

    final currentUser = appState.currentUser;
    final chat = appState.chats.firstWhere(
      (chat) =>
          chat.userIds.contains(currentUser.id) &&
          chat.userIds.contains(userId),
      orElse: () => Chat.empty([currentUser.id, userId]),
    );

    final messages = chat.messages;

    final messageGroupedByDate = MessageGroup.separateMessages(
      messages,
      Separator.date,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      reverse: true,
      child: Column(children: [
        for (final messageGroup in messageGroupedByDate)
          Column(
            children: [
              ChatDateDivider(date: messageGroup.messages.first.date),
              const SizedBox(height: 20),
              MessageGroupedByUser(messages: messageGroup.messages),
            ],
          ),
      ]),
    );
    // return ListView(
    //   padding: const EdgeInsets.all(10),
    //   controller: scrollController,
    //   children: [
    //     for (final messageGroup in messageGroupedByDate)
    //       Column(
    //         children: [
    //           ChatDateDivider(date: messageGroup.messages.first.date),
    //           const SizedBox(height: 20),
    //           MessageGroupedByUser(messages: messageGroup.messages),
    //         ],
    //       ),
    //   ],
    // );
  }
}
