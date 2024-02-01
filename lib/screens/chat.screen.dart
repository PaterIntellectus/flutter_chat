import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_messenger/flutter_chat_icons_icons.dart';
import 'package:flutter_messenger/models/user.class.dart';
import 'package:flutter_messenger/widgets/time_difference.widget.dart';
import 'package:flutter_messenger/widgets/user_avatar.widget.dart';
import 'package:flutter_messenger/widgets/user_name.widget.dart';

class ChatScreen extends StatelessWidget {
  final User user;

  const ChatScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: theme.colorScheme.background,

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
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
            UserAvatarWidget(user: user),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserNameWidget(user: user),
                TimeDifferenceWidget(dateTime: user.lastLogin),
              ],
            )
          ],
        ),
      ),
      body: Row(children: [
        IconButton(
          onPressed: () {
            debugPrint('Record audio clicked');
          },
          icon: const Icon(FlutterChatIcons.audio),
        )
      ]),
    );
  }
}
