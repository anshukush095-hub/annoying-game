import 'package:flutter/material.dart';
import '../services/game_state.dart';
import '../widgets/game_button.dart';
import '../widgets/comic_card.dart';

class AudioSettingsDialog extends StatelessWidget {
  const AudioSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = GameState();

    return ListenableBuilder(
      listenable: gameState,
      builder: (context, _) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: ComicPanel(
            title: 'Audio Settings',
            titleColor: const Color(0xFFFFD54F),
            backgroundColor: const Color(0xFF1565C0),
            borderColor: const Color(0xFF64B5F6),
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),

                // Music Volume Slider
                _buildVolumeSlider(
                  icon: Icons.music_note,
                  title: 'Music',
                  value: gameState.musicVolume,
                  onChanged: (val) => gameState.setMusicVolume(val),
                ),
                const SizedBox(height: 14),

                // SFX Volume Slider
                _buildVolumeSlider(
                  icon: Icons.volume_up,
                  title: 'Sound Effects',
                  value: gameState.sfxVolume,
                  onChanged: (val) => gameState.setSfxVolume(val),
                ),
                const SizedBox(height: 14),

                // Vibration Toggle
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D47A1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.vibration, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Vibration',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Switch(
                        value: gameState.vibrationEnabled,
                        onChanged: (val) => gameState.toggleVibration(val),
                        activeThumbColor: const Color(0xFF4CAF50),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Notifications Toggle
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D47A1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Switch(
                        value: gameState.notificationsEnabled,
                        onChanged: (val) => gameState.toggleNotifications(val),
                        activeThumbColor: const Color(0xFF4CAF50),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Done Button
                GameButton(
                  text: 'DONE',
                  color: GameButtonColor.blue,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVolumeSlider({
    required IconData icon,
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Text(
                '${(value * 100).toInt()}%',
                style: const TextStyle(
                  color: Color(0xFFFFD54F),
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFF42A5F5),
              inactiveTrackColor: Colors.white24,
              thumbColor: const Color(0xFFFFD54F),
              overlayColor: Colors.amber.withValues(alpha: 0.2),
              trackHeight: 6,
            ),
            child: Slider(
              value: value,
              min: 0.0,
              max: 1.0,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
