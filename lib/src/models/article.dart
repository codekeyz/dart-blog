import 'package:backend/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yaroorm/yaroorm.dart';

part 'article.g.dart';

@JsonSerializable()
@EntityMeta(table: 'articles', timestamps: true)
class Article extends Entity<int, Article> {
  String title;
  String description;

  String? imageUrl;

  final int ownerId;

  Article(this.ownerId, this.title, this.description, {this.imageUrl});

  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  Future<User?> get owner => DB.query<User>().get(ownerId);

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
}
