import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/game_state.dart';
import '../services/ad_service.dart';
import '../widgets/game_button.dart';
import '../widgets/comic_card.dart';

class DailyRewardDialog extends StatefulWidget {
  const DailyRewardDialog({super.key});

  @override
  State<DailyRewardDialog> createState() => _DailyRewardDialogState();
}

class _DailyRewardDialogState extends State<DailyRewardDialog>
    with SingleTickerProviderStateMixin {
  final gameState = GameState();
  Timer? _timer;

  // Lucky Spin Wheel Controller
  late AnimationController _spinController;
  late Animation<double> _spinAnimation;
  double _currentWheelAngle = 0.0;
  bool _isSpinning = false;

  final List<_SpinSlice> _slices = const [
    _SpinSlice(label: '+200 🪙', coins: 200, color: Color(0xFFFFB300)),
    _SpinSlice(label: '+50 💎', coins: 350, color: Color(0xFF00E5FF)),
    _SpinSlice(label: 'Mystery 📦', coins: 400, color: Color(0xFFAB47BC)),
    _SpinSlice(label: '2X BONUS', coins: 600, color: Color(0xFFE91E63)),
    _SpinSlice(label: '+1000 🪙', coins: 1000, color: Color(0xFFFFD600)),
    _SpinSlice(label: 'Super 🎁', coins: 500, color: Color(0xFF26A69A)),
    _SpinSlice(label: '+100 🪙', coins: 100, color: Color(0xFF42A5F5)),
    _SpinSlice(label: '+300 🪙', coins: 300, color: Color(0xFF66BB6A)),
  ];

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _spinController.dispose();
    super.dispose();
  }

  void _spinWheel({bool isAd = false}) {
    if (_isSpinning) return;
    if (!isAd && !gameState.canFreeSpin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Free spin already used today! Watch an ad to spin again! 🎬')),
      );
      return;
    }

    final random = math.Random();
    final sliceIndex = random.nextInt(_slices.length);
    final selectedSlice = _slices[sliceIndex];

    // Calculate angle to stop at selectedSlice
    final sliceAngle = (2 * math.pi) / _slices.length;
    // Top pointer is at -pi/2
    final targetAngleOffset = (2 * math.pi * 5) + (sliceIndex * sliceAngle) + (sliceAngle / 2);
    final startAngle = _currentWheelAngle % (2 * math.pi);
    final endAngle = startAngle + targetAngleOffset;

    _spinAnimation = CurvedAnimation(
      parent: _spinController,
      curve: Curves.easeOutCirc,
    );

    setState(() {
      _isSpinning = true;
    });

    _spinController.reset();
    _spinAnimation.addListener(() {
      setState(() {
        _currentWheelAngle = startAngle + (endAngle - startAngle) * _spinAnimation.value;
      });
    });

    _spinController.forward().then((_) {
      if (mounted) {
        setState(() {
          _isSpinning = false;
        });
        gameState.addCoins(selectedSlice.coins);
        if (!isAd) gameState.performSpin();

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: const Color(0xFF1565C0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text(
              '🎉 LUCKY SPIN WINNER! 🎉',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFFFD54F), fontWeight: FontWeight.w900),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.card_giftcard, color: Color(0xFFFFD54F), size: 54),
                const SizedBox(height: 10),
                Text(
                  'You won ${selectedSlice.label}!',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50)),
                  child: const Text('COLLECT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final streak = gameState.dailyStreak;
    final isClaimedToday = gameState.isDailyRewardClaimedToday;
    final canFreeSpin = gameState.canFreeSpin;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: SingleChildScrollView(
        child: ComicPanel(
          title: 'Lucky Spin & Daily Rewards',
          titleColor: const Color(0xFFFFD54F),
          backgroundColor: const Color(0xFF0F3E7D),
          borderColor: const Color(0xFF64B5F6),
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Lucky Spin Wheel (Screenshot 5 Alignment)
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Glow Wheel Ring
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD54F).withValues(alpha: 0.35),
                          blurRadius: 18,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),

                  // Rotating Wheel Canvas
                  Transform.rotate(
                    angle: _currentWheelAngle,
                    child: CustomPaint(
                      size: const Size(190, 190),
                      painter: _WheelPainter(slices: _slices),
                    ),
                  ),

                  // Center Spin Button
                  GestureDetector(
                    onTap: _isSpinning ? null : () => _spinWheel(isAd: !canFreeSpin),
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [Color(0xFFFFF176), Color(0xFFFFB300), Color(0xFFE65100)],
                        ),
                        border: Border.all(color: Colors.white, width: 2.5),
                        boxShadow: const [
                          BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 3)),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _isSpinning ? '...' : 'SPIN',
                        style: const TextStyle(
                          color: Color(0xFF3E2723),
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  // Top Needle Indicator
                  const Positioned(
                    top: 0,
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFFFFD54F),
                      size: 38,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Spin Button
              ElevatedButton.icon(
                onPressed: _isSpinning
                    ? null
                    : () {
                        if (canFreeSpin) {
                          _spinWheel(isAd: false);
                        } else {
                          AdService().showRewardedAd(
                            context,
                            rewardAmount: 0,
                            onRewarded: () => _spinWheel(isAd: true),
                          );
                        }
                      },
                icon: Icon(canFreeSpin ? Icons.casino : Icons.play_arrow, color: Colors.white, size: 18),
                label: Text(
                  canFreeSpin ? 'SPIN NOW! (1 FREE DAILY)' : 'WATCH AD FOR EXTRA SPIN 🎬',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: canFreeSpin ? const Color(0xFF4CAF50) : const Color(0xFFFF8F00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const Divider(color: Color(0xFF42A5F5), height: 20),

              // 2. 7-Day Calendar Streak
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '7-Day Login Streak',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    isClaimedToday ? 'Claimed Today ✅' : 'Ready to Claim!',
                    style: TextStyle(
                      color: isClaimedToday ? const Color(0xFF81C784) : const Color(0xFFFFD54F),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Days 1 to 7 mini row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final day = index + 1;
                  final isPassed = day < streak;
                  final isCurrent = day == streak;
                  final isClaimed = isPassed || (isCurrent && isClaimedToday);

                  return Container(
                    width: 38,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isCurrent && !isClaimedToday
                          ? const Color(0xFFFFD54F)
                          : (isClaimed ? const Color(0xFF2E7D32) : const Color(0xFF1565C0)),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCurrent ? Colors.white : Colors.white24,
                        width: isCurrent ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'D$day',
                          style: TextStyle(
                            color: isCurrent && !isClaimedToday ? Colors.black87 : Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          isClaimed ? Icons.check : (day == 7 ? Icons.star : Icons.monetization_on),
                          color: isCurrent && !isClaimedToday
                              ? const Color(0xFFE65100)
                              : (day == 7 ? const Color(0xFFFFD54F) : Colors.white),
                          size: 14,
                        ),
                      ],
                    ),
                  );
                }),
              ),

              const SizedBox(height: 12),

              // Claim Daily Streak Button
              if (!isClaimedToday)
                GameButton(
                  text: 'CLAIM DAY $streak STREAK (+${gameState.dailyRewards[streak - 1].coins} 🪙)',
                  color: GameButtonColor.green,
                  height: 42,
                  onPressed: () {
                    if (gameState.claimDailyReward()) {
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('🎉 Claimed Day $streak Streak!'),
                          backgroundColor: const Color(0xFF4CAF50),
                        ),
                      );
                    }
                  },
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    'Next day streak in: ${_formatDuration(gameState.timeUntilNextDailyReward)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpinSlice {
  final String label;
  final int coins;
  final Color color;

  const _SpinSlice({required this.label, required this.coins, required this.color});
}

class _WheelPainter extends CustomPainter {
  final List<_SpinSlice> slices;

  _WheelPainter({required this.slices});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sliceAngle = (2 * math.pi) / slices.length;

    for (int i = 0; i < slices.length; i++) {
      final slice = slices[i];
      final startAngle = (i * sliceAngle) - (math.pi / 2);

      final paint = Paint()
        ..color = slice.color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sliceAngle,
        true,
        paint,
      );

      // Border outline
      final linePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.8)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sliceAngle,
        true,
        linePaint,
      );

      // Label text
      final textAngle = startAngle + (sliceAngle / 2);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(textAngle);

      final textSpan = TextSpan(
        text: slice.label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          shadows: [Shadow(color: Colors.black87, blurRadius: 3)],
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(canvas, Offset(radius * 0.42, -textPainter.height / 2));
      canvas.restore();
    }

    // Outer ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFFFFD54F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
