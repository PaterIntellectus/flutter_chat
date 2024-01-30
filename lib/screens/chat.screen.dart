import 'package:flutter/material.dart';
import 'package:flutter_messenger/flutter_chat_icons_icons.dart';
import 'package:flutter_messenger/models/user.class.dart';
import 'package:flutter_messenger/widgets/user_avatar.widget.dart';

class ChatScreen extends StatelessWidget {
  final User user;

  const ChatScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            FlutterChatIcons.arrow_left_s,
          ),
        ),
        title: UserAvatarWidget(user: user),
      ),
      body: const Text('body'),
    );
  }
}
