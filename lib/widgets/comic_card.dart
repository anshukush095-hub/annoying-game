import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Top Bar Coin Indicator Capsule with Plus Button
class CoinCapsule extends StatelessWidget {
  final int coins;
  final VoidCallback? onAddCoins;

  const CoinCapsule({
    super.key,
    required this.coins,
    this.onAddCoins,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onAddCoins?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A8A),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFFFD54F), width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              offset: const Offset(0, 3),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gold Coin Icon
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFFFFF176), Color(0xFFFFB300)],
                ),
                border: Border.all(color: const Color(0xFFFF8F00), width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black38, offset: Offset(0, 2), blurRadius: 2),
                ],
              ),
              child: const Center(
                child: Text(
                  '¢',
                  style: TextStyle(
                    color: Color(0xFFE65100),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$coins',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF4CAF50),
              ),
              child: const Icon(
                Icons.add,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cartoon Frame / Container for Dialogs and Panels
class ComicPanel extends StatelessWidget {
  final Widget child;
  final String? title;
  final Color titleColor;
  final Color backgroundColor;
  final Color borderColor;
  final double width;
  final double? height;
  final EdgeInsetsGeometry padding;

  const ComicPanel({
    super.key,
    required this.child,
    this.title,
    this.titleColor = const Color(0xFFFFD54F),
    this.backgroundColor = const Color(0xFF1565C0),
    this.borderColor = const Color(0xFF42A5F5),
    this.width = double.infinity,
    this.height,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.88,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            offset: const Offset(0, 8),
            blurRadius: 10,
          ),
          BoxShadow(
            color: borderColor.withValues(alpha: 0.4),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0D47A1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: titleColor, width: 2),
              ),
              child: Text(
                title!,
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: 1.2,
                  shadows: const [
                    Shadow(offset: Offset(0, 2), blurRadius: 3, color: Colors.black),
                  ],
                ),
              ),
            ),
          ],
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: padding,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Star Rating Display (1 to 3 Stars with golden gradient)
class StarRatingWidget extends StatelessWidget {
  final int stars; // 0 to 3
  final double size;

  const StarRatingWidget({
    super.key,
    required this.stars,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final isFilled = index < stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            Icons.star,
            size: size,
            color: isFilled ? const Color(0xFFFFD54F) : Colors.black38,
            shadows: isFilled
                ? [
                    const Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black45),
                    const Shadow(offset: Offset(0, 0), blurRadius: 8, color: Color(0xFFFFB300)),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
