import 'package:backend/src/models/user/user.dart';
import 'package:yaroorm/migration.dart';

class CreateUsersTable extends Migration {
  @override
  void up(List schemas) {
    schemas.add(UserSchema);
  }

  @override
  void down(List schemas) {
    schemas.add(Schema.dropIfExists(UserSchema));
  }
}
