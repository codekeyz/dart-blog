import 'package:backend/src/models.dart';
import 'package:shared/models.dart';
import 'package:yaroorm/yaroorm.dart';

import 'package:backend/src/dto/article_dto.dart';

class ArticleService {
  Future<List<Article>> getArticles({int? ownerId}) async {
    final query = ServerArticleQuery.withRelations((article) => [article.owner]);
    if (ownerId == null) {
      return query.findMany(orderBy: [
        OrderServerArticleBy.title(),
        OrderServerArticleBy.updatedAt(order: OrderDirection.desc),
      ]);
    }

    return query
        .where((article) => article.ownerId(ownerId))
        .findMany(orderBy: [OrderServerArticleBy.updatedAt(order: OrderDirection.desc)]);
  }

  Future<Article?> getArticle(int articleId) => ServerArticleQuery.findById(articleId);

  Future<Article?> updateArticle(User user, int articleId, CreateArticleDTO dto) async {
    final query = ServerArticleQuery.where((article) => and([
          article.id(articleId),
          article.ownerId(user.id),
        ]));

    if (!(await query.exists())) return null;

    await query.update(UpdateServerArticle(
      title: Value.absentIfNull(dto.title),
      description: Value.absentIfNull(dto.description),
      imageUrl: Value.absentIfNull(dto.imageUrl),
    ));

    return query.findOne();
  }

  Future<void> deleteArticle(int userId, int articleId) {
    return ServerArticleQuery.where((article) => and([
          article.id(articleId),
          article.ownerId(userId),
        ])).delete();
  }
}
