import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import '../services/game_state.dart';
import '../widgets/game_button.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = GameState();

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
                          'Achievements',
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

                  // Achievements List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: gameState.achievements.length,
                      itemBuilder: (context, index) {
                        final item = gameState.achievements[index];
                        final isCompleted = item.currentProgress >= item.maxProgress;
                        final ratio = (item.currentProgress / item.maxProgress).clamp(0.0, 1.0);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1565C0).withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isCompleted ? const Color(0xFFFFD54F) : const Color(0xFF42A5F5),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Icon medal
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const RadialGradient(
                                    colors: [Color(0xFFFFF59D), Color(0xFFFFB300)],
                                  ),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: Icon(item.icon, color: const Color(0xFFE65100), size: 28),
                              ),
                              const SizedBox(width: 14),

                              // Info & Progress
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      item.description,
                                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                    const SizedBox(height: 6),
                                    // Progress Bar
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: LinearProgressIndicator(
                                        value: ratio,
                                        minHeight: 8,
                                        backgroundColor: Colors.white24,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          isCompleted ? const Color(0xFF4CAF50) : const Color(0xFFFFD54F),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Progress text or checkmark
                              if (isCompleted)
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF4CAF50),
                                  ),
                                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                                )
                              else
                                Text(
                                  '${item.currentProgress}/${item.maxProgress}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                            ],
                          ),
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
