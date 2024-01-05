import 'package:frontend/data/models/article.dart';
import 'package:frontend/data/services.dart';
import 'package:frontend/utils/provider.dart';
import 'package:meta/meta.dart';

class ArticleProvider extends BaseProvider<List<Article>> {
  @visibleForTesting
  ApiService get apiSvc => getIt.get<ApiService>();

  Future<void> fetchArticles() async {
    if (!apiSvc.hasAuthCookie) return;

    final articles = await safeRun(() => apiSvc.getArticles());
    if (articles == null) return;

    addEvent(ProviderEvent.success(data: articles));
  }
}
