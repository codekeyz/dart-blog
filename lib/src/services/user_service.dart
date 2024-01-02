import 'package:yaroorm/yaroorm.dart';
import 'package:zomato/src/models/models.dart';

class UserService {
  Future<User> newUser(String name, String email, String password) async {
    return User(name, email, password).save();
  }

  Future<User?> getUser(int userId) async {
    return DB.query<User>().get(userId);
  }
}
