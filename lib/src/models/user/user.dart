import 'package:yaroorm/yaroorm.dart';

import '../article/article.dart';

part 'user.g.dart';

@table
class User extends Entity<User> {
  @primaryKey
  final int id;

  final String name;

  final String email;

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
