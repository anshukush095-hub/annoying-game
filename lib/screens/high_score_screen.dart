import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import '../services/game_state.dart';
import '../widgets/game_button.dart';
import '../dialogs/achievement_dialog.dart';

class HighScoreScreen extends StatelessWidget {
  const HighScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = GameState();

    final leaderboard = [
      {'rank': 1, 'name': 'You', 'score': gameState.highScore, 'isUser': true},
      {'rank': 2, 'name': 'Player2', 'score': 410, 'isUser': false},
      {'rank': 3, 'name': 'Player3', 'score': 350, 'isUser': false},
      {'rank': 4, 'name': 'Player4', 'score': 280, 'isUser': false},
      {'rank': 5, 'name': 'Player5', 'score': 210, 'isUser': false},
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: GameTheme.skyGradient,
        ),
        child: SafeArea(
          child: ListenableBuilder(
            listenable: gameState,
            builder: (context, _) {
              return Column(
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        GameIconButton(
                          icon: Icons.arrow_back,
                          backgroundColor: const Color(0xFF1565C0),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          'Leaderboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black45),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Big Trophy & High Score Banner
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0).withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF64B5F6), width: 3),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 8),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          color: Color(0xFFFFD54F),
                          size: 64,
                          shadows: [
                            Shadow(offset: Offset(0, 3), blurRadius: 6, color: Colors.black45),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'High Score',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${gameState.highScore}',
                          style: const TextStyle(
                            color: Color(0xFFFFD54F),
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Leaderboard Ranks
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF42A5F5), width: 2.5),
                        ),
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: leaderboard.length,
                          separatorBuilder: (context, index) =>
                              const Divider(color: Colors.white24, height: 12),
                          itemBuilder: (context, index) {
                            final item = leaderboard[index];
                            final isUser = item['isUser'] as bool;

                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? const Color(0xFFFFD54F).withValues(alpha: 0.25)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                border: isUser
                                    ? Border.all(color: const Color(0xFFFFD54F), width: 1.5)
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: index == 0
                                          ? const Color(0xFFFFD54F)
                                          : (index == 1
                                              ? const Color(0xFFCFD8DC)
                                              : (index == 2
                                                  ? const Color(0xFFFFB74D)
                                                  : const Color(0xFF0D47A1))),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${item['rank']}',
                                        style: TextStyle(
                                          color: index < 3 ? Colors.black87 : Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Text(
                                    item['name'] as String,
                                    style: TextStyle(
                                      color: isUser ? const Color(0xFFFFD54F) : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${item['score']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // View Achievements Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    child: GameButton(
                      text: 'ACHIEVEMENTS',
                      icon: Icons.military_tech,
                      color: GameButtonColor.purple,
                      onPressed: () {
                        final ach = gameState.achievements.first;
                        showDialog(
                          context: context,
                          builder: (_) => AchievementDialog(achievement: ach),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
