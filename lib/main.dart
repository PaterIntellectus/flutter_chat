import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat_icons_icons.dart';

void main() {
  runApp(const MessengerApp());
}

class ChatList extends StatelessWidget {
  const ChatList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView();
  }
}

class ChatListHeader extends StatelessWidget {
  const ChatListHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Чаты",
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FlutterChatIcons.search),
                  SizedBox(width: 6),
                  Flexible(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Поиск',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChatListPage extends StatefulWidget {
  const ChatListPage({
    super.key,
  });

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class MessengerApp extends StatelessWidget {
  const MessengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          fontFamily: "Gilroy",
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)),
      home: const Scaffold(
        body: SafeArea(child: ChatListPage()),
      ),
    );
  }
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ChatListHeader(),
        ChatList(),
      ],
    );
  }
}
