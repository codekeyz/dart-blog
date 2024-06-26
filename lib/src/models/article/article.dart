import 'package:yaroorm/yaroorm.dart';

import '../user/user.dart';

part 'article.g.dart';

@Table('articles', converters: [dateTimeConverter, booleanConverter])
class Article extends Entity<Article> {
  @primaryKey
  final int id;

  final String title;
  final String description;

  final String? imageUrl;

  @reference(User, name: 'owner_id', onDelete: ForeignKeyAction.cascade)
  final int ownerId;

  @createdAtCol
  final DateTime createdAt;

  @updatedAtCol
  final DateTime updatedAt;

  Article(
    this.id,
    this.title,
    this.ownerId,
    this.description, {
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  // BelongsTo<Article, User> get owner => belongsTo<User>();

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'ownerId': ownerId,
      };

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        json['id'] as int,
        json['title'] as String,
        json['ownerId'] as int,
        json['description'] as String,
        imageUrl: json['imageUrl'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
