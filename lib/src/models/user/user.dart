import 'package:backend/src/models/article/article.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yaroorm/migration.dart';
import 'package:yaroorm/yaroorm.dart';

part 'user.entity.dart';

@Table('users')
class User extends _$UserEntity {
  @primaryKey
  final int id;

  final String name;

  final String email;

  @JsonKey(includeToJson: false, defaultValue: '')
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

  HasMany<Article> get articles => hasMany<Article>();

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'email': email,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        json['id'] as int,
        json['name'] as String,
        json['email'] as String,
        password: json['password'] as String? ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
