import 'package:frontend/data/api_service.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils/provider.dart';
import 'package:meta/meta.dart';
import 'package:shared/models.dart';

class ArticleProvider extends BaseProvider<List<Article>> {
  @visibleForTesting
  ApiService get apiSvc => getIt.get<ApiService>();

  Future<void> fetchArticles() async {
    final articles = await safeRun(() => apiSvc.getArticles());
    if (articles == null) return;

    addEvent(ProviderEvent.success(data: articles.map((e) => e.article).toList()));
  }

  Future<void> addArticle(String title, String description, String? imageUrl) async {
    final articles = lastEvent?.data ?? [];
    final article = await safeRun(() => apiSvc.createArticle(title, description, imageUrl));
    if (article == null) return;

    addEvent(ProviderEvent.success(data: [...articles, article]));
  }

  Future<void> updateArticle(int articleId, String title, String description, String? imageUrl) async {
    final articles = lastEvent?.data ?? [];
    final article = await safeRun(() => apiSvc.updateArticle(articleId, title, description, imageUrl));
    if (article == null) return;

    addEvent(ProviderEvent.success(data: [...articles, article]));
  }

  Future<void> deleteArticle(
    int articleId,
  ) async {
    final articles = lastEvent?.data ?? [];
    await safeRun(() => apiSvc.deleteArticle(
          articleId,
        ));

    addEvent(ProviderEvent.success(data: [
      ...articles,
    ]));
  }
}
