import 'package:frontend/data/api_service.dart';
import 'package:get_it/get_it.dart';

export 'api_service.dart';

final getIt = GetIt.instance;

void setupServices() {
  getIt.registerSingleton<ApiService>(const ApiService('http://localhost:3000'));
}
