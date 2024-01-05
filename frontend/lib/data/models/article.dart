import 'package:json_annotation/json_annotation.dart';

part "article.g.dart";

@JsonSerializable()
class Article {
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Article(this.title, this.description, {required this.createdAt, required this.updatedAt});

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}
