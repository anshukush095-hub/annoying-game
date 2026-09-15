import 'package:flutter/material.dart';
import '../theme/game_theme.dart';
import '../theme/game_characters.dart';
import '../models/punch_weapon.dart';
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

  String _getSkinRarity(String skinType) {
    switch (skinType) {
      case 'gold':
      case 'king':
        return 'GOLDEN';
      case 'superhero':
      case 'robot':
      case 'alien':
        return 'LEGENDARY';
      case 'boss':
      case 'vampire':
      case 'pirate':
      case 'astronaut':
        return 'EPIC';
      case 'clown':
      case 'police':
      case 'ninja':
      case 'boxer':
      case 'chef':
      case 'scientist':
      case 'zombie':
        return 'RARE';
      default:
        return 'COMMON';
    }
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'GOLDEN':
        return const Color(0xFFFFD54F);
      case 'LEGENDARY':
        return const Color(0xFFFF4081);
      case 'EPIC':
        return const Color(0xFFAB47BC);
      case 'RARE':
        return const Color(0xFF29B6F6);
      default:
        return const Color(0xFF9E9E9E);
    }
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        GameIconButton(
                          icon: Icons.arrow_back,
                          backgroundColor: const Color(0xFF1565C0),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 14),
                        const Text(
                          'Store & Armory',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
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

                  // 🎬 Rewarded Ad Banner: Free +500 Coins
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                                    'FREE COINS FOR SKINS & WEAPONS',
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

                  // Tabs: Locker (Skins), Armory (Weapons), Arenas
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'Locker (20+ Skins)'),
                        Tab(text: 'Armory Shop'),
                        Tab(text: 'Arenas'),
                      ],
                    ),
                  ),

                  // Tab Views
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildLockerTab(),
                        _buildArmoryTab(),
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

  // 1. Locker Tab (Screenshot 3 Alignment: Collect 20+ Hilarious Skins)
  Widget _buildLockerTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(14),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.64,
      ),
      itemCount: gameState.allSkins.length,
      itemBuilder: (context, index) {
        final skin = gameState.allSkins[index];
        final isUnlocked = gameState.isSkinUnlocked(skin.id);
        final isEquipped = gameState.equippedSkinId == skin.id;
        final rarity = _getSkinRarity(skin.skinType);
        final rarityColor = _getRarityColor(rarity);

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F3E7D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isEquipped
                  ? const Color(0xFFFFD54F)
                  : (isUnlocked ? rarityColor.withValues(alpha: 0.6) : Colors.black45),
              width: isEquipped ? 3 : 1.5,
            ),
            boxShadow: [
              if (isEquipped)
                BoxShadow(
                  color: const Color(0xFFFFD54F).withValues(alpha: 0.4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Rarity Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: rarityColor.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: rarityColor, width: 1),
                ),
                child: Text(
                  rarity,
                  style: TextStyle(
                    color: rarityColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              // Character Avatar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: UncleCharacterWidget(
                  size: 52,
                  skin: skin.skinType,
                ),
              ),

              // Name
              Text(
                skin.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),

              // Button / Status Badge
              if (isEquipped)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 2),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'EQUIPPED',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                )
              else if (isUnlocked)
                SizedBox(
                  width: double.infinity,
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () => gameState.equipSkin(skin.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'SELECT',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 28,
                  child: ElevatedButton.icon(
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
                    label: Text(
                      '${skin.price}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFB8C00),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // 2. Armory Shop Tab (Screenshot 4 Alignment: Upgrade Crazy Weapons & Gloves)
  Widget _buildArmoryTab() {
    final weapons = PunchWeapon.getAllWeapons();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      itemCount: weapons.length,
      itemBuilder: (context, index) {
        final weapon = weapons[index];
        final level = gameState.getWeaponLevel(weapon.id);
        final isEquipped = gameState.equippedWeaponId == weapon.id;
        final damage = weapon.baseDamage + (level - 1) * 1500;
        final upgradeCost = weapon.upgradeCost + (level - 1) * 3000;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1A237E),
                weapon.primaryColor.withValues(alpha: 0.35),
                const Color(0xFF0D47A1),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isEquipped ? const Color(0xFFFFD54F) : weapon.primaryColor.withValues(alpha: 0.8),
              width: isEquipped ? 2.8 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: weapon.glowColor.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Tier Badge & Weapon Name
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: weapon.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white, width: 1.2),
                    ),
                    child: Text(
                      'Tier ${weapon.tier}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      weapon.rarity,
                      style: TextStyle(
                        color: weapon.glowColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (isEquipped)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'EQUIPPED',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: () => gameState.equipWeapon(weapon.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        minimumSize: const Size(64, 28),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('EQUIP', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // Weapon Title & Icon
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: weapon.primaryColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: weapon.primaryColor.withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(weapon.icon, color: weapon.glowColor, size: 32),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weapon.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          weapon.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Stats Row: Damage, Crit, Secondary
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(Icons.sports_mma, 'DAMAGE', '$damage'),
                    _buildStatItem(Icons.star, 'CRIT', '${weapon.critRate}%'),
                    _buildStatItem(Icons.bolt, weapon.secondaryStatName, '${weapon.secondaryStatValue}%'),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Upgrade Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (gameState.upgradeWeapon(weapon.id, upgradeCost)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('⚔️ ${weapon.name} upgraded to Level ${level + 1}!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('⚠️ Not enough coins for upgrade! Watch an ad for +500 Coins!'),
                          backgroundColor: const Color(0xFFC62828),
                          action: SnackBarAction(
                            label: 'GET +500 🪙',
                            textColor: const Color(0xFFFFD54F),
                            onPressed: () => AdService().showRewardedAd(context, rewardAmount: 500),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB300),
                    foregroundColor: const Color(0xFF3E2723),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'UPGRADE LVL $level ➔ ${level + 1}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE65100),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$upgradeCost 🪙',
                          style: const TextStyle(color: Color(0xFFFFD54F), fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFFD54F), size: 14),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9, fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
          ],
        ),
      ],
    );
  }

  // 3. Arenas / Backgrounds Tab
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
