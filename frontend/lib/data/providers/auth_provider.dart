import 'dart:async';

import 'package:frontend/data/services.dart';
import 'package:frontend/utils/provider.dart';
import 'package:meta/meta.dart';

import '../models/user.dart';

class AuthProvider extends BaseProvider<User> {
  @visibleForTesting
  ApiService get apiSvc => getIt.get<ApiService>();

  Future<void> login(String email, String password) async {
    final user = await _safeRun(() => apiSvc.loginUser(email, password));
    if (user == null) return;

    addEvent(ProviderEvent.success(data: user));
  }

  Future<void> register(String displayName, String email, String password) async {
    final success = await _safeRun(() => apiSvc.registerUser(displayName, email, password));
    if (success != true) return;

    addEvent(const ProviderEvent.idle());
  }

  Future<T?> _safeRun<T>(FutureOr<T> Function() apiCall) async {
    addEvent(const ProviderEvent.loading());

    try {
      return await apiCall.call();
    } on ApiException catch (e) {
      addEvent(ProviderEvent.error(message: e.errors.join('\n')));
      return null;
    }
  }
}
