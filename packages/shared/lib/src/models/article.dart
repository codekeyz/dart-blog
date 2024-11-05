import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Article {
  final int id;

  final String title;
  final String description;

  final String? imageUrl;

  final int ownerId;

  final DateTime createdAt;
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

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}
