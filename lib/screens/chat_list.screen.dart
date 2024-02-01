import 'package:flutter/material.dart';
import 'package:flutter_messenger/flutter_chat_icons_icons.dart';
import 'package:flutter_messenger/main.dart';
import 'package:flutter_messenger/models/chat.class.dart';
import 'package:flutter_messenger/models/user.class.dart';
import 'package:flutter_messenger/screens/chat.screen.dart';
import 'package:flutter_messenger/widgets/time_difference.widget.dart';
import 'package:flutter_messenger/widgets/user_avatar.widget.dart';
import 'package:flutter_messenger/widgets/user_name.widget.dart';
import 'package:provider/provider.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MessengerAppState>();
    final friends = appState.friends;

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          for (final friend in friends) ChatListTile(user: friend),
        ],
      ),
    );
  }
}

class ChatListHeader extends StatelessWidget {
  const ChatListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorScheme.secondary)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Чаты",
            style: TextStyle(
              fontSize: 32.0,
              fontFamily: "Gilroy-SemiBold",
            ),
          ),
          ChatListHeaderSearch()
        ],
      ),
    );
  }
}

class ChatListHeaderSearch extends StatelessWidget {
  const ChatListHeaderSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FlutterChatIcons.search,
            size: 40,
            color: theme.colorScheme.onSecondary,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Поиск',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ChatListHeader(),
            ChatList(),
          ],
        ),
      ),
    );
  }
}

class ChatListTile extends StatelessWidget {
  final User user;

  const ChatListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final appState = context.watch<MessengerAppState>();

    final currentUser = appState.currentUser;

    final chats = appState.chats;
    final chat = chats.firstWhere(
      (chat) => (chat.userIds.contains(user.id) &
          chat.userIds.contains(currentUser.id)),
      orElse: () => Chat([], []),
    );

    return ListTile(
      leading: UserAvatarWidget(user: user),
      title: UserNameWidget(user: user),
      subtitle: UserLastMessageWidget(
          user: user, chats: chats, currentUser: currentUser),
      trailing: TimeDifferenceWidget(dateTime: chat.getLastMessage().date),
      shape: Border(
        bottom: BorderSide(color: theme.colorScheme.secondary),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen(user: user)),
      ),
    );
  }
}

class UserLastMessageWidget extends StatelessWidget {
  final User user;
  final User currentUser;
  final List<Chat> chats;

  const UserLastMessageWidget({
    super.key,
    required this.user,
    required this.currentUser,
    required this.chats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final chat = chats.firstWhere(
        (chat) => (chat.userIds.contains(user.id) &
            chat.userIds.contains(currentUser.id)),
        orElse: () => Chat([], []));

    if (chat.isEmpty()) {
      return const SizedBox.shrink();
    }

    final lastMessage = chat.getLastMessage();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Builder(
          builder: (context) {
            if (lastMessage.userId != currentUser.id) {
              return const SizedBox.shrink();
            }
            return const Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Text(
                'Вы:',
              ),
            );
          },
        ),
        Expanded(
          child: Text(
            lastMessage.message,
            style: TextStyle(
              color: theme.colorScheme.onTertiary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
