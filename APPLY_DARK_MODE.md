# Applying Dark Mode - Implementation Guide

## Quick Summary

Dark mode is now functional! The toggle in Settings works and saves your preference. However, to see dark mode applied across all screens, we need to update each screen and widget to use theme-aware colors.

## Implementation Status

✅ **Infrastructure Complete:**
- ThemeProvider created and working
- Dark mode colors defined (3 colors only!)
- Theme toggle in Settings connected
- Preference saves across app restarts

⚠️ **Screens Need Update:**
- Need to use `Consumer<ThemeProvider>` in each screen
- Replace hardcoded colors with theme-aware methods

## How to Apply Dark Mode to Any Screen

### Step 1: Add Import
```dart
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
```

### Step 2: Wrap build() with Consumer
```dart
@override
Widget build(BuildContext context) {
  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, _) {
      final isDark = themeProvider.isDarkMode;
      
      return Scaffold(
        // Your screen content...
      );
    },
  );
}
```

### Step 3: Replace Colors
**Before:**
```dart
backgroundColor: DesignSystem.primaryWhite,
color: DesignSystem.primaryBlack,
border: DesignSystem.border,
```

**After:**
```dart
backgroundColor: DesignSystem.backgroundColor(isDark),
color: DesignSystem.textColor(isDark),
border: DesignSystem.themeBorder(isDark),
```

## Color Replacement Guide

| Hardcoded | Replace With |
|-----------|--------------|
| `primaryWhite` | `backgroundColor(isDark)` |
| `primaryBlack` | `textColor(isDark)` |
| `border` | `themeBorder(isDark)` |
| `borderSide` | `themeBorderSide(isDark)` |
| `shadowSmall` | `themeShadowSmall(isDark)` |

## Screens to Update

1. ✅ **Settings Screen** - Partially done
2. **Home Library Screen**
3. **Book Reader Screen**
4. **Bookmarks Screen**
5. **Highlights Screen**
6. **Onboarding Screen**

## Widgets to Update

1. **MobileHeader** - Header bar
2. **BottomNav** - Navigation bar
3. **BookCard** - Book display cards
4. **BrutalButton** - All buttons
5. **BrutalInput** - Input fields
6. **BrutalCard** - Card containers
7. **BrutalModal** - Modal dialogs

## Example: Complete Screen Update

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/design_system.dart';
import '../providers/theme_provider.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkMode;
        
        return Scaffold(
          backgroundColor: DesignSystem.backgroundColor(isDark),
          body: Container(
            decoration: BoxDecoration(
              border: DesignSystem.themeBorder(isDark),
            ),
            child: Column(
              children: [
                Text(
                  'Hello',
                  style: DesignSystem.textBase.copyWith(
                    color: DesignSystem.textColor(isDark),
                  ),
                ),
                Container(
                  color: DesignSystem.cardColor(isDark),
                  child: Text('Card content'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

## Testing Dark Mode

1. Run the app
2. Go to Settings
3. Toggle "DARK MODE"
4. App should hot reload with new theme
5. Navigate between screens
6. Theme should persist

## Next Steps

For full dark mode support, update in this order:

1. **Reusable Widgets First** (MobileHeader, BottomNav, etc.)
   - These affect all screens at once
   - Biggest impact with least code

2. **Main Screens** (Home, Reader, etc.)
   - Update one at a time
   - Test after each update

3. **Modals & Dialogs**
   - Update as needed
   - Less frequently used

## Common Patterns

### Container with Border
```dart
Container(
  decoration: BoxDecoration(
    color: DesignSystem.cardColor(isDark),
    border: DesignSystem.themeBorder(isDark),
    boxShadow: DesignSystem.themeShadowSmall(isDark),
  ),
  child: // content
)
```

### Text Styling
```dart
Text(
  'My Text',
  style: DesignSystem.textBase.copyWith(
    color: DesignSystem.textColor(isDark),
  ),
)
```

### Icons
```dart
Icon(
  Icons.home,
  color: DesignSystem.textColor(isDark),
)
```

## Remember

- Always pass `isDark` from Consumer
- Use theme-aware methods consistently
- Test in both light and dark modes
- Keep the brutal design aesthetic!

Dark mode is ready to roll out! 🌙
