import 'package:flutter/material.dart';
import 'features/discovery/presentation/pages/discovery_page.dart';

void main() {
  runApp(const DiscoveryDemoApp());
}

class DiscoveryDemoApp extends StatelessWidget {
  const DiscoveryDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EWAJI Discovery Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: const Color(0xFF5E50A1),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const DiscoveryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
