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
import 'package:intl/intl.dart' as intl;
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
        groupBy: (message) => intl.DateFormat("dd.MM.yy").format(message.date),
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

    return Row(
      textDirection:
          isCurrentUserMessage ? TextDirection.rtl : TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomPaint(
          size: const Size(12, 21),
          painter: MessageBoxTail(
            color: isCurrentUserMessage
                ? const Color(0xFF3CED78)
                : theme.colorScheme.secondary,
            isCurrentUserMessage: isCurrentUserMessage,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(21),
              topRight: const Radius.circular(21),
              bottomRight: isCurrentUserMessage
                  ? Radius.zero
                  : const Radius.circular(21),
              bottomLeft: isCurrentUserMessage
                  ? const Radius.circular(21)
                  : Radius.zero,
            ),
            color: isCurrentUserMessage
                ? const Color(0xFF3CED78)
                : theme.colorScheme.secondary,
          ),
          child: Row(
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                    minWidth: 10),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: isCurrentUserMessage
                        ? const Color(0xFF00521C)
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                intl.DateFormat("HH:mm").format(message.date),
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
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ],
    );
  }
}

class MessageBoxTail extends CustomPainter {
  final Color color;
  final bool isCurrentUserMessage;

  MessageBoxTail(
      {this.color = Colors.black, this.isCurrentUserMessage = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    Path path = Path();
    if (isCurrentUserMessage) {
      path.moveTo(0, 0);
      path.conicTo(
        size.width * 0.1,
        size.height * 0.8,
        size.width,
        size.height,
        1,
      );
      path.lineTo(0, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.conicTo(
        size.width * 0.9,
        size.height * 0.8,
        0,
        size.height,
        1,
      );
      path.lineTo(size.width, size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
