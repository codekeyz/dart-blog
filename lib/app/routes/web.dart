import 'package:yaroo/http/http.dart';
import 'package:yaroo/yaroo.dart';

final routes = <RouteDefinition>[
  /// Home Page
  Route.handler(HTTPMethod.GET, '/', (req, res) {
    return res.render('welcome', {'app_name': 'Yaroo', 'app_version': '1.0.0'});
  }),

  /// Not Found Page
  Route.notFound((req, res) => res.render('404')),
];
