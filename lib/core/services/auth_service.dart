import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService {
  final SupabaseService _service;

  AuthService({SupabaseService? service})
      : _service = service ?? SupabaseService.instance;

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
      return null;
    }

    try {
      await client.auth.admin.createUser(
        AdminUserAttributes(
          email: email,
          password: password,
          emailConfirm: true,
          userMetadata: {
            'full_name': fullName,
            'nim': nim,
            'major': major,
            'role': role,
          },
        ),
      );
    } catch (_) {
      try {
        await client.auth.signUp(
          email: email,
          password: password,
          data: {
            'full_name': fullName,
            'nim': nim,
            'major': major,
            'role': role,
          },
        );
      } catch (_) {}
    }

    final authRes = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final uid = authRes.user?.id ?? _service.currentUserId;
    if (uid != null) {
      await client.from('profiles').upsert({
        'id': uid,
        'email': email,
        'full_name': fullName,
        'nim': nim,
        'major': major,
        'role': role,
        'bio': 'Mahasiswa $major FILKOM Universitas Brawijaya',
      });
    }

    return authRes;
  }

  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    final client = _client;
    if (client == null) return null;

    final res = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = res.user;
    if (user != null) {
      final existing = await getProfile(user.id);
      if (existing == null) {
        final meta = user.userMetadata ?? {};
        final fallbackName = (meta['full_name'] as String?) ??
            (user.email?.split('@').first ?? 'Mahasiswa FILKOM');
        await client.from('profiles').upsert({
          'id': user.id,
          'email': user.email ?? email,
          'full_name': fallbackName,
          'nim': (meta['nim'] as String?) ??
              '235150${DateTime.now().millisecondsSinceEpoch % 1000000000}',
          'major': (meta['major'] as String?) ?? 'Teknik Informatika',
          'role': (meta['role'] as String?) ?? 'mentee',
          'bio': 'Mahasiswa FILKOM Universitas Brawijaya',
        });
      }
    }

    return res;
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

  Future<List<Map<String, dynamic>>> getAllProfiles() async {
    final client = _client;
    if (client == null) return [];

    final response = await client
        .from('profiles')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getAllFollowSwipes() async {
    final client = _client;
    if (client == null) return [];

    final response = await client
        .from('mentor_swipes')
        .select()
        .eq('action', 'like');

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> setFollowInDb({
    required String followerId,
    required String targetUserId,
    required bool follow,
  }) async {
    final client = _client;
    if (client == null) return;

    if (follow) {
      await client.from('mentor_swipes').upsert({
        'mentee_id': followerId,
        'mentor_id': targetUserId,
        'action': 'like',
      }, onConflict: 'mentee_id,mentor_id');
    } else {
      await client
          .from('mentor_swipes')
          .delete()
          .eq('mentee_id', followerId)
          .eq('mentor_id', targetUserId);
    }
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
