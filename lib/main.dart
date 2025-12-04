import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'theme/design_system.dart';
import 'providers/theme_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_library_screen.dart';
import 'screens/book_reader_screen.dart';
import 'screens/highlights_screen.dart';
import 'screens/bookmarks_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const ReadSmartApp(),
    ),
  );
}

class ReadSmartApp extends StatelessWidget {
  const ReadSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkMode;

        // Update global design system font
        DesignSystem.currentFontFamily = themeProvider.getFontFamilyName();

        // Get the appropriate text theme based on font family
        TextTheme getTextTheme() {
          switch (themeProvider.fontFamily) {
            case FontFamily.lora:
              return GoogleFonts.loraTextTheme();
            case FontFamily.merriweather:
              return GoogleFonts.merriweatherTextTheme();
            case FontFamily.crimsonText:
              return GoogleFonts.crimsonTextTextTheme();
          }
        }

        return MaterialApp(
          title: 'ReadSmart',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: DesignSystem.textColor(isDark),
            scaffoldBackgroundColor: DesignSystem.backgroundColor(isDark),
            textTheme: getTextTheme().apply(
              bodyColor: DesignSystem.textColor(isDark),
              displayColor: DesignSystem.textColor(isDark),
            ),
            colorScheme: ColorScheme(
              brightness: isDark ? Brightness.dark : Brightness.light,
              primary: DesignSystem.textColor(isDark),
              onPrimary: DesignSystem.backgroundColor(isDark),
              secondary: DesignSystem.textColor(isDark),
              onSecondary: DesignSystem.backgroundColor(isDark),
              error: Colors.red,
              onError: DesignSystem.primaryWhite,
              surface: DesignSystem.cardColor(isDark),
              onSurface: DesignSystem.textColor(isDark),
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
      },
    );
  }
}
