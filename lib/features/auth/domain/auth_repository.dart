/// Auth repository interface — Supabase implementation.
abstract class AuthRepository {
  bool get isLoggedIn;
  String? get currentUserId;
  String? get currentUserEmail;

  Future<String?> login(String email, String password);
  Future<String?> signUp(String email, String password);
  Future<void> logout();

  /// Stream of auth state changes (true = logged in).
  Stream<bool> get authStateChanges;
}

