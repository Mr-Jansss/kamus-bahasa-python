// lib/screens/term_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/term_model.dart';
import '../services/favorite_service.dart';

class TermDetailScreen extends StatelessWidget {
  final FavoriteService _fav = FavoriteService();

  @override
  Widget build(BuildContext context) {
    final Term t = ModalRoute.of(context)!.settings.arguments as Term;

    const pythonBlue = Color(0xFF306998);
    const pythonYellow = Color(0xFFFFD43B);

    return Scaffold(
      backgroundColor: Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: pythonBlue,
        elevation: 3,
        title: Text(
          t.term,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------ CARD TITLE ------------
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.term,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: pythonBlue,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      t.definition,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // ------------ CARD CODE EXAMPLE ------------
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E), // dark code editor look
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Contoh Kode",
                      style: TextStyle(
                        color: pythonYellow,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      t.example,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "monospace",
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // ------------ FAVORITE BUTTON ------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: pythonYellow,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: () async {
                  try {
                    await _fav.addFavorite(t.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ditambahkan ke Favorite')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                child: Text("Tambah ke Favorite"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
