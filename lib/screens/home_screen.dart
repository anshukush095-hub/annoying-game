import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import '../theme/game_characters.dart';
import '../widgets/game_button.dart';
import '../widgets/comic_card.dart';
import '../services/game_state.dart';
import '../services/audio_manager.dart';
import 'level_select_screen.dart';
import 'shop_screen.dart';
import 'skins_preview_screen.dart';
import 'settings_screen.dart';
import 'achievements_screen.dart';
import '../dialogs/coins_rewards_dialog.dart';
import '../dialogs/daily_reward_dialog.dart';
import '../dialogs/interactive_demo_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioManager().startBackgroundMusic();

      // First-time app install interactive demo!
      if (!GameState().hasSeenDemo) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => InteractiveDemoDialog(
            onStartPlaying: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LevelSelectScreen()),
              );
            },
          ),
        );
      }
    });
  }

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ListenableBuilder(
                listenable: gameState,
                builder: (context, _) {
                  final currentSkin = gameState.allSkins.firstWhere(
                    (s) => s.id == gameState.equippedSkinId,
                    orElse: () => gameState.allSkins.first,
                  );

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Stack(
                      children: [
                        // Background Clouds
                        Positioned(
                          top: 40,
                          left: 20,
                          child: Icon(Icons.cloud, size: 64, color: Colors.white.withValues(alpha: 0.6)),
                        ),
                        Positioned(
                          top: 100,
                          right: 30,
                          child: Icon(Icons.cloud, size: 80, color: Colors.white.withValues(alpha: 0.5)),
                        ),

                        // Main Content
                        Column(
                          children: [
                      // Top Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            // Daily Gift Shortcut
                            GameIconButton(
                              icon: Icons.card_giftcard,
                              backgroundColor: const Color(0xFFE91E63),
                              size: 44,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => const DailyRewardDialog(),
                                );
                              },
                            ),
                            const SizedBox(width: 8),

                            // Achievements Shortcut
                            GameIconButton(
                              icon: Icons.bar_chart,
                              backgroundColor: const Color(0xFF1E88E5),
                              size: 44,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const AchievementsScreen()),
                                );
                              },
                            ),
                            const SizedBox(width: 8),

                            // Interactive Demo / Tutorial Shortcut
                            GameIconButton(
                              icon: Icons.help_outline,
                              backgroundColor: const Color(0xFFFF9800),
                              size: 44,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => const InteractiveDemoDialog(),
                                );
                              },
                            ),

                            const Spacer(),

                            // Coins Capsule
                            CoinCapsule(
                              coins: gameState.coins,
                              onAddCoins: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => const CoinsRewardsDialog(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const Spacer(flex: 1),

                      // "Annoying Punch Uncle" Title
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            'Annoying\nPunch Uncle',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 8
                                ..color = const Color(0xFF0D47A1),
                              height: 0.95,
                              letterSpacing: 1.5,
                            ),
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFFFFF9C4), Color(0xFFFFD54F), Color(0xFFFF9800)],
                            ).createShader(bounds),
                            child: const Text(
                              'Annoying\nPunch Uncle',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 0.95,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Uncle Mascot
                      UncleCharacterWidget(
                        size: 145,
                        skin: currentSkin.skinType,
                      ),

                      const Spacer(flex: 2),

                      // Action Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        child: Column(
                          children: [
                            // 🟡 PLAY (Yellow)
                            GameButton(
                              text: 'PLAY',
                              icon: Icons.play_arrow,
                              color: GameButtonColor.yellow,
                              height: 52,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const LevelSelectScreen()),
                                );
                              },
                            ),
                            const SizedBox(height: 10),

                            // 🔵 SHOP (Blue)
                            GameButton(
                              text: 'SHOP',
                              icon: Icons.shopping_cart,
                              color: GameButtonColor.blue,
                              height: 48,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const ShopScreen()),
                                );
                              },
                            ),
                            const SizedBox(height: 10),

                            // 🟣 SKINS (Purple)
                            GameButton(
                              text: 'SKINS (20)',
                              icon: Icons.checkroom,
                              color: GameButtonColor.purple,
                              height: 48,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const SkinsPreviewScreen()),
                                );
                              },
                            ),
                            const SizedBox(height: 10),

                            // Row of Demo & Settings Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: GameButton(
                                    text: 'DEMO',
                                    icon: Icons.school,
                                    color: GameButtonColor.orange,
                                    height: 46,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => const InteractiveDemoDialog(),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GameButton(
                                    text: 'SETTINGS',
                                    icon: Icons.settings,
                                    color: GameButtonColor.green,
                                    height: 46,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  ),
),
),
);
  }
}
