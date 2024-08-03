import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:pharaoh/pharaoh_next.dart';
import 'package:yaroorm/yaroorm.dart';
import 'package:http/http.dart' as http;

import 'package:backend/src/dto/article_dto.dart';
import 'package:backend/src/models/article/article.dart';

import '../models/user/user.dart';

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
      description: data.description,
      imageUrl: imageUrl,
      ownerId: user.id,
    ));
  }

  Future<Article?> updateArticle(User user, int articleId, CreateArticleDTO dto) async {
    final query = ArticleQuery.where((article) => and([
          article.id(articleId),
          article.ownerId(user.id),
        ]));

    if (!(await query.exists())) return null;

    await query.update(UpdateArticle(
      title: value(dto.title),
      description: value(dto.description),
      imageUrl: value(dto.imageUrl),
    ));

    return query.findOne();
  }

  Future<void> deleteArticle(int userId, int articleId) {
    return ArticleQuery.where((article) => and([
          article.id(articleId),
          article.ownerId(userId),
        ])).delete();
  }

  Future<String?> getRandomImage(String searchText) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/search?query=$searchText&per_page=1'),
        headers: {HttpHeaders.authorizationHeader: env<String>('PEXELS_API_KEY', '')},
      ).timeout(const Duration(seconds: 2));
      final result = await Isolate.run(() => jsonDecode(response.body)) as Map;
      return result['photos'][0]['src']['medium'];
    } catch (_) {}
    return null;
  }
}
