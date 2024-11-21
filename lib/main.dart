import 'package:flutter/material.dart';
import 'package:eye_app_devfest_2024/presentation/views/eye_scan_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData.light(useMaterial3: false),
      home: const EyeScanView(),
    );
  }
}
