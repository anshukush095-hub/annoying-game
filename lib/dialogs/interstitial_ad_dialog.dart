import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/game_button.dart';

class InterstitialAdDialog extends StatefulWidget {
  final VoidCallback onClosed;

  const InterstitialAdDialog({
    super.key,
    required this.onClosed,
  });

  @override
  State<InterstitialAdDialog> createState() => _InterstitialAdDialogState();
}

class _InterstitialAdDialogState extends State<InterstitialAdDialog> {
  int _secondsRemaining = 4;
  bool _canSkip = false;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 1) {
        setState(() {
          _secondsRemaining--;
          if (_secondsRemaining <= 2) {
            _canSkip = true;
          }
        });
      } else {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
          _canSkip = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _handleDismiss() {
    _countdownTimer?.cancel();
    Navigator.of(context).pop();
    widget.onClosed();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: screenHeight * 0.9,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF0D47A1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF64B5F6), width: 3.5),
          boxShadow: const [
            BoxShadow(color: Colors.black87, blurRadius: 24, offset: Offset(0, 10)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Bar with Ad Badge and Skip / Close Button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
              decoration: const BoxDecoration(
                color: Color(0xFF002171),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'AD',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _secondsRemaining > 0
                          ? 'Video ends in ${_secondsRemaining}s'
                          : 'Sponsored Promotion',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Skip / Close Button
                  InkWell(
                    onTap: _canSkip ? _handleDismiss : null,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _canSkip
                            ? const Color(0xFF2E7D32)
                            : Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _canSkip ? const Color(0xFF81C784) : Colors.white24,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _canSkip ? Icons.close : Icons.hourglass_top,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _canSkip
                                ? 'Close ✕'
                                : '${_secondsRemaining}s',
                            style: TextStyle(
                              color: _canSkip ? Colors.white : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Ad Body (Simulated Interactive Game Promo)
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sponsored Media Card
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF6200EA), Color(0xFF0091EA), Color(0xFF00B0FF)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white30, width: 2),
                        boxShadow: const [
                          BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: const Icon(
                                      Icons.sports_esports,
                                      color: Colors.white,
                                      size: 34,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'PUNCH HEROES 3D',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                      shadows: [
                                        Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black54),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Over 5,000,000+ Downloads ★★★★★',
                                    style: TextStyle(
                                      color: Color(0xFFFFD54F),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Sponsored by AdMob',
                                style: TextStyle(color: Colors.white70, fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Progress Bar
                    LinearProgressIndicator(
                      value: (4 - _secondsRemaining) / 4.0,
                      backgroundColor: Colors.white24,
                      color: const Color(0xFF00E676),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    const SizedBox(height: 16),

                    // Ad CTA Button
                    GameButton(
                      text: 'INSTALL NOW 📲',
                      icon: Icons.download,
                      color: GameButtonColor.green,
                      height: 48,
                      fontSize: 16,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('🚀 Opening sponsored app page...'),
                            backgroundColor: Color(0xFF0D47A1),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),

                    // Continue to Next Level Button
                    if (_canSkip)
                      GameButton(
                        text: 'CONTINUE TO NEXT LEVEL ➡️',
                        icon: Icons.play_arrow,
                        color: GameButtonColor.yellow,
                        height: 46,
                        fontSize: 15,
                        onPressed: _handleDismiss,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
