import 'package:backend/src/models/models.dart';
import 'package:yaroorm/migration.dart';

class CreateArticlesTable extends Migration {
  @override
  void up(List<Schema> schemas) {
    final articleSchema = Schema.create('articles', (table) {
      return table
        ..id()
        ..string('title')
        ..string('description')
        ..string('imageUrl', nullable: true)
        ..integer('ownerId')
        ..foreign<Article, User>(
          column: 'ownerId',
          onKey: (fkey) => fkey.actions(
              onDelete: ForeignKeyAction.cascade,
              onUpdate: ForeignKeyAction.cascade),
        )
        ..timestamps();
    });

    schemas.add(articleSchema);
  }

  @override
  void down(List actions) {
    actions.add(Schema.dropIfExists('articles'));
  }
}
