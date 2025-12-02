import 'package:flutter/material.dart';
import '../services/user_service.dart';

class AdminEditUserScreen extends StatefulWidget {
  @override
  State<AdminEditUserScreen> createState() => _AdminEditUserScreenState();
}

class _AdminEditUserScreenState extends State<AdminEditUserScreen> {
  final UserService _service = UserService();
  final _userCtl = TextEditingController();
  final _passCtl = TextEditingController();

  String role = "user";
  Map? user;

  static const pythonBlue = Color(0xFF306998);
  static const pythonYellow = Color(0xFFFFD43B);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context)!.settings.arguments as Map?;

    if (user != null) {
      _userCtl.text = user!["username"];
      role = user!["role"];
    }
  }

  void save() async {
    final res = await _service.createUser(
      _userCtl.text.trim(),
      _passCtl.text.trim(),
      role,
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res["message"] ?? "Done")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = user != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: pythonBlue,
        elevation: 3,
        title: Text(
          isEdit ? "Edit User" : "Create User",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Username
                TextField(
                  controller: _userCtl,
                  decoration: InputDecoration(
                    labelText: "Username",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: _passCtl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Role Dropdown
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: DropdownButton<String>(
                    value: role,
                    underline: const SizedBox(),
                    isExpanded: true,
                    items: ["admin", "user"]
                        .map(
                          (r) => DropdownMenuItem(
                            value: r,
                            child: Text(
                              r.toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => role = v!),
                  ),
                ),

                const SizedBox(height: 25),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pythonYellow,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(isEdit ? "Update User" : "Create User"),
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
