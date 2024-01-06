import 'dart:async';

import 'package:frontend/data/services.dart';
import 'package:frontend/utils/provider.dart';
import 'package:meta/meta.dart';

import '../models/user.dart';

class AuthProvider extends BaseProvider<User> {
  @visibleForTesting
  ApiService get apiSvc => getIt.get<ApiService>();

  User? get user => lastEvent?.data;

  Future<void> getUser() async {
    if (!apiSvc.hasAuthCookie) return;

    final user = await safeRun(() => apiSvc.getUser());
    if (user == null) return;

    addEvent(ProviderEvent.success(data: user));
  }

  Future<void> login(String email, String password) async {
    final user = await safeRun(() => apiSvc.loginUser(email, password));
    if (user == null) return;

    addEvent(ProviderEvent.success(data: user));
  }

  Future<bool> register(String displayName, String email, String password) async {
    final success = await safeRun(() => apiSvc.registerUser(displayName, email, password));
    if (success != true) return false;

    addEvent(const ProviderEvent.idle());
    return true;
  }

  void logout() {
    apiSvc.clearAuthCookie();
    addEvent(const ProviderEvent.idle());
  }
}
