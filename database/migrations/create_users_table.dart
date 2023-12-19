import 'package:yaroo/orm/orm.dart';

class CreateUsersTable extends Migration {
  const CreateUsersTable();

  @override
  void up(List $actions) {
    final userSchema = Schema.create('users', ($table) {
      return $table
        ..id()
        ..string('firstname')
        ..string('lastname')
        ..integer('age')
        ..timestamps();
    });

    $actions.add(userSchema);
  }

  @override
  void down(List $actions) {
    $actions.add(Schema.dropIfExists('users'));
  }
}
