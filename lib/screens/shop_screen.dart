import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import '../theme/game_characters.dart';
import '../services/game_state.dart';
import '../services/ad_service.dart';
import '../widgets/game_button.dart';
import '../widgets/comic_card.dart';
import '../dialogs/coins_rewards_dialog.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GameState gameState = GameState();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          'Shop',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black45),
                            ],
                          ),
                        ),
                        const Spacer(),
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

                  // 🎬 Rewarded Ad Banner: Free +500 Coins for Skins & Gloves
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: InkWell(
                      onTap: () {
                        AdService().showRewardedAd(
                          context,
                          rewardAmount: 500,
                          onRewarded: () {
                            if (mounted) setState(() {});
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF8F00), Color(0xFFFFB300), Color(0xFFFFD54F)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white, width: 1.8),
                          boxShadow: const [
                            BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF0D47A1),
                              ),
                              child: const Icon(Icons.play_arrow, color: Color(0xFFFFD54F), size: 20),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'FREE COINS FOR SKINS & GLOVES',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color(0xFF0D47A1),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Watch video ad to get +500 Coins! 🪙',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D47A1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '+500 🪙',
                                style: TextStyle(
                                  color: Color(0xFFFFD54F),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Tabs: Skins, Gloves, Backgrounds (Match Screen 8)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D47A1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF42A5F5), width: 2),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: const Color(0xFF1E88E5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      labelColor: const Color(0xFFFFD54F),
                      unselectedLabelColor: Colors.white70,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'Skins'),
                        Tab(text: 'Gloves'),
                        Tab(text: 'Backgrounds'),
                      ],
                    ),
                  ),

                  // Tab Views
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildSkinsTab(),
                        _buildGlovesTab(),
                        _buildBackgroundsTab(),
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

  // 1. Skins Tab (Default, Red Hair, Blue, Police, Clown, Gold)
  Widget _buildSkinsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: gameState.allSkins.length,
      itemBuilder: (context, index) {
        final skin = gameState.allSkins[index];
        final isUnlocked = gameState.isSkinUnlocked(skin.id);
        final isEquipped = gameState.equippedSkinId == skin.id;

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0).withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isEquipped ? const Color(0xFFFFD54F) : const Color(0xFF42A5F5),
              width: isEquipped ? 3 : 1.5,
            ),
            boxShadow: const [
              BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 4),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UncleCharacterWidget(
                size: 58,
                skin: skin.skinType,
              ),
              const SizedBox(height: 6),
              Text(
                skin.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),

              // Button / Status Badge
              if (isEquipped)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Owned',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                )
              else if (isUnlocked)
                ElevatedButton(
                  onPressed: () => gameState.equipSkin(skin.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: const Size(60, 26),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Equip', style: TextStyle(color: Colors.white, fontSize: 11)),
                )
              else
                ElevatedButton.icon(
                  onPressed: () {
                    if (gameState.unlockSkin(skin.id, skin.price)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('🎉 Unlocked ${skin.name}!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('⚠️ Not enough coins! Watch an ad for +500 Coins!'),
                          backgroundColor: const Color(0xFFC62828),
                          duration: const Duration(seconds: 4),
                          action: SnackBarAction(
                            label: 'GET +500 🪙',
                            textColor: const Color(0xFFFFD54F),
                            onPressed: () => AdService().showRewardedAd(context, rewardAmount: 500),
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.monetization_on, color: Color(0xFFFFD54F), size: 12),
                  label: Text('${skin.price}', style: const TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFB8C00),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    minimumSize: const Size(60, 26),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // 2. Gloves Tab
  Widget _buildGlovesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: gameState.allGloves.length,
      itemBuilder: (context, index) {
        final glove = gameState.allGloves[index];
        final isUnlocked = gameState.isGloveUnlocked(glove.id);
        final isEquipped = gameState.equippedGloveId == glove.id;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0).withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isEquipped ? const Color(0xFFFFD54F) : const Color(0xFF42A5F5),
              width: isEquipped ? 3 : 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D47A1),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: BoxingGloveWidget(
                  size: 44,
                  gloveColor: glove.color,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  glove.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              if (isEquipped)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('EQUIPPED', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                )
              else if (isUnlocked)
                ElevatedButton(
                  onPressed: () => gameState.equipGlove(glove.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('EQUIP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                )
              else
                ElevatedButton.icon(
                  onPressed: () {
                    if (gameState.unlockGlove(glove.id, glove.price)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('🎉 Unlocked ${glove.name}!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('⚠️ Not enough coins! Watch an ad for +500 Coins!'),
                          backgroundColor: const Color(0xFFC62828),
                          duration: const Duration(seconds: 4),
                          action: SnackBarAction(
                            label: 'GET +500 🪙',
                            textColor: const Color(0xFFFFD54F),
                            onPressed: () => AdService().showRewardedAd(context, rewardAmount: 500),
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.monetization_on, color: Color(0xFFFFD54F), size: 16),
                  label: Text('${glove.price}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFB8C00),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // 3. Backgrounds Tab
  Widget _buildBackgroundsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: gameState.allBackgrounds.length,
      itemBuilder: (context, index) {
        final bg = gameState.allBackgrounds[index];
        final isSelected = gameState.selectedBackgroundId == bg.id;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0).withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? const Color(0xFFFFD54F) : const Color(0xFF42A5F5),
              width: isSelected ? 3 : 1.5,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.panorama, color: Color(0xFFFFD54F), size: 36),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bg.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      bg.desc,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => gameState.setBackground(bg.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? const Color(0xFF4CAF50) : const Color(0xFF1E88E5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isSelected ? 'ACTIVE' : 'SELECT',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
