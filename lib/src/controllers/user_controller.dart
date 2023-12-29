import 'package:yaroo/http/http.dart';
import 'package:yaroo/http/meta.dart';
import 'package:yaroorm/yaroorm.dart';
import 'package:zomato/src/models/models.dart';
import 'package:zomato/src/services/services.dart';

import '../models/dto/create_user_dto.dart';

class UserController extends HTTPController {
  final UserService userSvc;

  UserController(this.userSvc);

  Future<Response> index() async {
    final result = await DB.query<User>().all();
    return jsonResponse(result);
  }

  Future<Response> create(@dto CreateUserDTO userDTO) async {
    final userTable = DB.query<User>();

    final userData = User(userDTO.firstname, userDTO.lastname, userDTO.age);

    final user = await userTable.insert<User>(userData);

    return jsonResponse(user);
  }

  Future<Response> show(@param int userId) async {
    final user = await DB.query<User>().get(userId);
    if (user == null) return notFound('User not found');

    return jsonResponse(user);
  }

  Future<Response> update(@param int userId, @body Map<String, dynamic> reqBody) async {
    final query = DB.query<User>().whereEqual('id', userId);

    /// check if user exists
    if (await query.findOne() == null) return notFound('User not found');

    /// update the record
    await query.update(reqBody);

    /// fetch the updated user
    final updatedUser = await query.findOne();
    return jsonResponse(updatedUser);
  }

  Future<Response> delete(@param int userId) async {
    final query = DB.query<User>().whereEqual('id', userId);
    if (await query.findOne() == null) return notFound('User not found');

    await query.delete();

    return jsonResponse('User $userId deleted successfully');
  }
}
