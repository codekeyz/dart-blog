import 'package:frontend/data/models/article.dart';
import 'package:frontend/data/services.dart';
import 'package:frontend/utils/provider.dart';
import 'package:meta/meta.dart';

class ArticleProvider extends BaseProvider<List<Article>> {
  @visibleForTesting
  ApiService get apiSvc => getIt.get<ApiService>();
}
