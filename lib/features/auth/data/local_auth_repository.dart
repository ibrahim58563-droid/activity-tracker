import 'package:shared_preferences/shared_preferences.dart';
import '../domain/auth_repository.dart';

/// Local auth implementation using SharedPreferences.
/// Replace with FirebaseAuth when ready — no UI changes needed.
class LocalAuthRepository implements AuthRepository {
  static const _emailKey = 'auth_email';
  static const _loggedInKey = 'auth_logged_in';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _storage async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<bool> get isLoggedIn async {
    final prefs = await _storage;
    return prefs.getBool(_loggedInKey) ?? false;
  }

  @override
  Future<bool> login(String email, String password) async {
    // MVP: accept any non-empty credentials
    if (email.trim().isEmpty || password.trim().isEmpty) return false;
    final prefs = await _storage;
    await prefs.setString(_emailKey, email.trim());
    await prefs.setBool(_loggedInKey, true);
    return true;
  }

  @override
  Future<void> logout() async {
    final prefs = await _storage;
    await prefs.remove(_emailKey);
    await prefs.setBool(_loggedInKey, false);
  }

  @override
  Future<String?> get currentUserEmail async {
    final prefs = await _storage;
    return prefs.getString(_emailKey);
  }
}
