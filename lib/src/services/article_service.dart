import 'dart:isolate';

import 'package:shared/models.dart';
import 'package:yaroorm/yaroorm.dart';

import 'package:backend/src/dto/article_dto.dart';

import '../utils/utils.dart';

class ArticleService {
  Future<List<Article>> getArticles({int? ownerId}) async {
    if (ownerId == null) {
      return ArticleQuery.findMany(
        orderBy: [
          OrderArticleBy.title(),
          OrderArticleBy.updatedAt(order: OrderDirection.desc),
        ],
      );
    }

    return ArticleQuery.where((article) => article.ownerId(ownerId)).findMany(
      orderBy: [
        OrderArticleBy.updatedAt(order: OrderDirection.desc),
      ],
    );
  }

  Future<Article?> getArticle(int articleId) => ArticleQuery.findById(articleId);

  Future<Article> createArticle(User user, CreateArticleDTO data, {String? imageUrl}) async {
    imageUrl ??= await Isolate.run(() => getRandomImage(data.title));

    return await ArticleQuery.insert(NewArticle(
      title: data.title,
      ownerId: user.id,
      description: data.description,
      imageUrl: Value.absentIfNull(imageUrl),
    ));
  }

  Future<Article?> updateArticle(User user, int articleId, CreateArticleDTO dto) async {
    final query = ArticleQuery.where((article) => and([
          article.id(articleId),
          article.ownerId(user.id),
        ]));

    if (!(await query.exists())) return null;

    await query.update(UpdateArticle(
      title: Value.absentIfNull(dto.title),
      description: Value.absentIfNull(dto.description),
      imageUrl: Value.absentIfNull(dto.imageUrl),
    ));

    return query.findOne();
  }

  Future<void> deleteArticle(int userId, int articleId) {
    return ArticleQuery.where((article) => and([
          article.id(articleId),
          article.ownerId(userId),
        ])).delete();
  }
}
