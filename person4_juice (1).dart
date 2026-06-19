import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

// PERSON 4: THE JUICE
// - JuicyButton: a reusable bouncy circular button. Drop it into
//   HomeScreen with an onPressed callback -- it handles the
//   press-down/up/cancel scale animation, a haptic buzz, and a
//   short tap sound, then calls your callback.
// - JuicySound: spin (while the wheel turns) and reveal (when the
//   result appears) sound cues, callable from anywhere.
//
// Sound files live in assets/sounds/ -- tap.wav, spin.wav, reveal.wav.
// Make sure pubspec.yaml lists that folder under assets: and
// audioplayers under dependencies (see pubspec.yaml).

class JuicySound {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playTap() async {
    await _player.play(AssetSource('sounds/tap.wav'));
  }

  static Future<void> playSpin() async {
    await _player.play(AssetSource('sounds/spin.wav'));
  }

  static Future<void> playReveal() async {
    HapticFeedback.lightImpact();
    await _player.play(AssetSource('sounds/reveal.wav'));
  }
}

class JuicyButton extends StatefulWidget {
  final String label;
  final double size;
  final VoidCallback onPressed;

  const JuicyButton({
    super.key,
    required this.onPressed,
    this.label = "SPIN",
    this.size = 90,
  });

  @override
  State<JuicyButton> createState() => _JuicyButtonState();
}

class _JuicyButtonState extends State<JuicyButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails _) => setState(() => _scale = 0.88);

  void _onTapUp(TapUpDetails _) {
    setState(() => _scale = 1.0);
    HapticFeedback.lightImpact();
    JuicySound.playTap();
    widget.onPressed();
  }

  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutBack,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
