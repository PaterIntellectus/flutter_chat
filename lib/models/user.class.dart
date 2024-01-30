import 'package:uuid/uuid.dart';

class User {
  String id = const Uuid().v4();
  String firstName;
  String lastName;

  User(this.firstName, this.lastName);
  User.withId(this.id, this.firstName, this.lastName);
}
