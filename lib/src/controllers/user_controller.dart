import 'package:yaroo/db/db.dart';
import 'package:yaroo/http/http.dart';
import 'package:zomato/src/models/models.dart';
import 'package:zomato/src/services/services.dart';

class UserController extends HTTPController {
  final UserService userSvc;

  UserController(this.userSvc);

  Future<Response> index() async {
    final result = await DB.query('users').all<User>();
    return jsonResponse(result);
  }

  Future<Response> create() async {
    final reqBody = Map.from(body ?? {});
    if (reqBody.isEmpty) return badRequest('Request body cannot be empty');

    final result = await DB.query('users').insert<User>(User(
          reqBody['firstname'],
          reqBody['lastname'],
          reqBody['age'],
        ));

    return jsonResponse(result);
  }

  Future<Response> show() async {
    final user = await DB.query('users').where('id', '=', params['userId']!).findOne<User>();
    if (user == null) return notFound('User not found');

    return jsonResponse(user);
  }

  Future<Response> update() async {
    final updateData = Map<String, dynamic>.from(body ?? {});
    if (updateData.isEmpty) return badRequest('User Id & Update data is required');

    final query = DB.query('users').where('id', '=', params['userId']!);

    /// check if user exists
    if (await query.findOne() == null) return notFound('User not found');

    /// update the record
    await query.update(updateData);

    /// fetch the updated user
    final updatedUser = await query.findOne<User>();
    return jsonResponse(updatedUser);
  }

  Future<Response> delete() async {
    final userId = params['userId']!;

    final query = DB.query('users').where('id', '=', userId);
    if (await query.findOne() == null) return notFound('User not found');

    await query.delete();

    return jsonResponse('User $userId deleted successfully');
  }
}
