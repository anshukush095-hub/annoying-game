import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import '../services/game_state.dart';
import '../widgets/game_button.dart';
import '../dialogs/interactive_demo_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                          'Settings',
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

                  // Settings Card List (Match Reference Screen 9)
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1565C0).withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFF42A5F5), width: 3),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, offset: Offset(0, 6), blurRadius: 8),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Sound Toggle
                              _buildSwitchTile(
                                icon: Icons.volume_up,
                                title: 'Sound',
                                value: gameState.soundEnabled,
                                onChanged: (val) => gameState.toggleSound(val),
                              ),
                              const Divider(color: Colors.white24, height: 16),

                              // Music Toggle
                              _buildSwitchTile(
                                icon: Icons.music_note,
                                title: 'Music',
                                value: gameState.musicEnabled,
                                onChanged: (val) => gameState.toggleMusic(val),
                              ),
                              const Divider(color: Colors.white24, height: 16),

                              // Vibration Toggle
                              _buildSwitchTile(
                                icon: Icons.vibration,
                                title: 'Vibration',
                                value: gameState.vibrationEnabled,
                                onChanged: (val) => gameState.toggleVibration(val),
                              ),
                              const Divider(color: Colors.white24, height: 16),

                              // Language
                              _buildActionTile(
                                icon: Icons.language,
                                title: 'Language',
                                trailingText: gameState.selectedLanguage,
                                onTap: () => _showLanguagePicker(context, gameState),
                              ),
                              const Divider(color: Colors.white24, height: 16),

                              // Graphics
                              _buildActionTile(
                                icon: Icons.auto_awesome,
                                title: 'Graphics',
                                trailingText: gameState.graphicsQuality,
                                onTap: () => _showGraphicsPicker(context, gameState),
                              ),
                              const Divider(color: Colors.white24, height: 16),

                              // How to Play (Demo)
                              _buildActionTile(
                                icon: Icons.school,
                                title: 'How to Play (Demo)',
                                trailingText: '▶',
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const InteractiveDemoDialog(),
                                  );
                                },
                              ),
                              const Divider(color: Colors.white24, height: 16),

                              // Privacy Policy
                              _buildActionTile(
                                icon: Icons.privacy_tip_outlined,
                                title: 'Privacy Policy',
                                trailingText: '>',
                                onTap: () => _showPrivacyPolicy(context),
                              ),
                              const Divider(color: Colors.white24, height: 16),

                              // Rate Us
                              _buildActionTile(
                                icon: Icons.star_rate,
                                title: 'Rate Us',
                                trailingText: '⭐⭐⭐⭐⭐',
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('⭐ Thank you for rating Annoying Punch Uncle!'),
                                      backgroundColor: Color(0xFF4CAF50),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0D47A1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFF4CAF50),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String trailingText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0D47A1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              trailingText,
              style: const TextStyle(
                color: Color(0xFFFFD54F),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, GameState gameState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1565C0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final languages = ['English', 'Hindi', 'Spanish', 'Japanese', 'German'];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Select Language',
                  style: TextStyle(
                    color: Color(0xFFFFD54F),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...languages.map(
                (lang) => ListTile(
                  title: Text(lang, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  trailing: gameState.selectedLanguage == lang
                      ? const Icon(Icons.check, color: Color(0xFF4CAF50))
                      : null,
                  onTap: () {
                    gameState.setLanguage(lang);
                    Navigator.of(ctx).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showGraphicsPicker(BuildContext context, GameState gameState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1565C0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final qualities = ['High', 'Medium', 'Low'];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Graphics Quality',
                  style: TextStyle(
                    color: Color(0xFFFFD54F),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...qualities.map(
                (q) => ListTile(
                  title: Text(q, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  trailing: gameState.graphicsQuality == q
                      ? const Icon(Icons.check, color: Color(0xFF4CAF50))
                      : null,
                  onTap: () {
                    gameState.setGraphics(q);
                    Navigator.of(ctx).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1565C0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Privacy Policy', style: TextStyle(color: Color(0xFFFFD54F), fontWeight: FontWeight.bold)),
        content: const Text(
          'Annoying Punch Uncle does not collect personal data.\n\nAll game progress, scores, and coins are saved locally on your device for offline play.\n\nEnjoy punching the annoying uncle!',
          style: TextStyle(color: Colors.white, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK', style: TextStyle(color: Color(0xFFFFD54F), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
