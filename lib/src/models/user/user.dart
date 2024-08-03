import 'package:json_annotation/json_annotation.dart';
import 'package:yaroorm/yaroorm.dart';

import '../article/article.dart';

part 'user.g.dart';

@table
@JsonSerializable(fieldRename: FieldRename.snake)
class User extends Entity<User> {
  @primaryKey
  final int id;

  final String name;

  final String email;

  @JsonKey(includeToJson: false)
  final String password;

  @createdAtCol
  final DateTime createdAt;

  @updatedAtCol
  final DateTime updatedAt;

  User(
    this.id,
    this.name,
    this.email, {
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  HasMany<User, Article> get articles => hasMany<Article>(#articles);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
