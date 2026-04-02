import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/auth_repository.dart';

/// Supabase implementation of [AuthRepository].
class SupabaseAuthRepository implements AuthRepository {
  SupabaseClient get _client => Supabase.instance.client;

  @override
  bool get isLoggedIn => _client.auth.currentSession != null;

  @override
  String? get currentUserId => _client.auth.currentUser?.id;

  @override
  String? get currentUserEmail => _client.auth.currentUser?.email;

  @override
  Future<String?> login(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<String?> signUp(String email, String password) async {
    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );
      // If email confirmation is required, user will be non-null but session may be null
      if (response.user != null) return null;
      return 'Sign up failed. Please try again.';
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  @override
  Stream<bool> get authStateChanges {
    return _client.auth.onAuthStateChange.map(
      (data) => data.session != null,
    );
  }
}
