import 'package:backend/src/models.dart';
import 'package:pharaoh/pharaoh_next.dart';
import 'package:shared/models.dart';

class UserController extends HTTPController {
  Future<Response> currentUser() async {
    final user = request.auth as User;
    return jsonResponse({'user': user.toJson()});
  }

  Future<Response> index() async {
    final result = await ServerUserQuery.findMany();
    return jsonResponse(result);
  }

  Future<Response> show(@param int userId) async {
    final user = await ServerUserQuery.findById(userId);
    if (user == null) return notFound('User not found');
    return jsonResponse({'user': user.toJson()});
  }
}
