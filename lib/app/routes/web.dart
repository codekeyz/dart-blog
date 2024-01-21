import 'package:yaroo/http/http.dart';
import 'package:yaroo/yaroo.dart';

const _allowedRoutes = ['/docs', '/swagger.json'];

final routes = <RouteDefinition>[
  /// setup api documentation
  Route.use('/', (req, res, next) {
    if (req.method != HTTPMethod.GET && !_allowedRoutes.contains(req.path)) {
      return next(res.notFound());
    }

    return useAliasedMiddleware('api:docs')(req, res, next);
  }),
];
