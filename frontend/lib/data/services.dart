import 'package:frontend/data/api_service.dart';
import 'package:get_it/get_it.dart';

export 'api_service.dart';

final getIt = GetIt.instance;

void setupServices() {
  var apiEndpoint = const String.fromEnvironment('Endpoint');
  if (apiEndpoint.trim().isEmpty) apiEndpoint = 'http://localhost:3000';

  getIt.registerSingleton<ApiService>(ApiService(apiEndpoint));
}
