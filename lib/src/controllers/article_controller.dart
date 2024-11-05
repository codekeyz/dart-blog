import 'dart:isolate';

import 'package:backend/src/dto/article_dto.dart';
import 'package:backend/src/models.dart';
import 'package:backend/src/services/services.dart';
import 'package:pharaoh/pharaoh_next.dart';
import 'package:shared/models.dart';
import 'package:yaroorm/yaroorm.dart';

import '../utils/utils.dart';

class ArticleController extends HTTPController {
  final ArticleService _articleService;

  ArticleController(this._articleService);

  Future<Response> index() async {
    final articles = await _articleService.getArticles();
    return jsonResponse({'articles': articles.map((e) => e.toJson()).toList()});
  }

  Future<Response> show(@param int articleId) async {
    final article = await _articleService.getArticle(articleId);
    if (article == null) return response.notFound();
    return jsonResponse(_articleResponse(article));
  }

  Future<Response> create(@body CreateArticleDTO data) async {
    final imageUrl = data.imageUrl ?? await Isolate.run(() => getRandomImage(data.title));

    final article = await user.articles.insert(NewServerArticleForServerUser(
      title: data.title,
      description: data.description,
      imageUrl: Value(imageUrl),
    ));

    return response.json(_articleResponse(article));
  }

  Future<Response> update(@param int articleId, @body CreateArticleDTO data) async {
    final article = await _articleService.updateArticle(user, articleId, data);
    if (article == null) return response.notFound();
    return jsonResponse(_articleResponse(article));
  }

  Future<Response> delete(@param int articleId) async {
    await _articleService.deleteArticle(user.id, articleId);
    return jsonResponse({'message': 'Article deleted'});
  }

  Map<String, dynamic> _articleResponse(Article article) => {'article': article.toJson()};

  ServerUser get user => request.auth as ServerUser;
}
