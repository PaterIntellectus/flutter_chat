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
          '1',
          DateTime(2022, 1, 27, 21, 41),
          text: "Сделай мне кофе, пожалуйста",
          status: MessageStatus.read,
        ),
        Message('2', DateTime(2022, 1, 27, 21, 41, 1),
            text: "Окей", status: MessageStatus.read),
        Message('1', DateTime(2022, 1, 30, 21, 41, 1),
            text: "Уже сделал?", status: MessageStatus.sent),
        Message('1', DateTime.now(),
            text: "Всё в порядке?", status: MessageStatus.sent),
      ],
    ),
    Chat(
      ['1', '4'],
      <Message>[
        Message(
          '1',
          DateTime(2024, 2, 1, 20, 17, 12, 992),
          text: "Завтра напомни",
        ),
        Message(
          '2',
          DateTime(2024, 2, 1, 20, 17, 12, 992),
          text: "ок",
        ),
        Message(
          '2',
          DateTime(2024, 2, 2, 20, 17, 11),
          text: "Ты скоро там?",
        ),
        Message(
          '2',
          DateTime(2024, 2, 2, 20, 17, 12),
          text: "Мы уже ждём",
        ),
        Message(
          '1',
          DateTime(2024, 2, 2, 20, 17, 12, 992),
          text: "Выхожу",
        ),
      ],
    ),
    Chat(
      ['1', '3'],
      <Message>[
        Message(
          '1',
          DateTime(2024, 1, 31, 20, 14, 12, 992),
          text:
              "Дорогой друг, добро пожаловать! 🌟 Солнце сверкает на небе, словно бриллиант, и встречает тебя своим теплом. Ветер шепчет тайны деревьев, а звезды улыбаются с высоты своих небесных тронов. Это момент, когда мир открывает свои объятия и приглашает тебя в свою невероятную симфонию. Пусть каждый день будет для тебя как новая страница в книге приключений. Пусть твои мечты растут, как цветы весной, и пусть твои улыбки будут ярче солнца.",
        ),
        Message(
          '1',
          DateTime(2024, 2, 1, 20, 17, 12, 992),
          text: "Смотри что нафоткал на днях :P",
          attachment:
              '/data/user/0/com.example.flutter_chat/cache/741cf611-ec9e-48b7-af7a-9b2efe6c3e4a/IMG_20240218_192308.jpg',
        ),
        Message(
          '2',
          DateTime(2024, 2, 1, 20, 20, 12, 992),
          text: "Ничего себе, это где ты такие виды нашёл?",
        ),
      ],
    )
  ];

  var friendsFilterText = '';

  void sendMessage(
    final Message message,
    final String collocutorId,
  ) {
    if (message.isEmpty) {
      return;
    }

    final chat = chats.firstWhere(
      (chat) => chat.userIds.contains(
        collocutorId,
      ),
      orElse: () {
        final newChat = Chat.empty([currentUser.id, collocutorId]);
        chats.add(newChat);
        return newChat;
      },
    );

    chat.addMessage(message);
    notifyListeners();
  }

  void setFriendsFilterText(String newFilterText) {
    friendsFilterText = newFilterText.toLowerCase();
    notifyListeners();
  }
}
