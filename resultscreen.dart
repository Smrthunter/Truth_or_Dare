import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String type;
  final String prompt;

  const ResultScreen({
    super.key,
    required this.type,
    required this.prompt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                type,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                prompt,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Play Again"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}