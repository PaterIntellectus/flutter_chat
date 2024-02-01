import 'package:flutter/material.dart';
import 'package:flutter_messenger/models/user.class.dart';

class UserNameWidget extends StatelessWidget {
  final User user;

  const UserNameWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${user.firstName} ${user.lastName}',
      style: const TextStyle(
        fontFamily: "Gilroy-SemiBold",
        color: Colors.black,
        fontSize: 15,
      ),
    );
  }
}
