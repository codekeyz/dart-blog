import 'package:json_annotation/json_annotation.dart';
import 'package:yaroorm/yaroorm.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Entity<int, User> {
  final String firstname;
  final String lastname;
  final int age;

  User(this.firstname, this.lastname, this.age);

  @override
  Map<String, dynamic> toMap() => _$UserToJson(this);

  static User fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  bool get enableTimestamps => true;
}
