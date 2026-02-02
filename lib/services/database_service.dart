import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:latlong2/latlong.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> submitReport({
    required File image,
    required LatLng location,
    String? description,
    required String address,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    try {
      // 1. Upload Image to Storage
      final String fileName =
          '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String path = await _supabase.storage
          .from('waste-images')
          .upload(
            fileName,
            image,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );

      // Get public URL (assuming bucket is public or we use signed URLs, using public for now)
      final String imageUrl = _supabase.storage
          .from('waste-images')
          .getPublicUrl(fileName);

      // 2. Insert Record into Database
      await _supabase.from('report').insert({
        'user_id': userId,
        'image_url': imageUrl,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'address': address,
        'description': description,
        'status': 'reported', // Default status
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Database Error: $e');
      throw Exception('Failed to submit report: $e');
    }
  }
}
