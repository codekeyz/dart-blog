import 'package:backend/src/models/article/article.dart';
import 'package:backend/src/models/user/user.dart';
import 'package:yaroorm/migration.dart';

class CreateArticlesTable extends Migration {
  @override
  void up(List<Schema> schemas) {
    final arc = ArticleSchema
      ..foreign<User>(
        column: 'ownerId',
        onKey: (fkey) => fkey.actions(onDelete: ForeignKeyAction.cascade, onUpdate: ForeignKeyAction.cascade),
      );

    schemas.add(arc);
  }

  @override
  void down(List actions) {
    actions.add(Schema.dropIfExists(ArticleSchema));
  }
}
