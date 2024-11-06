import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final int id;

  final String name;

  final String email;

  final DateTime createdAt;

  final DateTime updatedAt;

  const User(
    this.id,
    this.name,
    this.email, {
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
