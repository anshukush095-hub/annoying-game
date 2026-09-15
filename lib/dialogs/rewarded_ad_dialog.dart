import 'dart:async';
import 'package:flutter/material.dart';
import '../services/game_state.dart';
import '../widgets/game_button.dart';
import '../widgets/comic_card.dart';

class RewardedAdDialog extends StatefulWidget {
  final int rewardAmount;

  const RewardedAdDialog({super.key, this.rewardAmount = 100});

  @override
  State<RewardedAdDialog> createState() => _RewardedAdDialogState();
}

class _RewardedAdDialogState extends State<RewardedAdDialog> {
  bool _isWatchingAd = false;
  int _adSecondsLeft = 5;
  Timer? _adTimer;

  void _startAdSimulation() {
    setState(() {
      _isWatchingAd = true;
      _adSecondsLeft = 5;
    });

    _adTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_adSecondsLeft > 1) {
        setState(() => _adSecondsLeft--);
      } else {
        timer.cancel();
        GameState().addCoins(widget.rewardAmount);
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🎉 Awesome! You earned +${widget.rewardAmount} Coins!'),
              backgroundColor: const Color(0xFF4CAF50),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _adTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ComicPanel(
        title: _isWatchingAd ? 'SPONSORED AD' : 'Watch Ad',
        titleColor: const Color(0xFFFFD54F),
        backgroundColor: const Color(0xFF1565C0),
        borderColor: const Color(0xFF64B5F6),
        child: _isWatchingAd
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.movie, color: Colors.white70, size: 48),
                                SizedBox(height: 8),
                                Text(
                                  'Playing Awesome Game Trailer...',
                                  style: TextStyle(color: Colors.white70, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Reward in ${_adSecondsLeft}s',
                              style: const TextStyle(
                                color: Color(0xFFFFD54F),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: (5 - _adSecondsLeft) / 5.0,
                    backgroundColor: Colors.white24,
                    color: const Color(0xFF4CAF50),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 6),
                  const Text(
                    'Get extra coins!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Coin bundle display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D47A1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF42A5F5), width: 2),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFFD54F),
                              ),
                              child: const Center(
                                child: Text(
                                  '¢',
                                  style: TextStyle(
                                    color: Color(0xFFE65100),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '+${widget.rewardAmount}',
                              style: const TextStyle(
                                color: Color(0xFFFFD54F),
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Watch Video Button
                  GameButton(
                    text: 'Watch Video',
                    icon: Icons.play_arrow,
                    color: GameButtonColor.green,
                    onPressed: _startAdSimulation,
                  ),
                  const SizedBox(height: 10),

                  // No Thanks Button
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'No Thanks',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
