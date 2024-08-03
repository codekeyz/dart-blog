import 'package:backend/src/services/services.dart';
import 'package:pharaoh/pharaoh_next.dart';

class BlogServiceProvider extends ServiceProvider {
  @override
  void register() {
    app.singleton<ArticleService>(ArticleService());
  }
}
