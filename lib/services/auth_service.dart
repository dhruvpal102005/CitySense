import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

  /// Get the current user
  static User? get currentUser => _supabase.auth.currentUser;

  /// Check if user is signed in
  static Future<bool> isSignedIn() async {
    return _supabase.auth.currentSession != null;
  }

  /// Sign in with email and password
  static Future<AuthResponse> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      debugPrint('Sign in successful: ${response.user?.email}');
      return response;
    } catch (e) {
      debugPrint('Sign in error: $e');
      rethrow;
    }
  }

  /// Sign up with email and password
  static Future<AuthResponse> signUpWithEmail(
    String email,
    String password, {
    String? name,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: name != null ? {'full_name': name} : null,
      );
      debugPrint('Sign up successful: ${response.user?.email}');
      return response;
    } catch (e) {
      debugPrint('Sign up error: $e');
      rethrow;
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      debugPrint('Sign out successful');
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  /// Get user display name
  static String? getDisplayName() {
    final user = currentUser;
    if (user == null) return null;

    final metadata = user.userMetadata;
    if (metadata != null) {
      return metadata['full_name'] as String? ??
          metadata['name'] as String? ??
          user.email?.split('@').first;
    }
    return user.email?.split('@').first;
  }

  /// Get user email
  static String? getEmail() {
    return currentUser?.email;
  }

  /// Get user photo URL
  static String? getPhotoUrl() {
    final metadata = currentUser?.userMetadata;
    if (metadata != null) {
      return metadata['avatar_url'] as String? ??
          metadata['picture'] as String?;
    }
    return null;
  }

  /// Get first name
  static String getFirstName() {
    final displayName = getDisplayName();
    if (displayName != null) {
      return displayName.split(' ').first;
    }
    if (currentUser?.email != null) {
      return currentUser!.email!.split('@').first;
    }
    return 'there';
  }

  /// Listen to auth state changes
  static Stream<AuthState> get onAuthStateChange {
    return _supabase.auth.onAuthStateChange;
  }
}
