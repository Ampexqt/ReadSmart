import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/design_system.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_library_screen.dart';
import 'screens/book_reader_screen.dart';
import 'screens/highlights_screen.dart';
import 'screens/bookmarks_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const ReadSmartApp());
}

class ReadSmartApp extends StatelessWidget {
  const ReadSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReadSmart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: DesignSystem.primaryBlack,
        scaffoldBackgroundColor: DesignSystem.primaryWhite,
        textTheme: GoogleFonts.spaceGroteskTextTheme().apply(
          bodyColor: DesignSystem.primaryBlack,
          displayColor: DesignSystem.primaryBlack,
        ),
        colorScheme: const ColorScheme.light(
          primary: DesignSystem.primaryBlack,
          surface: DesignSystem.primaryWhite,
          onSurface: DesignSystem.primaryBlack,
          onPrimary: DesignSystem.primaryWhite,
        ),
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeLibraryScreen(),
        '/reader': (context) => const BookReaderScreen(),
        '/highlights': (context) => const HighlightsScreen(),
        '/bookmarks': (context) => const BookmarksScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
