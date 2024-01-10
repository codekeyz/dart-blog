import 'package:backend/src/models/models.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yaroorm/yaroorm.dart';

part 'article.g.dart';

@JsonSerializable()
@EntityMeta(table: 'articles', timestamps: true)
class Article extends Entity<int, Article> {
  final String title;
  final String description;

  final String? imageUrl;

  final int ownerId;

  Article(this.ownerId, this.title, this.description, {this.imageUrl});

  @override
  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  Future<User?> get owner => DB.query<User>().get(ownerId);

  static Article fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}
