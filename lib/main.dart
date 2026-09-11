import 'package:flutter/material.dart';

// Import màn hình login vào
import 'login_screens/export.dart';

void main() {
  runApp(const MyApp());
  //debugPrint("Server run in http://localhost:8005/");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: 'Chat',
  //     home: const ChatListScreen(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: const LoginScreen(),
    );
  }
}
