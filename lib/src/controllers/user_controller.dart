import 'package:yaroo/http/http.dart';
import 'package:yaroo/http/meta.dart';
import 'package:yaroorm/yaroorm.dart';
import 'package:zomato/src/models/models.dart';
import 'package:zomato/src/services/services.dart';

import '../models/dto/user_dto.dart';

class UserController extends HTTPController {
  final UserService userSvc;

  UserController(this.userSvc);

  Future<Response> index() async {
    final result = await DB.query<User>().all();

    return jsonResponse(result);
  }

  Future<Response> create(@body CreateUserDTO userDTO) async {
    final user = await User(userDTO.firstname, userDTO.lastname, userDTO.age).save();

    return jsonResponse(user);
  }

  Future<Response> show(@param int userId) async {
    final user = await DB.query<User>().get(userId);
    if (user == null) return notFound('User not found');

    return jsonResponse(user);
  }

  Future<Response> update(@param int userId, @body UpdateUserDTO reqBody) async {
    var user = await DB.query<User>().get(userId);
    if (user == null) return notFound('User not found');

    user = await user.update(reqBody.data);

    return jsonResponse(user);
  }

  Future<Response> delete(@param int userId) async {
    final user = await DB.query<User>().get(userId);
    if (user == null) return notFound('User not found');

    await user.delete();

    return jsonResponse('User $userId deleted successfully');
  }
}
