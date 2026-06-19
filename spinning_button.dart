import 'package:flutter/material.dart';

class SpinningButton extends StatefulWidget {
  final String label;
  final VoidCallback? onSpinComplete;

  const SpinningButton({
    Key? key,
    this.label = "SPIN",
    this.onSpinComplete,
  }) : super(key: key);

  @override
  State<SpinningButton> createState() => _SpinningButtonState();
}

class _SpinningButtonState extends State<SpinningButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isSpinning) return;
    setState(() => _isSpinning = true);

    _controller.forward(from: 0).whenComplete(() {
      setState(() => _isSpinning = false);
      widget.onSpinComplete?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: RotationTransition(
        turns: _controller,
        child: Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF7F77DD),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
