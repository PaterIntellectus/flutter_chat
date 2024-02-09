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
    primary: Color.fromARGB(255, 80, 96, 109),
    onPrimary: Color.fromARGB(255, 33, 45, 54),
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
        Message(
            '1', "Сделай мне кофе, пожалуйста", DateTime(2022, 1, 27, 21, 41),
            status: MessageStatus.read),
        Message('2', "Окей", DateTime(2022, 1, 27, 21, 41, 1),
            status: MessageStatus.read),
        Message('1', "Уже сделал?", DateTime.now(), status: MessageStatus.sent),
      ],
    ),
    Chat(
      ['1', '4'],
      <Message>[
        Message('1', "Завтра напомни", DateTime(2024, 2, 1, 20, 17, 12, 992)),
        Message('2', "ок", DateTime(2024, 2, 1, 20, 17, 12, 992)),
        Message('2', "Ты скоро там?", DateTime(2024, 2, 2, 20, 17, 11)),
        Message('2', "Мы уже ждём", DateTime(2024, 2, 2, 20, 17, 12)),
        Message('1', "Выхожу", DateTime(2024, 2, 2, 20, 17, 12, 992)),
      ],
    )
  ];

  var friendsFilterText = '';
  void setFriendsFilterText(String newFilterText) {
    friendsFilterText = newFilterText.toLowerCase();
    notifyListeners();
  }
}
