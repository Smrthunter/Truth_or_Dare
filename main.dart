import 'package:flutter/material.dart';
import 'start_screen.dart';

void main() {
  runApp(const TruthOrDareApp());
}

class TruthOrDareApp extends StatelessWidget {
  const TruthOrDareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truth or Dare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const StartScreen(),
    );
  }
}
