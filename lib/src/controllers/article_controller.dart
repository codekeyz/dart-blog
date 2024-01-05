import 'package:backend/src/models/dto/article_dto.dart';
import 'package:backend/src/models/user.dart';
import 'package:yaroo/http/http.dart';
import 'package:yaroo/http/meta.dart';

class ArticleController extends HTTPController {
  Future<Response> index() async {
    return response.ok();
  }

  Future<Response> show(@param int articleId) async {
    return response.ok();
  }

  Future<Response> create(@body CreateArticleDTO data) async {
    return response.ok();
  }

  Future<Response> update(@param int articleId, @body CreateArticleDTO data) async {
    return response.ok();
  }

  Future<Response> delete(@param int articleId) async {
    return response.ok();
  }

  User get user => request.auth as User;
}
