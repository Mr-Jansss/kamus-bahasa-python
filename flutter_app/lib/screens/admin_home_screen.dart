import 'package:flutter/material.dart';
import '../services/term_service.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final TermService _termService = TermService();
  List terms = [];
  bool loading = true;

  static const pythonBlue = Color(0xFF306998);
  static const pythonYellow = Color(0xFFFFD43B);

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    setState(() => loading = true);
    final res = await _termService.getAllTerms();
    setState(() {
      terms = res;
      loading = false;
    });
  }

  void _goCreateTerm() {
    Navigator.pushNamed(context, '/admin/edit').then((_) => _load());
  }

  void _editTerm(Map term) {
    Navigator.pushNamed(
      context,
      '/admin/edit',
      arguments: term,
    ).then((_) => _load());
  }

  void _deleteTerm(int id) async {
    try {
      await _termService.deleteTerm(id);
      _load();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _goManageUsers() {
    Navigator.pushNamed(context, '/admin/users');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: pythonBlue,
        elevation: 3,
        title: const Text(
          'Admin Panel',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: "Kelola User",
            icon: const Icon(Icons.people),
            onPressed: _goManageUsers,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: pythonYellow,
        foregroundColor: Colors.black,
        elevation: 5,
        onPressed: _goCreateTerm,
        child: const Icon(Icons.add, size: 28),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(14),
              child: ListView.builder(
                itemCount: terms.length,
                itemBuilder: (ctx, i) {
                  final t = terms[i];

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        title: Text(
                          t['term'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: pythonBlue,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            t['definition'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: pythonBlue),
                              onPressed: () => _editTerm(t),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTerm(t['id']),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
