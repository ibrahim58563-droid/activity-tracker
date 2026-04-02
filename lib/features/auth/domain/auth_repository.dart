/// Simple auth state — MVP uses local auth, easily swappable to Firebase.
abstract class AuthRepository {
  Future<bool> get isLoggedIn;
  Future<bool> login(String email, String password);
  Future<void> logout();
  Future<String?> get currentUserEmail;
}
