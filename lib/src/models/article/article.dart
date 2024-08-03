import 'package:json_annotation/json_annotation.dart';
import 'package:yaroorm/yaroorm.dart';

import '../user/user.dart';

part 'article.g.dart';

@table
@JsonSerializable(fieldRename: FieldRename.snake)
class Article extends Entity<Article> {
  @primaryKey
  final int id;

  final String title;
  final String description;

  final String? imageUrl;

  @bindTo(User, onDelete: ForeignKeyAction.cascade)
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

  BelongsTo<Article, User> get owner => belongsTo<User>(#owner);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}
