import 'package:flutter/material.dart';
import '../services/ad_service.dart';
import '../widgets/game_button.dart';
import '../widgets/comic_card.dart';
import '../theme/game_characters.dart';

class LevelCompleteDialog extends StatefulWidget {
  final int level;
  final int score;
  final int stars;
  final int coinsEarned;
  final VoidCallback onNextLevel;
  final VoidCallback onHome;

  const LevelCompleteDialog({
    super.key,
    required this.level,
    required this.score,
    required this.stars,
    this.coinsEarned = 200,
    required this.onNextLevel,
    required this.onHome,
  });

  @override
  State<LevelCompleteDialog> createState() => _LevelCompleteDialogState();
}

class _LevelCompleteDialogState extends State<LevelCompleteDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ComicPanel(
        title: 'Level Complete!',
        titleColor: const Color(0xFFFFD54F),
        backgroundColor: const Color(0xFF1565C0),
        borderColor: const Color(0xFF64B5F6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            // 3 Animated Stars
            ScaleTransition(
              scale: CurvedAnimation(
                parent: _animController,
                curve: Curves.elasticOut,
              ),
              child: StarRatingWidget(
                stars: widget.stars,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),

            // Score Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D47A1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF42A5F5), width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    'Score',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.score}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Coins Earned: +200
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0039CB).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Coins Earned',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 24,
                    height: 24,
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
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '+${widget.coinsEarned}',
                    style: const TextStyle(
                      color: Color(0xFFFFD54F),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Next Character Preview Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0D47A1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFD54F), width: 1.8),
              ),
              child: Row(
                children: [
                  UncleCharacterWidget(
                    size: 34,
                    skin: UncleCharacterWidget.getSkinForLevel(widget.level + 1),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NEXT: LEVEL ${widget.level + 1}',
                          style: const TextStyle(
                            color: Color(0xFFFFD54F),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1,
                          ),
                        ),
                        Text(
                          UncleCharacterWidget.getCharacterNameForSkin(
                            UncleCharacterWidget.getSkinForLevel(widget.level + 1),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Double Coins via Rewarded Ad
            InkWell(
              onTap: () {
                AdService().showRewardedAd(
                  context,
                  rewardAmount: widget.coinsEarned,
                  onRewarded: () {
                    if (mounted) setState(() {});
                  },
                );
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD54F).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFD54F), width: 1.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_circle_fill, color: Color(0xFFFFD54F), size: 18),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Double Coins (+${widget.coinsEarned} 🪙): Watch Ad',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFFFD54F),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Action Buttons: 🔵 Home, 🟢 Next Level
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GameButton(
                    text: 'Home',
                    icon: Icons.home,
                    color: GameButtonColor.blue,
                    height: 46,
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onHome();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: GameButton(
                    text: 'Next Level 🎬',
                    icon: Icons.play_arrow,
                    color: GameButtonColor.green,
                    height: 46,
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Show Interstitial Ad on Level Completion
                      AdService().showLevelCompleteInterstitial(
                        context,
                        onDismissed: widget.onNextLevel,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
