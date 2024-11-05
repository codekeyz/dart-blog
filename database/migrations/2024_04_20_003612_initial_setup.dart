import 'package:backend/src/models.dart';
import 'package:yaroorm/yaroorm.dart';

class InitialTableSetup extends Migration {
  @override
  void up(List<Schema> schemas) {
    schemas.addAll([ServerUserSchema, ServerArticleSchema]);
  }

  @override
  void down(List<Schema> schemas) {
    schemas.addAll([
      Schema.dropIfExists(ServerUserSchema),
      Schema.dropIfExists(ServerArticleSchema),
    ]);
  }
}
