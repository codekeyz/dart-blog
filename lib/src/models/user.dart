import 'package:json_annotation/json_annotation.dart';
import 'package:yaroorm/yaroorm.dart';

part 'user.g.dart';

const _createdAtColumn = 'created_at';
const _updatedAtColumn = 'updated_at';

@JsonSerializable()
class User extends Entity<int, User> {
  final String firstname;
  final String lastname;
  final int age;

  @override
  bool get enableTimestamps => true;

  User(this.firstname, this.lastname, this.age);

  @override
  Map<String, dynamic> toMap() => _$UserToJson(this);

  static User fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @JsonKey(name: _createdAtColumn)
  @override
  DateTime? get createdAt => super.createdAt;

  @JsonKey(name: _updatedAtColumn)
  @override
  DateTime? get updatedAt => super.updatedAt;

  @override
  String get createdAtColumn => _createdAtColumn;

  @override
  String get updatedAtColumn => _updatedAtColumn;
}
