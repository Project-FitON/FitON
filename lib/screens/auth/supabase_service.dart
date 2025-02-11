import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Check if user exists
  Future<bool> checkUserExists(String phone) async {
    final response = await _client
        .from('buyers')
        .select()
        .eq('phone_number', phone)
        .maybeSingle();
    return response != null;
  }

  // Create new buyer
  Future<Map<String, dynamic>> createBuyer(String phone) async {
    final response = await _client
        .from('buyers')
        .insert({'phone_number': phone})
        .select()
        .single();

    print(response);
    return response;
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

  Future<bool> verifyOtp(String phone, String otp) async {
    return true;
  }
}