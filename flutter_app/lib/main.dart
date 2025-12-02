// lib/main.dart
import 'package:flutter/material.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/term_detail_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/admin_home_screen.dart';
import 'screens/admin_edit_term_screen.dart';
import 'screens/admin_user_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _primaryColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kamus Python',
      theme: ThemeData(primarySwatch: _primaryColor),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (ctx) => LoginScreen(),
        '/register': (ctx) => RegisterScreen(),
        '/home': (ctx) => HomeScreen(),
        '/term': (ctx) => TermDetailScreen(),
        '/favorites': (ctx) => FavoritesScreen(),

        //  Admin Routes
        '/admin': (ctx) => AdminHomeScreen(),
        '/admin/edit': (ctx) => AdminEditTermScreen(),
        '/admin/users': (ctx) => AdminUserScreen(),
      },
    );
  }
}
