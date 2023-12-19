import 'package:yaroo/http/http.dart';
import 'package:yaroo/orm/orm.dart';
import 'package:zomato/src/models/models.dart';
import 'package:zomato/src/services/services.dart';

class UserController extends BaseController {
  final UserService userSvc;

  UserController(this.userSvc);

  Future<Response> index(Request req, Response res) async {
    final result = await DB.query('users').all<User>();
    return res.json(result);
  }

  Future<Response> create(Request req, Response res) async {
    final reqBody = Map<String, dynamic>.from(req.body ?? {});
    if (reqBody.isEmpty) {
      return res.json(
        {'error': 'Request body cannot be empty'},
        statusCode: 422,
      );
    }

    final result = await DB.query('users').insert<User>(User(
          reqBody['firstname'],
          reqBody['lastname'],
          reqBody['age'],
        ));

    return res.json(result);
  }

  Future<Response> show(Request req, Response res) async {
    final user = await DB.query('users').where('id', '=', req.params['userId']!).findOne<User>();
    if (user == null) return res.notFound();

    return res.json(user);
  }

  Future<Response> update(Request req, Response res) async {
    final userId = req.params['userId']!;

    /// doing some validations. Hopefully someone writes a package to simplify this
    final updateData = Map<String, dynamic>.from(req.body);
    if (updateData.isEmpty) {
      return res.json(
        {'error': 'User Id & Update data is required'},
        statusCode: 422,
      );
    }

    final query = DB.query('users').where('id', '=', userId);

    /// update the record
    await query.update(updateData);

    /// fetch the updated record
    final updatedUser = await query.findOne<User>();

    /// send the response
    return res.json(updatedUser);
  }

  Future<Response> delete(Request req, Response res) async {
    final userId = req.params['userId']!;

    final query = DB.query('users').where('id', '=', userId);
    if (await query.findOne() == null) {
      return res.notFound();
    }

    await query.delete();

    return res.json('User $userId deleted successfully');
  }
}
