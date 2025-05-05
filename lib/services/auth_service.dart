import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final supabase = Supabase.instance.client;

  // Sign up with email OTP
  static Future<void> signUpWithOTP(String email) async {
    try {
      await supabase.auth.signInWithOtp(email: email, emailRedirectTo: null);
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  // Sign in with email OTP
  static Future<void> signInWithOTP(String email) async {
    try {
      await supabase.auth.signInWithOtp(email: email, emailRedirectTo: null);
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  // Verify OTP
  static Future<AuthResponse> verifyOTP(
    String email,
    String otp, {
    bool isSignUp = false,
  }) async {
    try {
      final response = await supabase.auth.verifyOTP(
        email: email,
        token: otp,
        type: isSignUp ? OtpType.signup : OtpType.magiclink,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  // Create or update user profile
  static Future<void> createUserProfile({
    required String userId,
    required String nickname,
    required String gender,
    required DateTime birthday,
    required List<String> interests,
  }) async {
    try {
      await supabase.from('buyers').upsert({
        'id': userId,
        'nickname': nickname,
        'gender': gender,
        'date_of_birth': birthday.toIso8601String(),
        'interests': interests,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to create/update user profile: $e');
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  // Get current user
  static User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  // Get user profile
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response =
          await supabase.from('buyers').select().eq('id', userId).single();
      return response;
    } catch (e) {
      return null;
    }
  }

  // Check if user exists
  static Future<bool> checkUserExists(String email) async {
    try {
      final response =
          await supabase
              .from('buyers')
              .select()
              .eq('email', email)
              .maybeSingle();
      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Update user interests
  static Future<void> updateUserInterests(
    String userId,
    List<String> interests,
  ) async {
    try {
      await supabase
          .from('buyers')
          .update({
            'interests': interests,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update interests: $e');
    }
  }
}
