import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_messenger/flutter_chat_icons_icons.dart';
import 'package:flutter_messenger/main.dart';
import 'package:flutter_messenger/models/chat.class.dart';
import 'package:flutter_messenger/models/message.class.dart';
import 'package:flutter_messenger/models/user.class.dart';
import 'package:flutter_messenger/widgets/action_icon_button.widget.dart';
import 'package:flutter_messenger/widgets/standard_divider.widget.dart';
import 'package:flutter_messenger/widgets/time_difference.widget.dart';
import 'package:flutter_messenger/widgets/user_avatar.widget.dart';
import 'package:flutter_messenger/widgets/user_name.widget.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatDateDivider extends StatelessWidget {
  final DateTime date;

  const ChatDateDivider({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: StandardDivider(
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
          ),
        ),
      ],
    );
  }
}

class ChatFooter extends StatelessWidget {
  final ThemeData theme;

  const ChatFooter({
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: theme.colorScheme.secondary),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          ActionIconButtonWidget(
            icon: const Icon(FlutterChatIcons.attach),
            onPressed: () {
              debugPrint('Attach clicked');
            },
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  hintText: "Сообщение",
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ActionIconButtonWidget(
            icon: const Icon(FlutterChatIcons.audio),
            onPressed: () {
              debugPrint("Record audio clicked");
            },
          ),
        ],
      ),
    );
  }
}

class ChatMessageList extends StatelessWidget {
  final Chat chat;

  const ChatMessageList({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final messages = chat.messages;

    return Expanded(
      child: GroupedListView(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        elements: messages,
        sort: false,
        groupBy: (message) => DateFormat("dd.MM.yy").format(message.date),
        groupHeaderBuilder: (Message message) => Column(
          children: [
            ChatDateDivider(
              date: message.date,
            ),
            const SizedBox(height: 20)
          ],
        ),
        itemBuilder: (context, element) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageBox(message: element),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final User user;
  final Chat chat;

  const ChatScreen({super.key, required this.user, required this.chat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Column(
        children: [
          ChatMessageList(chat: chat),
          ChatFooter(theme: theme),
        ],
      ),
    );
  }
}

class MessageBox extends StatelessWidget {
  final Message message;

  const MessageBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final appState = context.watch<MessengerAppState>();
    final currentUser = appState.currentUser;

    final isCurrentUserMessage = message.userId == currentUser.id;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomRight: Radius.zero,
          bottomLeft: Radius.circular(16),
        ),
        color: isCurrentUserMessage
            ? const Color(0xFF3CED78)
            : theme.colorScheme.secondary,
      ),
      child: Row(
        mainAxisAlignment: (isCurrentUserMessage)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: TextStyle(
                color: isCurrentUserMessage
                    ? const Color(0xFF00521C)
                    : theme.colorScheme.onSurface),
          ),
          const SizedBox(width: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat("HH:mm").format(message.date),
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 4),
              isCurrentUserMessage
                  ? Icon(
                      message.status == MessageStatus.read
                          ? FlutterChatIcons.read
                          : FlutterChatIcons.unread,
                      size: 12,
                      color: const Color(0xFF00521C),
                    )
                  : const SizedBox.shrink(),
            ],
          )
        ],
      ),
    );
  }
}
