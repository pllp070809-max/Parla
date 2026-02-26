import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'widgets/bottom_nav.dart';

void main() {
  runApp(const ProviderScope(child: ParlaApp()));
}

class ParlaApp extends StatelessWidget {
  const ParlaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parla',
      debugShowCheckedModeBanner: false,
      theme: buildParlaTheme(),
      home: const BottomNavShell(),
    );
  }
}
