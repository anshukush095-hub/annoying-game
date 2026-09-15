import 'dart:async';
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

class _DailyRewardDialogState extends State<DailyRewardDialog> {
  final gameState = GameState();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
    final currentRewardItem = gameState.dailyRewards.firstWhere(
      (r) => r.day == streak,
      orElse: () => gameState.dailyRewards.first,
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: ComicPanel(
        title: 'Daily Reward',
        titleColor: const Color(0xFFFFD54F),
        backgroundColor: const Color(0xFF1565C0),
        borderColor: const Color(0xFF64B5F6),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),

            // 1 Claim Per Day Banner / Countdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isClaimedToday
                    ? const Color(0xFF2E7D32).withValues(alpha: 0.35)
                    : const Color(0xFFFF8F00).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isClaimedToday ? const Color(0xFF81C784) : const Color(0xFFFFD54F),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isClaimedToday ? Icons.check_circle : Icons.alarm,
                    color: isClaimedToday ? const Color(0xFF81C784) : const Color(0xFFFFD54F),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isClaimedToday
                          ? 'Claimed for today! Next reward in: ${_formatDuration(gameState.timeUntilNextDailyReward)}'
                          : '1 Daily Reward per day. Claim your Day $streak reward now!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Days 1 to 6 Grid (2 rows of 3)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.92,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                final day = index + 1;
                final reward = gameState.dailyRewards[index];
                final isPassed = day < streak;
                final isCurrent = day == streak;
                final isDayClaimed = isPassed || (isCurrent && isClaimedToday);

                return Container(
                  decoration: BoxDecoration(
                    color: isCurrent && !isClaimedToday
                        ? const Color(0xFFE8F5E9)
                        : (isDayClaimed ? const Color(0xFFC8E6C9) : Colors.white),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isCurrent && !isClaimedToday
                          ? const Color(0xFF4CAF50)
                          : (isDayClaimed ? const Color(0xFF81C784) : const Color(0xFFB0BEC5)),
                      width: isCurrent && !isClaimedToday ? 3 : 1.5,
                    ),
                    boxShadow: isCurrent && !isClaimedToday
                        ? [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Day $day',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Coin stack icon
                      Container(
                        width: 30,
                        height: 30,
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
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isDayClaimed)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 15),
                            SizedBox(width: 2),
                            Text(
                              'Claimed',
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          '+${reward.coins}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            // Day 7 Special Reward Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF176), Color(0xFFFFB300)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFF8F00), width: 2.2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.card_giftcard, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Day 7 Grand Reward',
                          style: TextStyle(
                            color: Color(0xFFBF360C),
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'Mega Bonus (+1,000 Coins 🪙)',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (streak == 7 && !isClaimedToday)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'READY!',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Claim / Done Button
            if (!isClaimedToday) ...[
              GameButton(
                text: 'CLAIM DAY $streak REWARD (+${currentRewardItem.coins} 🪙)',
                color: GameButtonColor.green,
                height: 48,
                onPressed: () {
                  final claimed = gameState.claimDailyReward();
                  if (claimed) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('🎉 Day $streak daily reward claimed! (+${currentRewardItem.coins} Coins)'),
                        backgroundColor: const Color(0xFF4CAF50),
                      ),
                    );
                  }
                },
              ),
            ] else ...[
              GameButton(
                text: 'CLAIMED TODAY ✅',
                color: GameButtonColor.blue,
                height: 46,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],

            const SizedBox(height: 10),

            // Rewarded Ad Extra Bonus (+500 Coins)
            InkWell(
              onTap: () {
                AdService().showRewardedAd(
                  context,
                  rewardAmount: 500,
                  onRewarded: () => setState(() {}),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD54F).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFD54F), width: 1.5),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_circle_fill, color: Color(0xFFFFD54F), size: 22),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Watch Ad for Bonus +500 Coins 🪙',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFFFFD54F),
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
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
