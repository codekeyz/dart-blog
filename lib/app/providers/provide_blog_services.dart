import 'package:backend/src/services/services.dart';
import 'package:yaroo/http/http.dart';

class BlogServiceProvider extends ServiceProvider {
  @override
  void register() {
    app.singleton<UserService>(UserService());

    app.singleton<ArticleService>(ArticleService());
  }
}
