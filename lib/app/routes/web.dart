import 'package:pharaoh/next/http.dart';
import 'package:pharaoh/next/router.dart';

final routes = <RouteDefinition>[
  Route.route(HTTPMethod.GET, '/', (req, res) => res.ok('Hello World 🤘')),
];
