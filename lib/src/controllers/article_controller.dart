import 'package:backend/src/models/dto/article_dto.dart';
import 'package:backend/src/services/services.dart';
import 'package:yaroo/http/http.dart';
import 'package:yaroo/http/meta.dart';

import '../models/models.dart';

class ArticleController extends HTTPController {
  final ArticleService _articleService;

  ArticleController(this._articleService);

  Future<Response> index() async {
    final articles = await _articleService.getArticles();
    return response.json(articles);
  }

  Future<Response> show(@param int articleId) async {
    final article = await _articleService.getArticle(articleId);
    if (article == null) return response.notFound();
    return response.json(_articleResponse(article));
  }

  Future<Response> create(@body CreateArticleDTO data) async {
    final article = await _articleService.createArticle(user, data);
    return response.json(_articleResponse(article));
  }

  Future<Response> update(@param int articleId, @body CreateArticleDTO data) async {
    final article = await _articleService.updateArticle(user, articleId, data);
    if (article == null) return response.notFound();
    return response.json(_articleResponse(article));
  }

  Future<Response> delete(@param int articleId) async {
    await _articleService.deleteArticle(user.id!, articleId);
    return response.json({'message': 'Article deleted'});
  }

  Map<String, dynamic> _articleResponse(Article article) => {'article': article.toJson()};

  User get user => request.auth as User;
}
