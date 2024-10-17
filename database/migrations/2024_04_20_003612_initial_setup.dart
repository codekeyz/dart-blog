import 'package:backend/src/models/article/article.dart';
import 'package:backend/src/models/user/user.dart';
import 'package:yaroorm/yaroorm.dart';

class InitialTableSetup extends Migration {
  @override
  void up(List<Schema> schemas) {
    schemas.addAll([UserSchema, ArticleSchema]);
  }

  @override
  void down(List<Schema> schemas) {
    schemas.addAll([
      Schema.dropIfExists(UserSchema),
      Schema.dropIfExists(ArticleSchema),
    ]);
  }
}
