import 'dart:async';
import 'dart:convert';
import 'dart:io';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:http/http.dart' show Response;
import 'package:http/browser_client.dart';
import 'package:shared/models.dart';

typedef ArticleWithAuthor = ({Article article, User author});

class ApiException extends HttpException {
  final Iterable<String> errors;
  ApiException(this.errors) : super(errors.join('\n'));
}

typedef HttpResponseCb = Future<Response> Function();

class ApiService {
  final Uri baseUrl;
  final BrowserClient client;

  ApiService(this.baseUrl) : client = BrowserClient()..withCredentials = true;

  Map<String, String> get _headers => {HttpHeaders.contentTypeHeader: 'application/json'};

  Uri getUri(String path) => baseUrl.replace(path: '/api$path');

  void clearAuthCookie() => html.document.cookie = null;

  Future<User> getUser() async {
    final result = await _runCatching(() => client.get(getUri('/users/me'), headers: _headers));

    final data = jsonDecode(result.body)['user'];
    return User.fromJson(data);
  }

  Future<User> loginUser(String email, String password) async {
    final requestBody = jsonEncode({'email': email, 'password': password});
    final result = await _runCatching(() => client.post(getUri('/auth/login'), headers: _headers, body: requestBody));

    final data = jsonDecode(result.body)['user'];
    return User.fromJson(data);
  }

  Future<bool> registerUser(String displayName, String email, String password) async {
    final requestBody = jsonEncode({'name': displayName, 'email': email, 'password': password});
    await _runCatching(() => client.post(getUri('/auth/register'), headers: _headers, body: requestBody));

    return true;
  }

  Future<List<ArticleWithAuthor>> getArticles() async {
    final result = await _runCatching(() => client.get(getUri('/articles'), headers: _headers));
    final items = jsonDecode(result.body)['articles'] as Iterable;

    return items.map((e) {
      return (article: Article.fromJson(e), author: User.fromJson(e['author']));
    }).toList();
  }

  Future<ArticleWithAuthor> getArticle(int articleId) async {
    final result = await _runCatching(() => client.get(getUri('/articles/$articleId'), headers: _headers));
    final articleData = jsonDecode(result.body)['article'];

    return (
      article: Article.fromJson(articleData),
      author: User.fromJson(articleData['author']),
    );
  }

  Future<Article> createArticle(String title, String description, String? imageUrl) async {
    final dataMap = {
      'title': title,
      'description': description,
      if (imageUrl != null && imageUrl.trim().isNotEmpty) 'imageUrl': imageUrl,
    };

    final result =
        await _runCatching(() => client.post(getUri('/articles'), headers: _headers, body: jsonEncode(dataMap)));

    final data = jsonDecode(result.body)['article'];
    return Article.fromJson(data);
  }

  Future<Article> updateArticle(int articleId, String title, String description, String? imageUrl) async {
    final requestData = {
      'title': title,
      'description': description,
      if (imageUrl != null && imageUrl.trim().isNotEmpty) 'imageUrl': imageUrl,
    };

    final result = await _runCatching(
        () => client.put(getUri('/articles/$articleId'), headers: _headers, body: jsonEncode(requestData)));

    final data = jsonDecode(result.body)['article'];
    return Article.fromJson(data);
  }

  Future<void> deleteArticle(int articleId) async {
    await _runCatching(() => client.delete(getUri('/articles/$articleId'), headers: _headers));
  }

  Future<Response> _runCatching(HttpResponseCb apiCall) async {
    try {
      final response = await apiCall.call();
      if (response.statusCode == HttpStatus.ok) return response;
      final errors = jsonDecode(response.body)['errors'] as List<dynamic>;
      throw ApiException(errors.map((e) => e.toString()));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException([e.toString()]);
    }
  }
}
