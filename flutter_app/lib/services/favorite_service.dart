// lib/services/favorite_service.dart
import 'api_service.dart';

class FavoriteService {
  final ApiService api = ApiService();

  Future addFavorite(int termId) async {
    return await api.postWithAuth('/favorites', {'term_id': termId});
  }

  Future getFavorites() async {
    return await api.postWithAuth('/favorites/list', {});
  }

  Future deleteFavorite(int id) async {
    return await api.postWithAuth('/favorites/delete', {'id': id});
  }
}
