import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Check if user exists
  Future<bool> checkUserExists(String email) async {
    final response = await _client
        .from('buyers')
        .select()
        .eq('email', email) 
        .maybeSingle();
    return response != null;
  }

  // Create new buyer
  Future<Map<String, dynamic>> createBuyer(String email) async {
    final response = await _client
        .from('buyers')
        .insert({'email': email}) 
        .select()
        .single();

    print(response);
    return response;
  }

  // Send OTP to email
  Future<void> sendEmailOtp(String email) async {
    await _client.auth.signInWithOtp(
      email: email,
    );
  }

  // Verify OTP
  Future<bool> verifyOtp(String email, String otp) async {
    final response = await _client.auth.verifyOTP(
      email: email,
      token: otp,
      type: OtpType.signup, 
    );

    // Check if the OTP verification was successful
    return response.session != null;
  }

  // Create dependant
  Future<void> createDependant({
    required String buyerId,
    required String nickname,
    required String gender,
    required DateTime birthday,
    required List<String> interests,
  }) async {
    await _client.from('dependants').insert({
      'buyer_id': buyerId,
      'nickname': nickname,
      'gender': gender,
      'date_of_birth': birthday.toIso8601String(),
      'interests': interests,
    });
  }
}