import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/game_state.dart';
import 'services/audio_manager.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set immersive full-screen edge-to-edge styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D47A1),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize GameState with persistence
  final gameState = GameState();
  await gameState.init();

  // Preload and initialize audio manager & synthesizer
  await AudioManager().init();

  runApp(const AnnoyingGameApp());
}

class AnnoyingGameApp extends StatelessWidget {
  const AnnoyingGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Annoying Punch Uncle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF1E88E5),
        scaffoldBackgroundColor: const Color(0xFF4FC3F7),
        textTheme: GoogleFonts.fredokaTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.dark,
        ),
      ),
      builder: (context, child) {
        // Responsive Layout wrapper:
        // Centers game on wide screens/tablets with a clean arcade frame
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 650) {
              // Tablet / Desktop / Wide Landscape Layout
              return Container(
                color: const Color(0xFF0D47A1),
                alignment: Alignment.center,
                child: SizedBox(
                  width: 480,
                  height: constraints.maxHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(constraints.maxWidth > 800 ? 20 : 0),
                    child: child ?? const SizedBox(),
                  ),
                ),
              );
            }
            // Standard Phone Portrait / Landscape Layout
            return child ?? const SizedBox();
          },
        );
      },
      home: const SplashScreen(),
    );
  }
}
