import 'package:json_annotation/json_annotation.dart';
import 'package:yaroo/orm/orm.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Entity<int> {
  final String firstname;
  final String lastname;
  final int age;

  User(this.firstname, this.lastname, this.age);

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  static User fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
