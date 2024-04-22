import 'package:backend/src/models/user/user.dart';
import 'package:yaroorm/yaroorm.dart';

class CreateUsersTable extends Migration {
  @override
  void up(List<Schema> schemas) {
    schemas.add(UserSchema);
  }

  @override
  void down(List<Schema> schemas) {
    schemas.add(Schema.dropIfExists(UserSchema));
  }
}
