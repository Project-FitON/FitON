import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/user_model.dart';
import 'dart:convert';

class UserService {
  final _supabase = Supabase.instance.client;

  // Get current user from Supabase and buyers table
  Future<User?> getCurrentUser() async {
    try {
      final supaUser = _supabase.auth.currentUser;
      print('Auth check - Current user: ${supaUser?.toJson()}');

      if (supaUser == null) {
        print('No authenticated user found');
        return null;
      }

      print('Fetching buyer with ID: ${supaUser.id}');

      // Get buyer data
      var response =
          await _supabase
              .from('buyers')
              .select('*')
              .eq('buyer_id', supaUser.id)
              .maybeSingle();

      print('Raw buyer data received: $response');

      if (response == null) {
        print('No buyer profile found, creating one...');
        // Create a buyer profile if it doesn't exist
        final newBuyer = {
          'buyer_id': supaUser.id,
          'nickname': supaUser.email?.split('@')[0] ?? 'User',
          'email': supaUser.email,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'interests': [],
          'recommendation_opt_out': false,
        };

        await _supabase.from('buyers').upsert(newBuyer);
        print('Created new buyer profile: $newBuyer');
        response = newBuyer;
      }

      final user = User(
        id: response['buyer_id'],
        name: response['nickname'] ?? 'User',
        email: response['email'] ?? '',
        profileImageUrl:
            null, // Add profile image field to buyers table if needed
        planType:
            'Standard Plan', // You can add a plan_type field to buyers if needed
        createdAt: DateTime.parse(response['created_at']),
      );

      print('Returning user object: ${user.toMap()}');
      return user;
    } catch (e, stackTrace) {
      print('Error getting user: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  // Update user profile in buyers table
  Future<void> updateUser(User updatedUser) async {
    try {
      await _supabase.from('buyers').upsert({
        'buyer_id': updatedUser.id,
        'nickname': updatedUser.name,
        'email': updatedUser.email,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating user: $e');
      throw Exception('Failed to update user profile');
    }
  }

  // Check if buyers table exists and has correct structure
  Future<void> checkBuyersTable() async {
    try {
      print('Checking buyers table structure...');

      final response = await _supabase.from('buyers').select().limit(1);

      print('Buyers table exists and is accessible');
      print('Sample buyer data: $response');
    } catch (e) {
      print('Error checking buyers table: $e');
      print(
        'Please ensure your Supabase database has a buyers table with columns:',
      );
      print('- buyer_id (uuid, primary key)');
      print('- nickname (varchar)');
      print('- email (varchar)');
      print('- phone_number (varchar)');
      print('- date_of_birth (date)');
      print('- gender (varchar)');
      print('- interests (text[])');
      print('- address (text)');
      print('- created_at (timestamp)');
      print('- updated_at (timestamp)');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
