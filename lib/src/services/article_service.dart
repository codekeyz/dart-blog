import 'package:yaroorm/yaroorm.dart';

import '../dto/article_dto.dart';
import '../models/article/article.dart';
import '../models/user/user.dart';

class ArticleService {
  Future<List<Article>> getArticles({int? ownerId}) async {
    if (ownerId == null) {
      return ArticleQuery.findMany(
        orderBy: [
          OrderArticleBy.title(OrderDirection.asc),
          OrderArticleBy.updatedAt(OrderDirection.desc),
        ],
      );
    }

    return ArticleQuery.where((article) => article.ownerId(ownerId)).findMany(
      orderBy: [
        OrderArticleBy.updatedAt(OrderDirection.desc),
      ],
    );
  }

  Future<Article?> getArticle(int articleId) => ArticleQuery.findById(articleId);

  Future<Article?> updateArticle(User user, int articleId, CreateArticleDTO dto) async {
    final query = ArticleQuery.where((article) => article.and([
          article.id(articleId),
          article.ownerId(user.id),
        ]));

    if (!(await query.exists())) return null;

    await query.update(
      title: value(dto.title),
      description: value(dto.description),
      imageUrl: value(dto.imageUrl),
    );

    return query.findOne();
  }

  Future<void> deleteArticle(int userId, int articleId) {
    return ArticleQuery.where((article) => article.and([
          article.id(articleId),
          article.ownerId(userId),
        ])).delete();
  }
}
