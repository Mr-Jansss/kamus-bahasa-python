import 'package:flutter/material.dart';
import '../services/term_service.dart';
import '../models/term_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TermService _termService = TermService();
  List<Term> terms = [];
  bool loading = true;
  final _qCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load([String? q]) async {
    setState(() => loading = true);
    try {
      final res = await _termService.getAllTerms(q);
      setState(() => terms = res.map<Term>((j) => Term.fromJson(j)).toList());
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bluePython = Color(0xFF356AC3);
    final yellowPython = Color(0xFFFFC83D);

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: bluePython,
        elevation: 4,
        title: Text(
          "Kamus Python",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
        ],
      ),

      // BODY
      body: Column(
        children: [
          // SEARCH BAR CUSTOM
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _qCtl,
                      decoration: InputDecoration(
                        hintText: "Cari kata...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(14),
                      ),
                      onSubmitted: (v) => _load(v),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () => _load(_qCtl.text.trim()),
                      child: CircleAvatar(
                        backgroundColor: yellowPython,
                        child: Icon(Icons.search, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // LIST
          Expanded(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : terms.isEmpty
                    ? Center(
                        child: Text(
                          "Tidak ada data",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        itemCount: terms.length,
                        itemBuilder: (ctx, i) {
                          final t = terms[i];
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              title: Text(
                                t.term,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: bluePython,
                                ),
                              ),
                              subtitle: Text(
                                t.definition,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black87),
                              ),
                              trailing: Icon(Icons.chevron_right,
                                  color: yellowPython, size: 28),
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/term',
                                arguments: t,
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
