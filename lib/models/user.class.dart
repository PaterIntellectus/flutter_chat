import 'package:uuid/uuid.dart';

class User {
  String id = const Uuid().v4();
  String firstName;
  String lastName;
  bool isOnline = false;
  DateTime lastLogin = DateTime.now();
  DateTime lastLogout = DateTime.now();

  User(this.firstName, this.lastName);
  User.fullConstructor(
    this.id,
    this.firstName,
    this.lastName,
    this.isOnline,
    this.lastLogin,
  );

  login() {
    isOnline = true;
    lastLogin = DateTime.now();
  }

  logout() {
    isOnline = false;
  }
}
