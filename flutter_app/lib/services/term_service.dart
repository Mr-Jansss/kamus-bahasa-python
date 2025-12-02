// lib/services/term_service.dart
import 'api_service.dart';

class TermService {
  final ApiService api = ApiService();

  Future<List> getAllTerms([String? q]) async {
    final path = q != null && q.isNotEmpty
        ? '/terms?q=${Uri.encodeComponent(q)}'
        : '/terms';
    final res = await api.get(path);
    return res is List ? res : [];
  }

  Future addTerm(Map data) async {
    return await api.postWithAuth('/terms', data);
  }

  Future updateTerm(int id, Map data) async {
    return await api.putWithAuth('/terms/$id', data);
  }

  Future deleteTerm(int id) async {
    return await api.deleteWithAuth('/terms/$id');
  }
}
