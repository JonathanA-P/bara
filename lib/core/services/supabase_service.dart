import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseService._();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  SupabaseClient? get client {
    if (!_isInitialized) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  /// Initialize Supabase strictly from `.env` (never hardcode keys in source code).
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      String url = '';
      String anonKey = '';

      try {
        await dotenv.load(fileName: '.env');
        url = dotenv.env['SUPABASE_URL']?.trim() ?? '';
        anonKey = dotenv.env['SUPABASE_ANON_KEY']?.trim() ?? '';
      } catch (_) {
        try {
          final file = io.File('.env');
          if (file.existsSync()) {
            final lines = await file.readAsLines();
            for (final line in lines) {
              if (line.startsWith('SUPABASE_URL=')) {
                url = line.substring('SUPABASE_URL='.length).trim();
              } else if (line.startsWith('SUPABASE_ANON_KEY=')) {
                anonKey = line.substring('SUPABASE_ANON_KEY='.length).trim();
              }
            }
          }
        } catch (_) {}
      }

      if (url.isNotEmpty && anonKey.isNotEmpty && url.startsWith('http')) {
        await Supabase.initialize(
          url: url,
          anonKey: anonKey,
        );
        _isInitialized = true;
        debugPrint('[Hi!Gavi Supabase] Connected successfully to $url');
      } else {
        debugPrint(
          '[Hi!Gavi Supabase] .env not found or empty. Running in hybrid local mode.',
        );
      }
    } catch (e) {
      debugPrint(
        '[Hi!Gavi Supabase] Init error: $e. Running in hybrid local mode.',
      );
      _isInitialized = false;
    }
  }

  /// Helper to get current authenticated user id
  String? get currentUserId => client?.auth.currentUser?.id;
}
