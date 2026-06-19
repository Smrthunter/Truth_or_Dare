import 'dart:math';
import 'package:flutter/material.dart';
import 'person3_result_screen.dart';
import 'person4_juice.dart';

// PERSON 1: THE WHEEL
// Big colorful spinning wheel with a fixed fiducial pointer at the
// top. The center button is Person 4's JuicyButton -- it handles
// its own bounce/haptic/tap-sound, then calls _spin() here, which
// plays the spin whoosh, turns the wheel, and hands off to
// Person 3's ResultScreen once it settles.

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _currentAngle = 0;
  bool _isSpinning = false;

  // Alternating wedge colors -- purple = Truth, pink = Dare
  static const List<Color> _wedgeColors = [
    Color(0xFF7F77DD),
    Color(0xFFD4537E),
    Color(0xFF7F77DD),
    Color(0xFFD4537E),
    Color(0xFF7F77DD),
    Color(0xFFD4537E),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spin(BuildContext context) {
    if (_isSpinning) return;
    setState(() => _isSpinning = true);
    JuicySound.playSpin(); // Person 4: whoosh while it turns

    final random = Random();
    final type = random.nextBool() ? "Truth" : "Dare";

    // Spin several full turns plus a random offset so it never
    // looks the same twice
    final extraTurns = 5 + random.nextInt(3);
    final randomOffset = random.nextDouble() * 2 * pi;
    final targetAngle =
        _currentAngle + (extraTurns * 2 * pi) + randomOffset;

    final animation = Tween<double>(begin: _currentAngle, end: targetAngle)
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    animation.addListener(() {
      setState(() => _currentAngle = animation.value);
    });

    _controller.forward(from: 0).whenComplete(() {
      setState(() => _isSpinning = false);
      // Person 3's screen takes it from here
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(type: type)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // The spinning wheel itself
            Transform.rotate(
              angle: _currentAngle,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: ClipOval(
                  child: CustomPaint(
                    size: const Size(260, 260),
                    painter: _WheelPainter(colors: _wedgeColors),
                  ),
                ),
              ),
            ),
            // Fiducial pointer -- fixed in place, does NOT rotate,
            // marks which wedge has "landed"
            const Positioned(
              top: 0,
              child: SizedBox(
                width: 30,
                height: 30,
                child: CustomPaint(painter: _PointerPainter()),
              ),
            ),
            // Person 4's button -- bounce, haptic, tap sound,
            // then it calls back into _spin()
            JuicyButton(onPressed: () => _spin(context)),
          ],
        ),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final List<Color> colors;
  _WheelPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sweep = 2 * pi / colors.length;

    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()..color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * sweep,
        sweep,
        true,
        paint,
      );
    }

    for (int i = 0; i < colors.length; i++) {
      final label = i % 2 == 0 ? "TRUTH" : "DARE";
      final angle = i * sweep + sweep / 2;
      final textRadius = radius * 0.65;
      final offset = Offset(
        center.dx + textRadius * cos(angle - pi / 2),
        center.dy + textRadius * sin(angle - pi / 2),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle + pi / 2);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PointerPainter extends CustomPainter {
  const _PointerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.amber;
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
