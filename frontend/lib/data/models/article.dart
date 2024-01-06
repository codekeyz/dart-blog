import 'package:json_annotation/json_annotation.dart';

part "article.g.dart";

@JsonSerializable()
class Article {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  final int ownerId;

  const Article(
    this.id,
    this.title,
    this.description, {
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.ownerId,
  });

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}
