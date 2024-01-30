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
  final currentUser = User.withId('1', 'Николай', 'Мамедов');

  final friends = <User>[
    User.withId('2', 'Виктор', 'Власов'),
    User.withId('3', 'Саша', 'Алексеев'),
    User.withId('4', 'Пётр', 'Жаринов'),
    User.withId('5', 'Алина', 'Жукова'),
  ];

  final chats = <Chat>[
    Chat(
      ['1', '2'],
      <Message>[
        Message(
          '2',
          "Дарова",
        ),
        Message(
          '2',
          "Ты тут?",
        ),
        Message(
          '2',
          "Займи денег пожалуйста...",
        ),
      ],
    ),
    Chat(
      ['1', '4'],
      <Message>[
        Message(
          '2',
          "Ты скоро там?",
        ),
        Message(
          '2',
          "Мы уже ждём",
        ),
        Message(
          '1',
          "Выхожу",
        ),
      ],
    )
  ];

  final messages = <Message>[
    Message(
      '2',
      "Дарова",
    ),
    Message(
      '2',
      "Ты тут?",
    ),
    Message(
      '2',
      "Займи денег пожалуйста...",
    ),
  ];
}
