import 'package:flutter/material.dart';
import '../services/user_service.dart';

class AdminUserScreen extends StatefulWidget {
  @override
  State<AdminUserScreen> createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends State<AdminUserScreen> {
  final UserService _userService = UserService();
  List users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    setState(() => loading = true);
    users = await _userService.getAllUsers();
    setState(() => loading = false);
  }

  void goCreateUser() {
    Navigator.pushNamed(context, '/admin/users/edit').then((_) => loadUsers());
  }

  void editUser(Map user) {
    Navigator.pushNamed(
      context,
      '/admin/users/edit',
      arguments: user,
    ).then((_) => loadUsers());
  }

  void deleteUser(int id) async {
    await _userService.deleteUser(id);
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Users")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: goCreateUser,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (ctx, i) {
                final u = users[i];
                return ListTile(
                  title: Text(u["username"]),
                  subtitle: Text("Role: ${u["role"]}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => editUser(u),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteUser(u["id"]),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
