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
    lastLogout = DateTime.now();
  }

  bool nameContains(final String pattern) {
    final lowerCasePattern = pattern.toLowerCase();
    return firstName.toLowerCase().contains(lowerCasePattern) ||
        lastName.toLowerCase().contains(lowerCasePattern);
  }
}
