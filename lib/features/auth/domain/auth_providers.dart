import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/local_auth_repository.dart';
import '../domain/auth_repository.dart';

/// Auth repository provider — swap implementation here.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return LocalAuthRepository();
});

/// Current auth state.
final authStateProvider = FutureProvider<bool>((ref) {
  return ref.watch(authRepositoryProvider).isLoggedIn;
});

/// Notifier for login/logout actions.
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<bool>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<bool>> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AsyncValue.data(false)) {
    _checkState();
  }

  Future<void> _checkState() async {
    state = const AsyncValue.loading();
    try {
      final loggedIn = await _repo.isLoggedIn;
      state = AsyncValue.data(loggedIn);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final success = await _repo.login(email, password);
      state = AsyncValue.data(success);
      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncValue.data(false);
  }
}
