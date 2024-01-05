import 'package:backend/app/http/middlewares/core_middleware.dart';
import 'package:yaroo/http/kernel.dart' as prefix01;

import 'middlewares/api_auth_middleware.dart';
import 'middlewares/serve_static_middleware.dart';

class Kernel extends prefix01.Kernel {
  @override
  List<Type> get middleware => [CoreMiddleware];

  @override
  Map<String, List<Type>> get middlewareGroups => {
        'web': [ServeStaticMiddleware],
        'auth:api': [ApiAuthMiddleware],
      };
}
