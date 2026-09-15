import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'sound_generator.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  bool soundEnabled = true;
  bool musicEnabled = true;
  double musicVolume = 0.7;
  double sfxVolume = 0.8;
  bool vibrationEnabled = true;

  // Audio Players
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final List<AudioPlayer> _sfxPool = [];
  int _sfxPoolIndex = 0;
  static const int _poolSize = 8;

  // Cached audio byte buffers
  Uint8List? _punchBytes;
  Uint8List? _whackBytes;
  Uint8List? _whooshBytes;
  Uint8List? _coinBytes;
  Uint8List? _winBytes;
  Uint8List? _gameOverBytes;
  Uint8List? _zapBytes;
  Uint8List? _freezeBytes;
  Uint8List? _bgmBytes;

  bool _initialized = false;
  bool _isBgmPlaying = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Generate audio bytes asynchronously in background
    try {
      _punchBytes = SoundGenerator.generatePunchWav();
      _whackBytes = SoundGenerator.generateWhackWav();
      _whooshBytes = SoundGenerator.generateWhooshWav();
      _coinBytes = SoundGenerator.generateCoinWav();
      _winBytes = SoundGenerator.generateWinWav();
      _gameOverBytes = SoundGenerator.generateGameOverWav();
      _zapBytes = SoundGenerator.generateElectricZapWav();
      _freezeBytes = SoundGenerator.generateFreezeWav();
      _bgmBytes = SoundGenerator.generateBgmWav();

      // Configure BGM player
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(musicVolume);

      // Pre-instantiate SFX pool for zero-lag instant punch sounds
      for (int i = 0; i < _poolSize; i++) {
        final player = AudioPlayer();
        await player.setReleaseMode(ReleaseMode.stop);
        _sfxPool.add(player);
      }

      if (musicEnabled) {
        startBackgroundMusic();
      }
    } catch (_) {
      // Audio fallback is gracefully supported
    }
  }

  Future<void> startBackgroundMusic() async {
    if (!musicEnabled || _isBgmPlaying) return;
    try {
      _bgmBytes ??= SoundGenerator.generateBgmWav();
      await _bgmPlayer.setVolume(musicVolume);
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.play(BytesSource(_bgmBytes!));
      _isBgmPlaying = true;
    } catch (_) {}
  }

  Future<void> stopBackgroundMusic() async {
    try {
      await _bgmPlayer.stop();
      _isBgmPlaying = false;
    } catch (_) {}
  }

  void updateMusicVolume(double volume) {
    musicVolume = volume;
    try {
      _bgmPlayer.setVolume(musicVolume);
    } catch (_) {}
  }

  Future<void> _playBytes(Uint8List? bytes, {double volumeMultiplier = 1.0}) async {
    if (!soundEnabled || bytes == null) return;
    try {
      if (_sfxPool.isEmpty) {
        final oneShot = AudioPlayer();
        await oneShot.setVolume((sfxVolume * volumeMultiplier).clamp(0.0, 1.0));
        await oneShot.play(BytesSource(bytes));
        return;
      }
      final player = _sfxPool[_sfxPoolIndex];
      _sfxPoolIndex = (_sfxPoolIndex + 1) % _sfxPool.length;
      await player.stop();
      await player.setVolume((sfxVolume * volumeMultiplier).clamp(0.0, 1.0));
      await player.play(BytesSource(bytes));
    } catch (_) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  void playTap() {
    if (!soundEnabled) return;
    _whooshBytes ??= SoundGenerator.generateWhooshWav();
    _playBytes(_whooshBytes, volumeMultiplier: 0.5);
    SystemSound.play(SystemSoundType.click);
    if (vibrationEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  void playWhoosh() {
    if (!soundEnabled) return;
    _whooshBytes ??= SoundGenerator.generateWhooshWav();
    _playBytes(_whooshBytes, volumeMultiplier: 0.8);
  }

  void playHit() {
    if (!soundEnabled) return;
    _punchBytes ??= SoundGenerator.generatePunchWav();
    _playBytes(_punchBytes, volumeMultiplier: 1.0);
    SystemSound.play(SystemSoundType.click);
    if (vibrationEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  void playWhack() {
    if (!soundEnabled) return;
    _whackBytes ??= SoundGenerator.generateWhackWav();
    _playBytes(_whackBytes, volumeMultiplier: 1.0);
    SystemSound.play(SystemSoundType.alert);
    if (vibrationEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  void playCoin() {
    if (!soundEnabled) return;
    _coinBytes ??= SoundGenerator.generateCoinWav();
    _playBytes(_coinBytes, volumeMultiplier: 0.9);
    SystemSound.play(SystemSoundType.click);
    if (vibrationEnabled) {
      HapticFeedback.selectionClick();
    }
  }

  void playWin() {
    if (!soundEnabled) return;
    _winBytes ??= SoundGenerator.generateWinWav();
    _playBytes(_winBytes, volumeMultiplier: 1.0);
    SystemSound.play(SystemSoundType.click);
    if (vibrationEnabled) {
      HapticFeedback.vibrate();
    }
  }

  void playGameOver() {
    if (!soundEnabled) return;
    _gameOverBytes ??= SoundGenerator.generateGameOverWav();
    _playBytes(_gameOverBytes, volumeMultiplier: 0.9);
    SystemSound.play(SystemSoundType.alert);
    if (vibrationEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  void playZap() {
    if (!soundEnabled) return;
    _zapBytes ??= SoundGenerator.generateElectricZapWav();
    _playBytes(_zapBytes, volumeMultiplier: 1.0);
    if (vibrationEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  void playFreeze() {
    if (!soundEnabled) return;
    _freezeBytes ??= SoundGenerator.generateFreezeWav();
    _playBytes(_freezeBytes, volumeMultiplier: 0.9);
    if (vibrationEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  void playDrill() {
    if (!soundEnabled) return;
    final bytes = SoundGenerator.generateRollingDrillWav();
    _playBytes(bytes, volumeMultiplier: 1.0);
    if (vibrationEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  void playRocket() {
    if (!soundEnabled) return;
    final bytes = SoundGenerator.generateRocketBlastWav();
    _playBytes(bytes, volumeMultiplier: 1.0);
    if (vibrationEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  void playHammer() {
    if (!soundEnabled) return;
    final bytes = SoundGenerator.generateHammerBonkWav();
    _playBytes(bytes, volumeMultiplier: 1.0);
    if (vibrationEnabled) {
      HapticFeedback.vibrate();
    }
  }

  void playLaser() {
    if (!soundEnabled) return;
    final bytes = SoundGenerator.generateLaserBlastWav();
    _playBytes(bytes, volumeMultiplier: 0.9);
    if (vibrationEnabled) {
      HapticFeedback.lightImpact();
    }
  }
}
