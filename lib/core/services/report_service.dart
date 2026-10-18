import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class ReportService {
  final SupabaseService _service;

  ReportService({SupabaseService? service}) : _service = service ?? SupabaseService.instance;

  SupabaseClient? get _client => _service.client;

  Future<bool> submitReport({
    required String accusedName,
    required String category,
    required DateTime incidentDate,
    required String description,
    List<String> evidenceUrls = const [],
  }) async {
    final client = _client;
    final reporterId = _service.currentUserId;
    if (client == null || reporterId == null) {
      // Offline / mock success
      return true;
    }

    try {
      await client.from('incident_reports').insert({
        'reporter_id': reporterId,
        'accused_name': accusedName,
        'category': category,
        'incident_date': incidentDate.toIso8601String().split('T').first,
        'description': description,
        'evidence_urls': evidenceUrls,
        'status': 'pending',
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getMyReports() async {
    final client = _client;
    final reporterId = _service.currentUserId;
    if (client == null || reporterId == null) return [];

    final response = await client
        .from('incident_reports')
        .select()
        .eq('reporter_id', reporterId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}

