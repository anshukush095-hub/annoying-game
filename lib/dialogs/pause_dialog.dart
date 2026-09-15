import 'package:flutter/material.dart';
import '../widgets/game_button.dart';
import '../widgets/comic_card.dart';

class PauseDialog extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onRestart;
  final VoidCallback onHome;

  const PauseDialog({
    super.key,
    required this.onContinue,
    required this.onRestart,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: ComicPanel(
        title: 'Paused',
        titleColor: const Color(0xFFFFD54F),
        backgroundColor: const Color(0xFF1565C0),
        borderColor: const Color(0xFF64B5F6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            // 🟢 Continue
            GameButton(
              text: 'Continue',
              icon: Icons.play_arrow,
              color: GameButtonColor.green,
              onPressed: () {
                Navigator.of(context).pop();
                onContinue();
              },
            ),
            const SizedBox(height: 14),

            // 🔵 Restart
            GameButton(
              text: 'Restart',
              icon: Icons.refresh,
              color: GameButtonColor.blue,
              onPressed: () {
                Navigator.of(context).pop();
                onRestart();
              },
            ),
            const SizedBox(height: 14),

            // 🔴 Home
            GameButton(
              text: 'Home',
              icon: Icons.home,
              color: GameButtonColor.red,
              onPressed: () {
                Navigator.of(context).pop();
                onHome();
              },
            ),
          ],
        ),
      ),
    );
  }
}
