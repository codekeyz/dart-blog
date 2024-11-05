import 'dart:async';

import 'package:frontend/data/api_service.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils/provider.dart';
import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';
import 'package:shared/models.dart';

class AuthProvider extends BaseProvider<User> {
  @visibleForTesting
  ApiService get apiSvc => getIt.get<ApiService>();

  final LocalStorage _userLocalStore = LocalStorage('user_session_store');
  static const String userStorageKey = 'user_data';

  User? get user {
    final userFromState = lastEvent?.data;
    if (userFromState != null) return userFromState;
    final serializedUser = _userLocalStore.getItem(userStorageKey);
    return serializedUser == null ? null : User.fromJson(serializedUser);
  }

  Future<void> getUser() async {
    if (!apiSvc.hasAuthCookie) return;

    final user = await safeRun(() => apiSvc.getUser());
    if (user == null) return;

    _setUser(user);
  }

  Future<void> login(String email, String password) async {
    final user = await safeRun(() => apiSvc.loginUser(email, password));
    if (user == null) return;

    _setUser(user);
  }

  Future<bool> register(String displayName, String email, String password) async {
    final success = await safeRun(() => apiSvc.registerUser(displayName, email, password));
    if (success != true) return false;

    addEvent(const ProviderEvent.idle());
    return true;
  }

  void _setUser(User user) {
    addEvent(ProviderEvent.success(data: user));

    _userLocalStore.setItem(userStorageKey, user.toJson());
  }

  void logout() {
    apiSvc.clearAuthCookie();
    _userLocalStore.clear();
    addEvent(const ProviderEvent.idle());
  }
}
