import 'package:flutter/material.dart';
import '../dialogs/interstitial_ad_dialog.dart';
import '../dialogs/rewarded_ad_dialog.dart';

/// Central Ad Service for Annoying Punch Uncle.
/// Manages AdMob unit IDs, level-complete interstitial ads, and rewarded video ads.
///
/// NOTE FOR USER:
/// Jab aapke paas apni official AdMob IDs aa jayein, aap neeche diye gaye IDs
/// ko replace kar sakte hain ya [configureAdMobIds] call kar sakte hain.
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // ===========================================================================
  // 🎯 ADMOB CONFIGURATION (Replace with your actual AdMob IDs later)
  // ===========================================================================

  /// Google AdMob App ID
  static String adMobAppId = 'ca-app-pub-4392359096361213~5921676944';

  /// Google AdMob Interstitial Ad Unit ID (Displayed after level completion)
  static String interstitialAdUnitId = 'ca-app-pub-4392359096361213/8001432416';

  /// Google AdMob Rewarded Video Ad Unit ID (Used to earn free coins)
  static String rewardedAdUnitId = 'ca-app-pub-4392359096361213/1290140678';

  /// Update AdMob IDs dynamically whenever you receive your production IDs.
  static void configureAdMobIds({
    String? appId,
    String? interstitialId,
    String? rewardedId,
  }) {
    if (appId != null) adMobAppId = appId;
    if (interstitialId != null) interstitialAdUnitId = interstitialId;
    if (rewardedId != null) rewardedAdUnitId = rewardedId;
  }

  // ===========================================================================
  // 🎬 AD DISPLAY HANDLERS
  // ===========================================================================

  /// Shows an Interstitial Ad when a level is completed.
  /// Calls [onDismissed] after the user skips or finishes watching the ad.
  Future<void> showLevelCompleteInterstitial(
    BuildContext context, {
    required VoidCallback onDismissed,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => InterstitialAdDialog(
        onClosed: onDismissed,
      ),
    );
  }

  /// Shows a Rewarded Video Ad to earn free coins for purchasing skins and gloves.
  Future<void> showRewardedAd(
    BuildContext context, {
    int rewardAmount = 500,
    VoidCallback? onRewarded,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RewardedAdDialog(
        rewardAmount: rewardAmount,
      ),
    );
    onRewarded?.call();
  }
}
