import 'package:flutter/material.dart';
import '../services/term_service.dart';

class AdminEditTermScreen extends StatefulWidget {
  @override
  State<AdminEditTermScreen> createState() => _AdminEditTermScreenState();
}

class _AdminEditTermScreenState extends State<AdminEditTermScreen> {
  final _termCtl = TextEditingController();
  final _defCtl = TextEditingController();
  final _exCtl = TextEditingController();
  final TermService _termService = TermService();

  bool loading = false;
  int? editingId;

  static const pythonBlue = Color(0xFF306998);
  static const pythonYellow = Color(0xFFFFD43B);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args != null && args is Map) {
      editingId = args["id"];
      _termCtl.text = args["term"] ?? "";
      _defCtl.text = args["definition"] ?? "";
      _exCtl.text = args["example"] ?? "";
    }
  }

  void _save() async {
    setState(() => loading = true);

    try {
      final body = {
        "term": _termCtl.text.trim(),
        "definition": _defCtl.text.trim(),
        "example": _exCtl.text.trim(),
      };

      if (editingId == null) {
        await _termService.addTerm(body);
      } else {
        await _termService.updateTerm(editingId!, body);
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  Widget _inputField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = editingId != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: pythonBlue,
        elevation: 3,
        title: Text(
          isEdit ? "Edit Term" : "Create Term",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _inputField(_termCtl, "Term", icon: Icons.title),
                const SizedBox(height: 16),

                _inputField(_defCtl, "Definition",
                    icon: Icons.description, maxLines: 2),
                const SizedBox(height: 16),

                _inputField(_exCtl, "Example (Kode Contoh)",
                    icon: Icons.code, maxLines: 3),
                const SizedBox(height: 25),

                // SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pythonYellow,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isEdit ? "Update Term" : "Create Term"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
