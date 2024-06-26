import 'package:backend/src/models/article/article.dart';
import 'package:yaroorm/yaroorm.dart';

class CreateArticlesTable extends Migration {
  @override
  void up(List<Schema> schemas) {
    schemas.add(ArticleSchema);
  }

  @override
  void down(List<Schema> schemas) {
    schemas.add(Schema.dropIfExists(ArticleSchema));
  }
}
