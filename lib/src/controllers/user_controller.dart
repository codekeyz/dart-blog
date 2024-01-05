import 'package:yaroo/http/http.dart';
import 'package:yaroo/http/meta.dart';
import 'package:yaroorm/yaroorm.dart';
import 'package:backend/src/models/models.dart';
import 'package:backend/src/services/services.dart';

class UserController extends HTTPController {
  final UserService userSvc;

  UserController(this.userSvc);

  Future<Response> currentUser() async {
    final auth = request.auth as User;
    return jsonResponse({'user': auth.toPublic});
  }

  Future<Response> index() async {
    final result = await DB.query<User>().all();
    return jsonResponse(result);
  }

  Future<Response> show(@param int userId) async {
    final user = await userSvc.getUser(userId);
    if (user == null) return notFound('User not found');
    return jsonResponse(user);
  }
}
