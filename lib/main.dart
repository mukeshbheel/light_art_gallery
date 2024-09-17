import 'package:flutter/material.dart';
import 'package:light_art_gallary/features/all_arts_home/presentation/all_arts_home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AllArtsHomeScreen(),
    );
  }
}
