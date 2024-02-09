import 'package:flutter/material.dart';
import 'package:flutter_messenger/models/user.class.dart';

class UserAvatar extends StatelessWidget {
  final User user;

  const UserAvatar({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff1FDB5F), Color(0xff31c764)],
        ),
      ),
      child: Text(
        '${user.firstName.characters.elementAt(0)}${user.lastName.characters.elementAt(0)}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: "Gilroy-Bold",
        ),
      ),
    );
  }
}
