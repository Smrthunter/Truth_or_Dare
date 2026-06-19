import 'package:flutter/material.dart';
import 'person2_lists.dart';
import 'person4_juice.dart';

// PERSON 3: THE RESULT CARD
// Shows TRUTH or DARE in giant text, the prompt below it, and a
// Play Again button that pops back to the wheel. Plays Person 4's
// reveal sound + haptic buzz the moment it appears.

class ResultScreen extends StatefulWidget {
  final String type; // "Truth" or "Dare"
  final String? prompt; // optional -- supply it, or we'll pick one
  const ResultScreen({required this.type, this.prompt, Key? key})
      : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String prompt;

  @override
  void initState() {
    super.initState();
    prompt = widget.prompt ?? getPrompt(widget.type);
    JuicySound.playReveal(); // Person 4: haptic + sound on reveal
  }

  @override
  Widget build(BuildContext context) {
    final isTruth = widget.type == "Truth";
    final accentColor =
        isTruth ? const Color(0xFF7F77DD) : const Color(0xFFD4537E);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.type.toUpperCase(),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                prompt,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 26, color: Colors.white),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
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
