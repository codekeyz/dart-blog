import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:backend/src/models/dto/article_dto.dart';
import 'package:backend/src/models/models.dart';
import 'package:yaroo/yaroo.dart';
import 'package:yaroorm/yaroorm.dart';
import 'package:http/http.dart' as http;

class ArticleService {
  Future<List<Article>> getArticles({String? ownerId}) async {
    final query = DB.query<Article>();
    if (ownerId == null) return query.all();

    return query.whereEqual('ownerId', ownerId).findMany();
  }

  Future<Article?> getArticle(int articleId) => DB.query<Article>().get(articleId);

  Future<Article> createArticle(User user, CreateArticleDTO data, {String? imageUrl}) async {
    imageUrl ??= await getRandomImage(data.title);

    final query = DB.query<Article>();
    final userId = user.id!;
    final article = Article(userId, data.title, data.description, imageUrl: imageUrl);

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

  Future<String?> getRandomImage(String searchText) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/search?query=$searchText&per_page=1'),
        headers: {HttpHeaders.authorizationHeader: env<String>('PEXELS_API_KEY')!},
      ).timeout(const Duration(seconds: 2));
      final result = await Isolate.run(() => jsonDecode(response.body)) as Map;
      return result['photos'][0]['src']['medium'];
    } catch (_) {}
    return null;
  }
}
