import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlaceholderService {
  static Future<String?> preloadPlaceholderUrl(BuildContext context, String buyerId) async {
    try {
      final supabase = SupabaseClient(
        "https://oetruvmloogtbbrdjeyc.supabase.co",
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ldHJ1dm1sb29ndGJicmRqZXljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc5ODkxOTQsImV4cCI6MjA1MzU2NTE5NH0.75FTVi-mQT8JEMIdqNTkN7--Hg1GCuqFydrBnmYzl0o", // anon key
      );

      final personResponse = await supabase
          .from('photos')
          .select('photo_url')
          .eq('buyer_id', buyerId)
          .single();

      if (personResponse != null && personResponse['photo_url'] != null) {
        String placeholderUrl = personResponse['photo_url'];
        placeholderUrl = "https://oetruvmloogtbbrdjeyc.supabase.co/storage/v1/object/public/$placeholderUrl";
        await precacheImage(NetworkImage(placeholderUrl), context); // Preload the image
        print("placeholder URL preloaded: $placeholderUrl");
        return placeholderUrl;
      } else {
        print("No placeholder URL found for buyer_id: $buyerId");
        return null;
      }
    } catch (e) {
      print("Error fetching placeholder URL: $e");
      return null;
    }
  }
}