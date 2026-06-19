import 'dart:math';
import 'package:flutter/material.dart';
import 'spinning_button.dart';
import 'home_screen.dart';

// The very first screen the player sees. Tapping START spins the
// button, fires off a confetti burst, then hands off to the wheel
// (HomeScreen) once the celebration settles.

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _confettiController;
  final List<_ConfettiPiece> _confetti = [];
  bool _showConfetti = false;

  static const List<Color> _confettiColors = [
    Color(0xFF7F77DD),
    Color(0xFFD4537E),
    Color(0xFFEF9F27),
    Color(0xFF1D9E75),
    Color(0xFF378ADD),
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _launchConfetti() {
    final random = Random();
    _confetti.clear();
    for (int i = 0; i < 40; i++) {
      _confetti.add(_ConfettiPiece(
        x: random.nextDouble(),
        delay: random.nextDouble() * 0.3,
        speed: 0.7 + random.nextDouble() * 0.6,
        color: _confettiColors[random.nextInt(_confettiColors.length)],
        size: 6 + random.nextDouble() * 6,
        spin: random.nextDouble() * pi * 2,
      ));
    }
    setState(() => _showConfetti = true);
    _confettiController.forward(from: 0).whenComplete(() {
      setState(() => _showConfetti = false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF3C3489)],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Truth or Dare",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Tap start to spin the wheel",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 60),
                SpinningButton(
                  label: "START",
                  onSpinComplete: _launchConfetti,
                ),
              ],
            ),
            if (_showConfetti)
              AnimatedBuilder(
                animation: _confettiController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: _ConfettiPainter(
                      pieces: _confetti,
                      progress: _confettiController.value,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ConfettiPiece {
  final double x;
  final double delay;
  final double speed;
  final Color color;
  final double size;
  final double spin;

  _ConfettiPiece({
    required this.x,
    required this.delay,
    required this.speed,
    required this.color,
    required this.size,
    required this.spin,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;
  final double progress;

  _ConfettiPainter({required this.pieces, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in pieces) {
      final localProgress =
          ((progress - piece.delay) / (1 - piece.delay)).clamp(0.0, 1.0);
      if (localProgress <= 0) continue;

      final dx = piece.x * size.width;
      final dy = localProgress * piece.speed * size.height;
      final rotation = piece.spin * localProgress * 4;

      final paint = Paint()
        ..color = piece.color.withOpacity(1 - localProgress * 0.3);

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(rotation);
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset.zero, width: piece.size, height: piece.size * 0.6),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
