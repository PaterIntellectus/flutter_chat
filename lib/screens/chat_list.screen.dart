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
    final filterText = appState.friendsFilterText;

    final filteredFriends = filterText.isEmpty
        ? friends
        : friends.where((friend) => friend.nameContains(filterText)).toList();

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          for (final friend in filteredFriends) ChatListTile(user: friend),
        ],
      ),
    );
  }
}

class ChatListFriendsFilter extends StatelessWidget {
  final _filterController = TextEditingController();

  ChatListFriendsFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final appState = context.watch<MessengerAppState>();

    _filterController.text = appState.friendsFilterText;
    _filterController.selection = TextSelection.fromPosition(
      TextPosition(offset: _filterController.text.length),
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
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
              controller: _filterController,
              onEditingComplete: () => appState.setFriendsFilterText(
                _filterController.text,
              ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Чаты",
            style: TextStyle(
              fontSize: 32.0,
              fontFamily: "Gilroy-SemiBold",
            ),
          ),
          ChatListFriendsFilter()
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
      leading: UserAvatar(user: user),
      title: UserNameWidget(user: user),
      subtitle: UserLastMessageWidget(
        user: user,
        chats: chats,
        currentUser: currentUser,
      ),
      trailing: TimeDifferenceWidget(
        dateTime: chat.getLastMessage().date,
      ),
      shape: Border(
        bottom: BorderSide(
          color: theme.colorScheme.secondary,
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            user: user,
          ),
        ),
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

    if (chat.isEmpty) {
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
            return const Text(
              'Вы: ',
            );
          },
        ),
        Expanded(
          child: Text(
            lastMessage.text ?? '',
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
