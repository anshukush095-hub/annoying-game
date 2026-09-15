import 'dart:math' as math;
import 'dart:typed_data';

class SoundGenerator {
  static const int sampleRate = 22050;

  /// Creates a standard 16-bit PCM Mono WAV byte array from normalized sample points (-1.0 to 1.0).
  static Uint8List createWav(List<double> samples, {int rate = sampleRate}) {
    final int byteLength = samples.length * 2;
    final int totalLength = 44 + byteLength;
    final Uint8List buffer = Uint8List(totalLength);
    final ByteData byteData = ByteData.sublistView(buffer);

    // RIFF header
    buffer.setRange(0, 4, 'RIFF'.codeUnits);
    byteData.setUint32(4, 36 + byteLength, Endian.little);
    buffer.setRange(8, 12, 'WAVE'.codeUnits);

    // fmt sub-chunk
    buffer.setRange(12, 16, 'fmt '.codeUnits);
    byteData.setUint32(16, 16, Endian.little); // PCM chunk size
    byteData.setUint16(20, 1, Endian.little); // AudioFormat: PCM (1)
    byteData.setUint16(22, 1, Endian.little); // Channels: 1 (Mono)
    byteData.setUint32(24, rate, Endian.little); // Sample rate
    byteData.setUint32(28, rate * 2, Endian.little); // Byte rate
    byteData.setUint16(32, 2, Endian.little); // Block align (1 * 16 / 8)
    byteData.setUint16(34, 16, Endian.little); // Bits per sample

    // data sub-chunk
    buffer.setRange(36, 40, 'data'.codeUnits);
    byteData.setUint32(40, byteLength, Endian.little);

    // Write samples
    int offset = 44;
    for (int i = 0; i < samples.length; i++) {
      final double s = samples[i].clamp(-1.0, 1.0);
      final int intVal = (s * 32767.0).round();
      byteData.setInt16(offset, intVal, Endian.little);
      offset += 2;
    }

    return buffer;
  }

  /// Visceral comic punch impact sound (meaty punch with low thump + transient snap)
  static Uint8List generatePunchWav() {
    final double duration = 0.18;
    final int totalSamples = (duration * sampleRate).toInt();
    final List<double> samples = List<double>.filled(totalSamples, 0.0);
    final math.Random random = math.Random(42);

    double phase = 0.0;
    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double progress = t / duration;

      // Frequency drops sharply from 260 Hz down to 45 Hz
      final double freq = 45.0 + 215.0 * math.exp(-progress * 18.0);
      phase += 2 * math.pi * freq / sampleRate;

      // Body thump
      double wave = math.sin(phase);

      // Add mild distortion harmonics
      wave = (wave * 1.5).clamp(-0.8, 0.8) / 0.8;

      // Initial transient snap (white noise in first 35ms)
      if (t < 0.035) {
        final double noiseEnv = (1.0 - (t / 0.035));
        wave += (random.nextDouble() * 2.0 - 1.0) * noiseEnv * 0.9;
      }

      // Exponential decay envelope
      final double env = math.exp(-progress * 12.0);
      samples[i] = wave * env * 0.95;
    }

    return createWav(samples);
  }

  /// Heavy comic WHAM / Whack sound (deep bass boom + cartoon crunch)
  static Uint8List generateWhackWav() {
    final double duration = 0.28;
    final int totalSamples = (duration * sampleRate).toInt();
    final List<double> samples = List<double>.filled(totalSamples, 0.0);
    final math.Random random = math.Random(108);

    double phase = 0.0;
    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double progress = t / duration;

      final double freq = 40.0 + 320.0 * math.exp(-progress * 14.0);
      phase += 2 * math.pi * freq / sampleRate;

      double wave = math.sin(phase) + 0.5 * math.sin(phase * 0.5);

      // Crunch noise
      if (t < 0.06) {
        final double noiseEnv = (1.0 - (t / 0.06));
        wave += (random.nextDouble() * 2.0 - 1.0) * noiseEnv * 1.2;
      }

      final double env = math.exp(-progress * 8.0);
      samples[i] = (wave * env * 0.9).clamp(-1.0, 1.0);
    }

    return createWav(samples);
  }

  /// Spring glove flying whoosh sound (air slice)
  static Uint8List generateWhooshWav() {
    final double duration = 0.22;
    final int totalSamples = (duration * sampleRate).toInt();
    final List<double> samples = List<double>.filled(totalSamples, 0.0);
    final math.Random random = math.Random(77);

    double lowpass = 0.0;
    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double progress = t / duration;

      // Noise generator
      final double whiteNoise = random.nextDouble() * 2.0 - 1.0;

      // Filter coefficient changes with time (whoosh sweep)
      final double cutoff = 0.05 + 0.35 * math.sin(progress * math.pi);
      lowpass += cutoff * (whiteNoise - lowpass);

      // Bell-shaped envelope
      final double env = math.sin(progress * math.pi);
      samples[i] = lowpass * env * 1.4;
    }

    return createWav(samples);
  }

  /// Bright 2-tone melodic coin pickup chime
  static Uint8List generateCoinWav() {
    final double duration = 0.25;
    final int totalSamples = (duration * sampleRate).toInt();
    final List<double> samples = List<double>.filled(totalSamples, 0.0);

    double phase1 = 0.0;
    double phase2 = 0.0;
    final int splitIndex = (0.08 * sampleRate).toInt();

    for (int i = 0; i < totalSamples; i++) {
      double wave;

      if (i < splitIndex) {
        phase1 += 2 * math.pi * 987.77 / sampleRate; // B5
        wave = math.sin(phase1) + 0.3 * math.sin(phase1 * 2);
      } else {
        final double t2 = (i - splitIndex) / sampleRate;
        phase2 += 2 * math.pi * 1318.51 / sampleRate; // E6
        final double decay = math.exp(-t2 * 14.0);
        wave = (math.sin(phase2) + 0.25 * math.sin(phase2 * 2)) * decay;
      }

      samples[i] = wave * 0.7;
    }

    return createWav(samples);
  }

  /// Victorious 5-note melodic level complete fanfare
  static Uint8List generateWinWav() {
    final double duration = 0.85;
    final int totalSamples = (duration * sampleRate).toInt();
    final List<double> samples = List<double>.filled(totalSamples, 0.0);

    // C5, E5, G5, B5, C6 notes
    final List<double> freqs = [523.25, 659.25, 783.99, 987.77, 1046.50];
    final double noteDuration = duration / (freqs.length + 1);

    double phase = 0.0;
    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      int noteIndex = (t / noteDuration).toInt();
      if (noteIndex >= freqs.length) noteIndex = freqs.length - 1;

      final double freq = freqs[noteIndex];
      phase += 2 * math.pi * freq / sampleRate;

      final double noteLocalT = t - (noteIndex * noteDuration);
      double env = 1.0;
      if (noteIndex == freqs.length - 1) {
        env = math.exp(-noteLocalT * 3.5);
      } else {
        env = math.exp(-noteLocalT * 8.0);
      }

      final double wave = (math.sin(phase) + 0.3 * math.sin(phase * 2) + 0.15 * math.sin(phase * 3)) * env;
      samples[i] = wave * 0.65;
    }

    return createWav(samples);
  }

  /// Sad cartoon loss wobble (wah-wah-wah)
  static Uint8List generateGameOverWav() {
    final double duration = 0.8;
    final int totalSamples = (duration * sampleRate).toInt();
    final List<double> samples = List<double>.filled(totalSamples, 0.0);

    double phase = 0.0;
    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double progress = t / duration;

      // Descending pitch with wobble vibrato
      final double baseFreq = 380.0 - 240.0 * progress;
      final double vibrato = 22.0 * math.sin(2 * math.pi * 9.0 * t);
      final double freq = math.max(40.0, baseFreq + vibrato);

      phase += 2 * math.pi * freq / sampleRate;
      final double wave = (math.sin(phase) > 0 ? 0.6 : -0.6) * (1.0 - progress * 0.8);
      samples[i] = wave * 0.5;
    }

    return createWav(samples);
  }

  /// Electric shock zapping sound
  static Uint8List generateElectricZapWav() {
    final double duration = 0.32;
    final int totalSamples = (duration * sampleRate).toInt();
    final List<double> samples = List<double>.filled(totalSamples, 0.0);
    final math.Random random = math.Random(999);

    double phase = 0.0;
    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double progress = t / duration;

      final double freq = 140.0 + (random.nextDouble() * 320.0);
      phase += 2 * math.pi * freq / sampleRate;

      double wave = (math.sin(phase) > 0 ? 0.7 : -0.7);
      if (random.nextDouble() < 0.15) {
        wave += (random.nextDouble() * 2.0 - 1.0) * 0.8;
      }

      final double env = math.exp(-progress * 6.0);
      samples[i] = (wave * env * 0.7).clamp(-1.0, 1.0);
    }

    return createWav(samples);
  }

  /// Frost freeze crackle sound
  static Uint8List generateFreezeWav() {
    final double duration = 0.35;
    final int totalSamples = (duration * sampleRate).toInt();
    final List<double> samples = List<double>.filled(totalSamples, 0.0);

    double phase1 = 0.0;
    double phase2 = 0.0;
    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double progress = t / duration;

      phase1 += 2 * math.pi * 1760.0 / sampleRate;
      phase2 += 2 * math.pi * 2640.0 / sampleRate;

      final double wave = (math.sin(phase1) + math.sin(phase2) * 0.7) * math.exp(-progress * 9.0);
      samples[i] = wave * 0.55;
    }

    return createWav(samples);
  }

  /// Upbeat, catchy, retro looping arcade music track (~7.1 seconds, seamless loop)
  /// Features a bouncy funk bassline, punchy arcade percussion, and cheerful playful melody!
  static Uint8List generateBgmWav() {
    const double bpm = 135.0;
    const double beatDuration = 60.0 / bpm; // ~0.444s per beat
    const int totalBeats = 16;
    final double duration = totalBeats * beatDuration;
    final int totalSamples = (duration * sampleRate).toInt();
    final List<double> samples = List<double>.filled(totalSamples, 0.0);

    const double c3 = 130.81;
    const double e3 = 164.81;
    const double f3 = 174.61;
    const double g3 = 196.00;
    const double a3 = 220.00;

    const double c4 = 261.63;
    const double e4 = 329.63;
    const double g4 = 392.00;
    const double a4 = 440.00;
    const double c5 = 523.25;
    const double d5 = 587.33;

    final List<double> bassPattern = [
      c3, c3, e3, g3, f3, f3, a3, g3,
      c3, c3, e3, g3, a3, g3, f3, g3,
    ];

    final List<double?> melodyPattern = [
      c4, e4, g4, e4, a4, g4, e4, null,
      g4, a4, c5, a4, d5, c5, g4, e4,
    ];

    double bassPhase = 0.0;
    double melodyPhase = 0.0;
    final math.Random drumNoise = math.Random(1234);

    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double currentBeat = t / beatDuration;
      final int beatIndex = currentBeat.toInt() % totalBeats;
      final double beatFraction = currentBeat - currentBeat.toInt();

      // 1. Kick Drum
      double drum = 0.0;
      if (beatIndex % 2 == 0) {
        if (beatFraction < 0.25) {
          final double kickFreq = 140.0 * math.exp(-beatFraction * 25.0) + 45.0;
          drum += math.sin(2 * math.pi * kickFreq * beatFraction) * math.exp(-beatFraction * 14.0) * 0.7;
        }
      } else {
        // 2. Snare
        if (beatFraction < 0.2) {
          final double noise = (drumNoise.nextDouble() * 2.0 - 1.0);
          drum += noise * math.exp(-beatFraction * 18.0) * 0.45;
        }
      }
      // 3. Hi-Hat
      final double halfBeatFraction = (currentBeat * 2) - (currentBeat * 2).toInt();
      if (halfBeatFraction < 0.06) {
        drum += (drumNoise.nextDouble() * 2.0 - 1.0) * math.exp(-halfBeatFraction * 50.0) * 0.2;
      }

      // 4. Bass Line
      final double bassFreq = bassPattern[beatIndex];
      bassPhase += 2 * math.pi * bassFreq / sampleRate;
      final double bassEnv = math.exp(-beatFraction * 4.5);
      final double bassWave = (math.sin(bassPhase) + 0.4 * math.sin(bassPhase * 2)) * bassEnv * 0.55;

      // 5. Melody
      double melodyWave = 0.0;
      final double? melFreq = melodyPattern[beatIndex];
      if (melFreq != null) {
        melodyPhase += 2 * math.pi * melFreq / sampleRate;
        final double melEnv = math.exp(-beatFraction * 3.8);
        melodyWave = (math.sin(melodyPhase) + 0.2 * math.sin(melodyPhase * 3)) * melEnv * 0.45;
      }

      final double mixed = (drum + bassWave + melodyWave) * 0.65;
      samples[i] = mixed.clamp(-1.0, 1.0);
    }

    return createWav(samples);
  }

  /// Rolling Tornado Drill sound (mechanical high-speed spin whir)
  static Uint8List generateRollingDrillWav() {
    final double duration = 0.35;
    final int totalSamples = (duration * sampleRate).toInt();
    final List<double> samples = List<double>.filled(totalSamples, 0.0);

    double phase = 0.0;
    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double progress = t / duration;

      final double freq = 180.0 + 360.0 * math.sin(progress * math.pi) + (i % 7 == 0 ? 80.0 : 0.0);
      phase += 2 * math.pi * freq / sampleRate;

      final double env = math.sin(progress * math.pi);
      final double wave = (math.sin(phase) + 0.5 * math.sin(phase * 2)) * env * 0.7;
      samples[i] = wave.clamp(-1.0, 1.0);
    }

    return createWav(samples);
  }

  /// Rocket Fire Thruster roar & explosion
  static Uint8List generateRocketBlastWav() {
    final double duration = 0.38;
    final int totalSamples = (duration * sampleRate).toInt();
    final List<double> samples = List<double>.filled(totalSamples, 0.0);
    final math.Random random = math.Random(555);

    double phase = 0.0;
    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double progress = t / duration;

      final double freq = 160.0 * math.exp(-progress * 8.0) + 40.0;
      phase += 2 * math.pi * freq / sampleRate;

      double wave = math.sin(phase) * 0.7;
      final double noise = (random.nextDouble() * 2.0 - 1.0);
      wave += noise * (1.0 - progress * 0.5) * 0.5;

      final double env = math.exp(-progress * 6.0);
      samples[i] = (wave * env * 0.85).clamp(-1.0, 1.0);
    }

    return createWav(samples);
  }

  /// Comic Mallet Hammer BONK sound (squeak + wooden crack)
  static Uint8List generateHammerBonkWav() {
    final double duration = 0.3;
    final int totalSamples = (duration * sampleRate).toInt();
    final List<double> samples = List<double>.filled(totalSamples, 0.0);

    double phase = 0.0;
    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double progress = t / duration;

      // Squeaky cartoon attack into solid wood hollow thump
      final double freq = progress < 0.2 ? (800.0 - progress * 1500.0) : (120.0 * math.exp(-progress * 12.0) + 50.0);
      phase += 2 * math.pi * freq / sampleRate;

      final double env = math.exp(-progress * 10.0);
      final double wave = (math.sin(phase) + 0.4 * math.sin(phase * 3)) * env * 0.8;
      samples[i] = wave.clamp(-1.0, 1.0);
    }

    return createWav(samples);
  }

  /// Sci-Fi Plasma Laser Beam zap
  static Uint8List generateLaserBlastWav() {
    final double duration = 0.25;
    final int totalSamples = (duration * sampleRate).toInt();
    final List<double> samples = List<double>.filled(totalSamples, 0.0);

    double phase = 0.0;
    for (int i = 0; i < totalSamples; i++) {
      final double t = i / sampleRate;
      final double progress = t / duration;

      // Laser pitch drops sharply from 1800Hz to 120Hz
      final double freq = 120.0 + 1680.0 * math.exp(-progress * 16.0);
      phase += 2 * math.pi * freq / sampleRate;

      final double wave = (math.sin(phase) > 0 ? 0.6 : -0.6) * math.exp(-progress * 8.0);
      samples[i] = wave.clamp(-1.0, 1.0);
    }

    return createWav(samples);
  }
}
