import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/supabase_auth_repository.dart';
import '../domain/auth_repository.dart';

/// Auth repository provider.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return SupabaseAuthRepository();
});

/// Stream of auth state changes — drives router redirects.
final authStateProvider = StreamProvider<bool>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

/// Synchronous check of current login status.
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authRepositoryProvider).isLoggedIn;
});

/// Current user ID (needed to scope data per user).
final currentUserIdProvider = Provider<String?>((ref) {
  // Re-evaluate when auth state changes
  ref.watch(authStateProvider);
  return ref.watch(authRepositoryProvider).currentUserId;
});

/// Notifier for login/signup/logout actions.
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<bool>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<bool>> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(AsyncValue.data(_repo.isLoggedIn));

  Future<String?> login(String email, String password) async {
    state = const AsyncValue.loading();
    final error = await _repo.login(email, password);
    state = AsyncValue.data(error == null);
    return error;
  }

  Future<String?> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    final error = await _repo.signUp(email, password);
    state = AsyncValue.data(error == null);
    return error;
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncValue.data(false);
  }
}

