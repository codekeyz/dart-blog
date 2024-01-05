import 'package:backend/src/models/dto/article_dto.dart';
import 'package:backend/src/models/models.dart';
import 'package:yaroorm/yaroorm.dart';

class ArticleService {
  Future<List<Article>> getArticles({String? ownerId}) async {
    final query = DB.query<Article>();
    if (ownerId == null) return query.all();

    return query.whereEqual('ownerId', ownerId).findMany();
  }

  Future<Article?> getArticle(int articleId) => DB.query<Article>().get(articleId);

  Future<Article> createArticle(User user, CreateArticleDTO data) async {
    final query = DB.query<Article>();
    final userId = user.id!;
    final article = Article(userId, data.title, data.description, imageUrl: data.imageUrl);

    return await query.insert<Article>(article);
  }

  Future<Article?> updateArticle(User user, int articleId, CreateArticleDTO dto) async {
    final userId = user.id!;
    final query = DB.query<Article>().whereEqual('id', articleId).whereEqual('ownerId', userId);
    if ((await query.findOne()) == null) return null;

    await query.update(dto.data);

    return await query.findOne();
  }

  Future<void> deleteArticle(int userId, int articleId) => DB.query<Article>().whereEqual('id', articleId).delete();
}
