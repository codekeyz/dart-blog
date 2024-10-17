import 'package:backend/src/dto/article_dto.dart';
import 'package:backend/src/services/services.dart';
import 'package:pharaoh/pharaoh_next.dart';

import '../models/article.dart';
import '../models/user.dart';

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
    var imageUrl = data.imageUrl;
    if (app.config.isDebug) {
      imageUrl ??= 'https://dart.dev/assets/shared/dart-logo-for-shares.png';
    }

    final article = await _articleService.createArticle(user, data, imageUrl: imageUrl);
    return jsonResponse(_articleResponse(article));
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

  User get user => request.auth as User;
}
