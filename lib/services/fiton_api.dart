import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase/supabase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String?> processFitOnRequest(String buyerId, String productId, String? dependentId) async {
  final String buyer_id = buyerId;
  final String product_id = productId;
  final String? dependent_id = dependentId;
  String? owner;
  String? owner_id;

  // Check for the correct owner
  if (dependent_id == null) {
    owner = "buyer_id";
    owner_id = buyerId;
  } else {
    owner = "dependent_id";
    owner_id = dependent_id;
  }

  // Initialize Supabase
  final supabase = SupabaseClient(
    "https://oetruvmloogtbbrdjeyc.supabase.co",
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ldHJ1dm1sb29ndGJicmRqZXljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc5ODkxOTQsImV4cCI6MjA1MzU2NTE5NH0.75FTVi-mQT8JEMIdqNTkN7--Hg1GCuqFydrBnmYzl0o", // anon key
  );

  // Call the main function
  try {
    print("Fetching buyer image...");
    final personResponse = await supabase
        .from('photos')
        .select('photo_url, photo_id')
        .eq(owner!, owner_id!)
        .single();
    print("Buyer image fetched: ${personResponse['photo_url']}");

    print("Fetching product image...");
    final productResponse = await supabase
        .from('products')
        .select('images')
        .eq('product_id', product_id)
        .single();
    print("Product image fetched: ${productResponse['images'][0]}");

    print("Data fetched successfully!");

    if (!productResponse.containsKey('images') || productResponse['images'].isEmpty) {
      print("Error: No product images found.");
      return null;
    }

    // Extract data
    String inputPhotoId = personResponse['photo_id'];
    String personImagePath = personResponse['photo_url'];
    String productImagePath = productResponse['images'][0];

    String personImageUrl =
        "https://oetruvmloogtbbrdjeyc.supabase.co/storage/v1/object/public/$personImagePath";
    String productImageUrl =
        "https://oetruvmloogtbbrdjeyc.supabase.co/storage/v1/object/public/$productImagePath";

    print("Person Image URL: $personImageUrl");
    print("Product Image URL: $productImageUrl");

    // Call the API
    print("Calling FitON API...");
    String? generatedUrl = await callFitONAPI(buyer_id, product_id, dependent_id, personImageUrl, productImageUrl, inputPhotoId, supabase, owner!, owner_id!);
    print("Generated URL: $generatedUrl");
    return generatedUrl;
  } catch (e) {
    print("Error in main: $e");
    return null;
  }
}

Future<String?> callFitONAPI(
    String buyer_id,
    String product_id,
    String? dependent_id,
    String personImageUrl,
    String productImageUrl,
    String inputPhotoId,
    SupabaseClient supabase,
    String owner,
    String ownerId) async {
  final String apiUrl = "https://dilshaniru-fiton-api.hf.space/call/submit_function";
  await dotenv.load();
  final String? hfToken = dotenv.env['HUGGINGFACE_TOKEN'];
  print("Token is: $hfToken"); // Debugging only

  final List<dynamic> requestData = [
    {"background": {"path": personImageUrl}, "layers": [], "composite": null},
    {"path": productImageUrl},
    "overall",
    50,
    2.5,
    42,
    "result only"
  ];

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $hfToken",
    },
    body: jsonEncode({"data": requestData}),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    final String eventId = jsonResponse["event_id"] ?? "";

    if (eventId.isNotEmpty) {
      final String resultUrl = "$apiUrl/$eventId";

      // Fetch the generated image
      final resultResponse = await http.get(Uri.parse(resultUrl));
      if (resultResponse.statusCode == 200) {
        try {
          // Extract only the valid JSON from response
          String responseBody = resultResponse.body.trim();

          // Find the start and end of the actual JSON object
          int jsonStart = responseBody.indexOf("{");
          int jsonEnd = responseBody.lastIndexOf("}");

          if (jsonStart != -1 && jsonEnd != -1) {
            responseBody = responseBody.substring(jsonStart, jsonEnd + 1);
          } else {
            throw FormatException("No valid JSON found in response.");
          }

          final Map<String, dynamic> resultJson = jsonDecode(responseBody);

          if (resultJson.containsKey("url")) {
            String generatedUrl = resultJson["url"].replaceFirst("call/subm/", "");

            // Immediately return the generated URL to the caller
            print("Generated URL: $generatedUrl");

            // Run storage and database tasks in the background
            Future.microtask(() async {
              try {
                print("Uploading to Supabase...");
                String uploadedUrl = await uploadToSupabaseStorage(
                    buyer_id, product_id, dependent_id, generatedUrl, supabase, owner, ownerId);

                if (uploadedUrl.isNotEmpty) {
                  print("Successfully uploaded to Supabase Storage: $uploadedUrl");

                  // Store in database
                  await storeTryonData(buyer_id, product_id, dependent_id, supabase, inputPhotoId,
                      uploadedUrl, owner, ownerId);
                }
              } catch (e) {
                print("Error in background tasks: $e");
              }
            });

            return generatedUrl; // Return the generated URL immediately
          } else {
            print("Error: No valid image URL found in response.");
          }
        } catch (e) {
          print("JSON Parsing Error: $e");
        }
        return null;
      } else {
        print("Failed to get result: ${resultResponse.statusCode}");
      }
    } else {
      print("Error: Event ID not received");
    }
  } else {
    print("Failed to call API: ${response.statusCode}");
  }
  return null;
}

// Upload the generated image to Supabase Storage
Future<String> uploadToSupabaseStorage(String buyer_id, String product_id, String? dependent_id, String imageUrl, SupabaseClient supabase, String owner, String ownerId) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      String fileName = "tryon_${DateTime.now().millisecondsSinceEpoch}.webp";

      // Upload to Supabase Storage
      if (dependent_id == null) {
        // Upload to buyer's folder
        final storageResponse = await supabase.storage
            .from('fiton')
            .uploadBinary('tryons/$buyer_id/$fileName', response.bodyBytes, fileOptions: FileOptions(contentType: "image/webp"));
        return "https://oetruvmloogtbbrdjeyc.supabase.co/storage/v1/object/public/fiton/tryons/$buyer_id/$fileName";
            } else {
        // Upload to dependent's folder
        final storageResponse = await supabase.storage
          .from('fiton')
          .uploadBinary('tryons/$buyer_id/$dependent_id/$fileName', response.bodyBytes, fileOptions: FileOptions(contentType: "image/webp"));
        return "https://oetruvmloogtbbrdjeyc.supabase.co/storage/v1/object/public/fiton/tryons/$buyer_id/$dependent_id/$fileName";
            }

    } else {
      print("Failed to download image for upload. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error uploading image to Supabase: $e");
  }
  return "";
}

// Store the generated image URL in the database
Future<void> storeTryonData(String buyer_id, String product_id, String? dependent_id, SupabaseClient supabase, String inputPhotoId, String generatedTryonUrl, String owner, String ownerId) async {
  try {
    // Step 1: Check if a record with the same buyer_id and dependent_id exists
    final existingRecord = await supabase
        .from('tryons')
        .select('tryon_id, generated_tryons')
        .eq(owner, ownerId) // Ensure correct column name
        .maybeSingle(); // Prevents error if no record exists

    if (existingRecord != null) {
      // Step 2: If record exists, update the existing `generated_tryons` array
      List<dynamic> currentImages = existingRecord['generated_tryons'] ?? [];

      // Step 3: Add the new image URL if it's not already in the list
      if (!currentImages.contains(generatedTryonUrl)) {
        currentImages.add(generatedTryonUrl);

        // Step 4: Update the record in Supabase
        final updateResponse = await supabase
            .from('tryons')
            .update({'generated_tryons': currentImages})
            .eq('tryon_id', existingRecord['tryon_id'])
            .select(); // Select ensures a valid response

        if (updateResponse.isNotEmpty) {
          print("Successfully updated try-on record with new image.");
        } else {
          print("Error updating try-on record: Update response is null or empty");
        }
      } else {
        print("Image already exists in the array, skipping update.");
      }
    } else {
      // Step 5: If no record exists, insert a new row
      final insertResponse = await supabase.from('tryons').insert({
        "buyer_id": buyer_id,
        "dependent_id": dependent_id,
        "product_id": product_id,
        "input_photo_id": inputPhotoId,
        "generated_tryons": [generatedTryonUrl], // Store as an array
      }).select();

      if (insertResponse.isNotEmpty) {
        print("Try-on record inserted successfully!");
      } else {
        print("Error inserting try-on record: Insert response is null or empty");
      }
    }
  } catch (e) {
    print("Error storing try-on data: $e");
  }
}
