import 'package:flutter/material.dart';
import '../theme/game_characters.dart';
import '../widgets/game_button.dart';
import '../widgets/comic_card.dart';

class TutorialDialog extends StatelessWidget {
  const TutorialDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ComicPanel(
        title: 'How to Play',
        titleColor: const Color(0xFFFFD54F),
        backgroundColor: const Color(0xFF1565C0),
        borderColor: const Color(0xFF64B5F6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            // Step 1: Aim at the uncle
            _buildStepTile(
              leading: const UncleCharacterWidget(size: 44, skin: 'default'),
              text: '1. Aim at the uncle',
            ),
            const SizedBox(height: 12),

            // Step 2: Punch with glove
            _buildStepTile(
              leading: const BoxingGloveWidget(size: 40),
              text: '2. Punch with glove',
            ),
            const SizedBox(height: 12),

            // Step 3: Don't miss!
            _buildStepTile(
              leading: const UncleCharacterWidget(size: 44, skin: 'red_hair'),
              text: '3. Don\'t miss!',
            ),
            const SizedBox(height: 24),

            // Got it Button
            GameButton(
              text: 'Got it',
              color: GameButtonColor.green,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepTile({required Widget leading, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF42A5F5), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: leading,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
