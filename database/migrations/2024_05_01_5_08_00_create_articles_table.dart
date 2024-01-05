import 'package:yaroorm/migration.dart';

class CreateArticlesTable extends Migration {
  @override
  void up(List<Schema> schemas) {
    final userSchema = Schema.create('articles', (table) {
      return table
        ..id()
        ..string('title')
        ..string('description')
        ..string('imageUrl', nullable: true)
        ..integer('ownerId')
        ..timestamps();
    });

    schemas.add(userSchema);
  }

  @override
  void down(List actions) {
    actions.add(Schema.dropIfExists('articles'));
  }
}
