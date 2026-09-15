import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum GameButtonColor { green, purple, orange, blue, red, yellow }

class GameButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final GameButtonColor color;
  final double width;
  final double height;
  final double fontSize;
  final bool isRound;

  const GameButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.color = GameButtonColor.green,
    this.width = double.infinity,
    this.height = 56,
    this.fontSize = 20,
    this.isRound = false,
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _isPressed = false;

  (Color, Color, Color) _getColors() {
    switch (widget.color) {
      case GameButtonColor.green:
        return (
          const Color(0xFF66BB6A),
          const Color(0xFF43A047),
          const Color(0xFF2E7D32),
        );
      case GameButtonColor.purple:
        return (
          const Color(0xFFBA68C8),
          const Color(0xFF8E24AA),
          const Color(0xFF6A1B9A),
        );
      case GameButtonColor.orange:
        return (
          const Color(0xFFFFB74D),
          const Color(0xFFFB8C00),
          const Color(0xFFE65100),
        );
      case GameButtonColor.blue:
        return (
          const Color(0xFF64B5F6),
          const Color(0xFF1E88E5),
          const Color(0xFF1565C0),
        );
      case GameButtonColor.red:
        return (
          const Color(0xFFE57373),
          const Color(0xFFE53935),
          const Color(0xFFC62828),
        );
      case GameButtonColor.yellow:
        return (
          const Color(0xFFFFEE58),
          const Color(0xFFFDD835),
          const Color(0xFFF57F17),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final (lightColor, mainColor, darkColor) = _getColors();
    final double depth = 6.0;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        width: widget.width,
        height: widget.height,
        margin: EdgeInsets.only(
          top: _isPressed ? depth : 0,
          bottom: _isPressed ? 0 : depth,
        ),
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(widget.isRound ? widget.height / 2 : 18),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: darkColor,
              offset: Offset(0, _isPressed ? 1 : depth),
              blurRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              offset: Offset(0, depth + 3),
              blurRadius: 5,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightColor, mainColor],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: Colors.white,
                      size: widget.fontSize * 1.15,
                      shadows: const [
                        Shadow(offset: Offset(0, 2), blurRadius: 3, color: Colors.black45),
                      ],
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.text,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                      shadows: const [
                        Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black54),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small Circular Icon Button (like Back button or Sound button)
class GameIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final double size;

  const GameIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor = const Color(0xFF1E88E5),
    this.size = 48,
  });

  @override
  State<GameIconButton> createState() => _GameIconButtonState();
}

class _GameIconButtonState extends State<GameIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const double depth = 4.0;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        width: widget.size,
        height: widget.size,
        margin: EdgeInsets.only(
          top: _isPressed ? depth : 0,
          bottom: _isPressed ? 0 : depth,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.backgroundColor,
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              offset: Offset(0, _isPressed ? 1 : depth),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            widget.icon,
            color: Colors.white,
            size: widget.size * 0.55,
            shadows: const [
              Shadow(offset: Offset(0, 2), blurRadius: 3, color: Colors.black45),
            ],
          ),
        ),
      ),
    );
  }
}
