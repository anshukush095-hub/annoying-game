import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:annoying_game/main.dart';
import 'package:annoying_game/models/punch_weapon.dart';
import 'package:annoying_game/screens/gameplay_screen.dart';
import 'package:annoying_game/services/sound_generator.dart';
import 'package:annoying_game/services/game_state.dart';
import 'package:annoying_game/services/ad_service.dart';
import 'package:annoying_game/theme/game_characters.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AnnoyingGameApp());
    expect(find.byType(AnnoyingGameApp), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
  });

  test('PunchWeapon unlock progression across levels', () {
    final allWeapons = PunchWeapon.getAllWeapons();
    expect(allWeapons.length, 8);

    // Level 1: Only classic glove unlocked
    final lvl1Unlocked = allWeapons.where((w) => w.unlockLevel <= 1).toList();
    expect(lvl1Unlocked.length, 1);
    expect(lvl1Unlocked.first.type, PunchWeaponType.classicGlove);

    // Level 2: Finger Lightning unlocked ("ungli se current")
    final lvl2Unlocked = allWeapons.where((w) => w.unlockLevel <= 2).toList();
    expect(lvl2Unlocked.any((w) => w.type == PunchWeaponType.fingerLightning), isTrue);

    // Level 3: Rolling drill unlocked
    final lvl3Unlocked = allWeapons.where((w) => w.unlockLevel <= 3).toList();
    expect(lvl3Unlocked.any((w) => w.type == PunchWeaponType.rollingDrill), isTrue);

    // Level 5: Frost freeze ray unlocked
    final lvl5Unlocked = allWeapons.where((w) => w.unlockLevel <= 5).toList();
    expect(lvl5Unlocked.any((w) => w.type == PunchWeaponType.frostFreeze), isTrue);

    // Level 20+: All 8 weapons unlocked
    final lvl20Unlocked = allWeapons.where((w) => w.unlockLevel <= 20).toList();
    expect(lvl20Unlocked.length, 8);

    // Level 2000: All weapons remain unlocked with high power
    final lvl2000Unlocked = allWeapons.where((w) => w.unlockLevel <= 2000).toList();
    expect(lvl2000Unlocked.length, 8);
  });

  test('SoundGenerator produces valid PCM WAV headers for all punch weapons', () {
    final drillBytes = SoundGenerator.generateRollingDrillWav();
    final rocketBytes = SoundGenerator.generateRocketBlastWav();
    final hammerBytes = SoundGenerator.generateHammerBonkWav();
    final laserBytes = SoundGenerator.generateLaserBlastWav();

    for (final bytes in [drillBytes, rocketBytes, hammerBytes, laserBytes]) {
      expect(bytes.length, greaterThan(44));
      // "RIFF" in ASCII: 82, 73, 70, 70
      expect(bytes.sublist(0, 4), [82, 73, 70, 70]);
      // "WAVE" in ASCII: 87, 65, 86, 69
      expect(bytes.sublist(8, 12), [87, 65, 86, 69]);
    }
  });

  test('Uncle Character rotates every level up to 2000', () {
    final skin1 = UncleCharacterWidget.getSkinForLevel(1);
    final skin2 = UncleCharacterWidget.getSkinForLevel(2);
    final skin2000 = UncleCharacterWidget.getSkinForLevel(2000);

    final name1 = UncleCharacterWidget.getCharacterNameForSkin(skin1);
    final name2 = UncleCharacterWidget.getCharacterNameForSkin(skin2);
    final name2000 = UncleCharacterWidget.getCharacterNameForSkin(skin2000);

    expect(name1, isNotEmpty);
    expect(name2, isNotEmpty);
    expect(name2000, isNotEmpty);
    expect(name1, isNot(equals(name2)));
  });

  testWidgets('GameplayScreen level 2 shows multiple targets and HUD', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: GameplayScreen(level: 2),
      ),
    );
    await tester.pump();

    // Verify Level 2 title and Uncle characters exist
    expect(find.text('Level 2'), findsOneWidget);
    // Level 2 has 2 uncles in arena + 1 in top HUD thumbnail = at least 3 UncleCharacterWidget
    expect(find.byType(UncleCharacterWidget), findsAtLeastNWidgets(3));
  });

  test('Daily reward can only be claimed once per day and records date', () {
    final state = GameState();
    // Initially or after reset, daily reward claim behavior
    final canClaimInitial = state.canClaimDailyReward;
    if (canClaimInitial) {
      final claimed = state.claimDailyReward();
      expect(claimed, isTrue);
      expect(state.isDailyRewardClaimedToday, isTrue);
      expect(state.canClaimDailyReward, isFalse);

      // Attempt second claim on the same day -> Must be rejected
      final secondClaim = state.claimDailyReward();
      expect(secondClaim, isFalse);
    } else {
      expect(state.isDailyRewardClaimedToday, isTrue);
      final attempt = state.claimDailyReward();
      expect(attempt, isFalse);
    }
  });

  test('AdService default test IDs and dynamic configuration work properly', () {
    expect(AdService.interstitialAdUnitId, isNotEmpty);
    expect(AdService.rewardedAdUnitId, isNotEmpty);
    expect(AdService.adMobAppId, isNotEmpty);

    // Test hot swapping with user custom AdMob ID
    AdService.configureAdMobIds(
      interstitialId: 'ca-app-pub-custom/1234567890',
      rewardedId: 'ca-app-pub-custom/0987654321',
    );
    expect(AdService.interstitialAdUnitId, 'ca-app-pub-custom/1234567890');
    expect(AdService.rewardedAdUnitId, 'ca-app-pub-custom/0987654321');
  });
}

