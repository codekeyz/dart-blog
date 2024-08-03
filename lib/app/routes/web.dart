import 'package:pharaoh/pharaoh_next.dart';

final routes = <RouteDefinition>[
  Route.route(HTTPMethod.GET, '/', (req, res) => res.ok('Hello World 🤘')),
];
