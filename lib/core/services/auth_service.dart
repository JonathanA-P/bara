import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService {
  final SupabaseService _service;

  AuthService({SupabaseService? service}) : _service = service ?? SupabaseService.instance;

  SupabaseClient? get _client => _service.client;

  bool get isAuthenticated => _client?.auth.currentSession != null;

  User? get currentUser => _client?.auth.currentUser;

  Future<AuthResponse?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String nim,
    required String major,
    String role = 'mentee',
  }) async {
    final client = _client;
    if (client == null) {
      // Mock mode fallback
      return null;
    }

    return await client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'nim': nim,
        'major': major,
        'role': role,
      },
    );
  }

  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    final client = _client;
    if (client == null) return null;

    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse?> verifyOtp({
    required String email,
    required String token,
    OtpType type = OtpType.signup,
  }) async {
    final client = _client;
    if (client == null) return null;

    return await client.auth.verifyOTP(
      email: email,
      token: token,
      type: type,
    );
  }

  Future<void> resendOtp({
    required String email,
    OtpType type = OtpType.signup,
  }) async {
    final client = _client;
    if (client == null) return;

    await client.auth.resend(
      email: email,
      type: type,
    );
  }

  Future<void> signOut() async {
    final client = _client;
    if (client == null) return;
    await client.auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final client = _client;
    if (client == null) return;
    await client.auth.resetPasswordForEmail(email);
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final client = _client;
    if (client == null) return null;

    final response = await client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    return response;
  }

  Future<void> updateProfile({
    required String fullName,
    String? bio,
    String? major,
    String? avatarUrl,
  }) async {
    final client = _client;
    final userId = _service.currentUserId;
    if (client == null || userId == null) return;

    final Map<String, dynamic> data = {
      'full_name': fullName,
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (bio != null) data['bio'] = bio;
    if (major != null) data['major'] = major;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;

    await client.from('profiles').update(data).eq('id', userId);
  }
}

