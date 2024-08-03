import 'package:pharaoh/pharaoh_next.dart';

import '../models/user/user.dart';

class UserController extends HTTPController {
  UserController();

  Future<Response> currentUser() async {
    final user = request.auth as User;
    return jsonResponse({'user': user.toJson()});
  }

  Future<Response> index() async {
    final result = await UserQuery.findMany();
    return jsonResponse(result);
  }

  Future<Response> show(@param int userId) async {
    final user = await UserQuery.findById(userId);
    if (user == null) return notFound('User not found');
    return jsonResponse({'user': user.toJson()});
  }
}
