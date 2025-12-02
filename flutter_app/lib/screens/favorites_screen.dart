// lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../models/favorite_model.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoriteService _fav = FavoriteService();
  List<Favorite> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    setState(() => loading = true);
    try {
      final res = await _fav.getFavorites();
      setState(() {
        items = (res as List).map((j) => Favorite.fromJson(j)).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  void _delete(int id) async {
    try {
      await _fav.deleteFavorite(id);
      _load();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const pythonBlue = Color(0xFF306998);
    const pythonYellow = Color(0xFFFFD43B);

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: pythonBlue,
        elevation: 3,
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada favorit',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (ctx, i) {
                    final f = items[i];

                    return Container(
                      margin: EdgeInsets.only(bottom: 14),
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(12),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: Colors.white,
                          title: Text(
                            f.term,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: pythonBlue,
                              fontSize: 17,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              f.definition,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: pythonYellow),
                            onPressed: () => _delete(f.id),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
