import 'package:flutter/material.dart';
import 'package:flutter_messenger/models/chat.class.dart';
import 'package:flutter_messenger/models/message.class.dart';
import 'package:flutter_messenger/models/user.class.dart';
import 'package:flutter_messenger/screens/chat_list.screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MessengerApp());
}

class MessengerApp extends StatelessWidget {
  final colorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF9DB7CB),
    onPrimary: Colors.blue,
    secondary: Color(0xFFEDF2F6),
    onSecondary: Color(0xFF9DB7CB),
    tertiary: Colors.cyan,
    onTertiary: Color(0xFF5E7A90),
    background: Colors.white,
    onBackground: Colors.black,
    error: Colors.red,
    onError: Colors.blue,
    surface: Color(0xFFEDF2F6),
    onSurface: Color(0xFF2B333E),
    outlineVariant: Color(0xFF9db7cb),
  );

  const MessengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MessengerAppState(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: "Gilroy-Medium",
          colorScheme: colorScheme,
        ),
        home: const ChatListScreen(),
      ),
    );
  }
}

class MessengerAppState extends ChangeNotifier {
  final currentUser = User.fullConstructor(
    '1',
    'Николай',
    'Мамедов',
    true,
    DateTime(2024, 2, 1, 16, 7, 43),
  );

  final friends = <User>[
    User.fullConstructor(
        '2', 'Виктор', 'Власов', true, DateTime(2024, 2, 1, 16, 7, 43)),
    User.fullConstructor(
        '3', 'Саша', 'Алексеев', false, DateTime(2024, 2, 1, 0, 7, 20)),
    User.fullConstructor(
        '4', 'Пётр', 'Жаринов', false, DateTime(2024, 1, 31, 16, 7, 43)),
    User.fullConstructor(
        '5', 'Алина', 'Жукова', true, DateTime(2024, 2, 1, 16, 8, 27)),
    User.fullConstructor(
        '6', 'Test', 'Testov', false, DateTime(2024, 2, 1, 19, 8, 27)),
  ];

  final chats = <Chat>[
    Chat(
      ['1', '2'],
      <Message>[
        Message.withDate('2', "Дарова", DateTime(2024, 2, 1, 20, 17, 11)),
        Message.withDate('2', "Ты тут?", DateTime(2024, 2, 1)),
        Message.withDate(
            '2', "Займи денег пожалуйста...", DateTime(2024, 1, 1, 16, 26, 1)),
      ],
    ),
    Chat(
      ['1', '4'],
      <Message>[
        Message.withDate(
            '2', "Ты скоро там?", DateTime(2024, 2, 1, 20, 17, 11)),
        Message.withDate('2', "Мы уже ждём", DateTime(2024, 2, 1, 20, 17, 12)),
        Message.withDate('1', "Выхожу", DateTime(2024, 2, 1, 20, 17, 12, 992)),
      ],
    )
  ];
}
