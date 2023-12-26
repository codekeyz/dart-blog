import 'package:yaroo/http/kernel.dart' as prefix01;

import 'middlewares/auth_middleware.dart';

class Kernel extends prefix01.Kernel {
  @override
  Map<String, List<Type>> get middlewareGroups => {
        'api': [AuthMiddleware],
        'web': [AuthMiddleware]
      };
}
