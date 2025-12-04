# 📚 ReadSmart

A modern, cross-platform eBook reader built with Flutter that allows you to read, highlight, and bookmark your favorite books with ease.

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-blue)]()

---

## ✨ Features

### 📖 Reading Experience
- **Multi-Format Support**: Read EPUB and PDF files seamlessly
- **Customizable Reading**: Adjust font family (Lora, Merriweather, Crimson Text)
- **Dark Mode**: Eye-friendly dark theme for comfortable night reading
- **Responsive Design**: Optimized for all screen sizes and platforms

### 🎯 Organization & Management
- **Personal Library**: Organize your books with custom covers and metadata
- **Smart Search**: Quickly find books in your collection
- **Book Management**: Add, edit, and delete books with ease
- **File Import**: Import books from your device using file picker

### 📝 Annotations & Notes
- **Text Highlighting**: Highlight important passages while reading
- **Bookmarks**: Save your reading position and favorite pages
- **Highlights Screen**: Review all your highlights in one place
- **Bookmarks Screen**: Access all your bookmarked pages quickly

### 🎨 User Interface
- **Brutalist Design**: Modern, bold UI with strong visual hierarchy
- **Onboarding Flow**: Smooth introduction for new users
- **Bottom Navigation**: Easy access to Library, Highlights, Bookmarks, and Profile
- **Custom Widgets**: Reusable brutal-style components (buttons, cards, inputs, modals)

### ⚙️ Settings & Customization
- **Theme Toggle**: Switch between light and dark modes
- **Font Selection**: Choose from multiple serif fonts optimized for reading
- **Profile Management**: Personalize your reading experience
- **Persistent Storage**: All preferences saved locally

---

## 🛠️ Technologies Used

### Core Framework
- **Flutter** (SDK 3.9.2+) - Cross-platform UI framework
- **Dart** (3.9.2+) - Programming language

### Key Dependencies
- **State Management**: `provider` (6.1.1) - App-wide state management
- **UI Components**: 
  - `google_fonts` (6.1.0) - Custom typography
  - `cupertino_icons` (1.0.8) - iOS-style icons
- **File Handling**:
  - `file_picker` (8.1.4) - Import books from device
  - `image_picker` (1.0.4) - Custom book covers
- **Document Viewers**:
  - `syncfusion_flutter_pdfviewer` (27.1.48) - PDF rendering
  - `epub_view` (3.0.1) - EPUB rendering
  - `flutter_html` (3.0.0-beta.2) - HTML content rendering
- **Storage**: `shared_preferences` (2.2.2) - Local data persistence

### Development Tools
- `flutter_lints` (5.0.0) - Code quality and best practices
- `flutter_launcher_icons` (0.11.0) - App icon generation

---

## 📦 Installation Guide

### Prerequisites
Before you begin, ensure you have the following installed:
- **Flutter SDK** (3.9.2 or higher) - [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (3.9.2 or higher) - Included with Flutter
- **Git** - [Install Git](https://git-scm.com/downloads)

#### Platform-Specific Requirements
- **Android**: Android Studio with Android SDK (API 21+)
- **iOS**: Xcode 14+ (macOS only)
- **Web**: Chrome browser
- **Windows**: Visual Studio 2022 with C++ tools
- **macOS**: Xcode Command Line Tools
- **Linux**: Required development libraries

### Step-by-Step Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/read_smart.git
   cd read_smart
   ```

2. **Verify Flutter Installation**
   ```bash
   flutter doctor
   ```
   Ensure all required components are installed.

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Generate App Icons** (Optional)
   ```bash
   flutter pub run flutter_launcher_icons
   ```
   Or use the PowerShell script:
   ```powershell
   .\generate_icons.ps1
   ```

5. **Run the Application**
   
   **For Web:**
   ```bash
   flutter run -d chrome
   ```
   
   **For Android:**
   ```bash
   flutter run -d android
   ```
   
   **For iOS:**
   ```bash
   flutter run -d ios
   ```
   
   **For Windows:**
   ```bash
   flutter run -d windows
   ```
   
   **For macOS:**
   ```bash
   flutter run -d macos
   ```
   
   **For Linux:**
   ```bash
   flutter run -d linux
   ```

---

## 🚀 Usage Instructions

### First Launch
1. **Onboarding**: When you first open ReadSmart, you'll be greeted with an onboarding screen introducing the app's features.
2. **Skip or Continue**: Navigate through the onboarding or skip directly to your library.

### Adding Books
1. Navigate to the **Library** tab
2. Tap the **"Add Book"** button (+ icon)
3. Choose to:
   - **Upload EPUB/PDF**: Select a file from your device
   - **Manual Entry**: Add book details manually with custom cover
4. Fill in book information (title, author, cover image)
5. Tap **"Add Book"** to save

### Reading Books
1. Tap on any book card in your library
2. The book reader will open with your selected document
3. **Reading Controls**:
   - Tap center to show/hide controls
   - Swipe or use arrows to navigate pages
   - Tap and hold to highlight text
   - Tap bookmark icon to save current page

### Managing Highlights
1. While reading, select text to highlight
2. Choose highlight color from the dialog
3. View all highlights in the **Highlights** tab
4. Tap any highlight to jump to that location in the book

### Managing Bookmarks
1. Tap the bookmark icon while reading
2. Access all bookmarks in the **Bookmarks** tab
3. Tap any bookmark to return to that page

### Customizing Settings
1. Navigate to **Settings** from the bottom navigation
2. Toggle **Dark Mode** on/off
3. Select your preferred **Font Family**:
   - Lora (default)
   - Merriweather
   - Crimson Text
4. Changes apply immediately across the app

---

## 📁 Folder Structure

```
read_smart/
├── android/                    # Android-specific files
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   └── res/           # Android resources
│   │   └── build.gradle.kts   # Android build configuration
│   └── gradle/                # Gradle wrapper files
├── assets/                    # App assets
│   └── images/
│       └── app-icon.png       # App launcher icon
├── ios/                       # iOS-specific files
├── lib/                       # Main application code
│   ├── main.dart             # App entry point
│   ├── models/               # Data models
│   │   └── book.dart         # Book model
│   ├── providers/            # State management
│   │   └── theme_provider.dart
│   ├── screens/              # App screens
│   │   ├── add_book_modal.dart
│   │   ├── book_reader_screen.dart
│   │   ├── bookmarks_screen.dart
│   │   ├── edit_book_modal.dart
│   │   ├── highlights_screen.dart
│   │   ├── home_library_screen.dart
│   │   ├── manage_books_modal.dart
│   │   ├── onboarding_screen.dart
│   │   ├── profile_screen.dart
│   │   └── settings_screen.dart
│   ├── services/             # Business logic
│   │   └── book_storage_service.dart
│   ├── theme/                # Design system
│   │   └── design_system.dart
│   └── widgets/              # Reusable components
│       ├── book_card.dart
│       ├── bottom_nav.dart
│       ├── brutal_button.dart
│       ├── brutal_card.dart
│       ├── brutal_input.dart
│       ├── brutal_modal.dart
│       ├── highlight_dialog.dart
│       └── mobile_header.dart
├── linux/                     # Linux-specific files
├── macos/                     # macOS-specific files
├── test/                      # Unit and widget tests
├── web/                       # Web-specific files
├── windows/                   # Windows-specific files
├── .gitignore                # Git ignore rules
├── analysis_options.yaml     # Dart analyzer configuration
├── flutter_launcher_icons.yaml # Icon generation config
├── generate_icons.ps1        # Icon generation script
├── pubspec.yaml              # Dependencies and metadata
└── README.md                 # This file
```

---

## 🖼️ Screenshots

> **Note**: Screenshots showcase the app's brutalist design with dark mode support and clean typography.

### Light Mode
- **Library Screen**: Browse your book collection
- **Reader Screen**: Immersive reading experience
- **Highlights Screen**: Review your annotations

### Dark Mode
- **Settings Screen**: Customize your experience
- **Bookmarks Screen**: Quick navigation to saved pages
- **Profile Screen**: Manage your reading profile

---

## 🔧 How to Run the Project

### Development Mode

**Web (Recommended for quick testing):**
```bash
flutter run -d chrome
```

**Android (Physical Device or Emulator):**
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

**iOS (macOS only, Physical Device or Simulator):**
```bash
flutter run -d ios
```

**Desktop (Windows/macOS/Linux):**
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

### Production Build

**Android APK:**
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

**Android App Bundle (for Google Play):**
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

**iOS (macOS only):**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```
Output: `build/web/`

**Windows:**
```bash
flutter build windows --release
```
Output: `build/windows/runner/Release/`

**macOS:**
```bash
flutter build macos --release
```

**Linux:**
```bash
flutter build linux --release
```

---

## 🐛 Troubleshooting

### Common Issues

#### 1. **"Error picking file: On web path is unavailable"**
**Problem**: File picker doesn't work on web platform.
**Solution**: The app uses file bytes instead of paths for web compatibility. Ensure you're using `file_picker` 8.1.4+.

#### 2. **PDF Viewer Build Errors (Android)**
**Problem**: `syncfusion_flutter_pdfviewer` uses outdated Flutter v1 embedding.
**Solution**: 
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

#### 3. **Fonts Not Rendering Correctly (Web)**
**Problem**: Custom fonts don't load on web.
**Solution**: The app uses Google Fonts which are loaded dynamically. Ensure internet connection on first run.

#### 4. **Hot Reload Not Working**
**Problem**: Changes don't reflect after hot reload.
**Solution**: 
```bash
# Stop the app and run
flutter clean
flutter pub get
flutter run
```

#### 5. **Build Fails on Android**
**Problem**: Gradle build errors.
**Solution**:
- Update Android Studio and SDK tools
- Check `android/app/build.gradle.kts` for correct SDK versions
- Run `flutter doctor` to verify setup

#### 6. **App Icon Not Showing**
**Problem**: Custom icon doesn't appear after installation.
**Solution**:
```bash
flutter pub run flutter_launcher_icons
flutter clean
flutter build apk
```

### Platform-Specific Issues

**Web:**
- Clear browser cache if styles don't load
- Use Chrome for best compatibility
- Check browser console for errors

**Android:**
- Minimum SDK: API 21 (Android 5.0)
- Enable USB debugging on device
- Accept RSA key fingerprint prompt

**iOS:**
- Ensure valid provisioning profile
- Check Xcode version compatibility
- Run `pod install` in `ios/` directory if needed

---

## 🚧 Future Improvements

### Planned Features
- [ ] **Cloud Sync**: Sync library and annotations across devices
- [ ] **Reading Statistics**: Track reading time, pages read, and progress
- [ ] **Collections/Categories**: Organize books into custom collections
- [ ] **Reading Goals**: Set and track daily/weekly reading goals
- [ ] **Notes & Annotations**: Add text notes alongside highlights
- [ ] **Export Highlights**: Export highlights to PDF/Markdown
- [ ] **Social Features**: Share quotes and reading progress
- [ ] **Audio Books**: Support for audiobook playback
- [ ] **Dictionary Integration**: Look up word definitions while reading
- [ ] **Translation**: Translate selected text in-app
- [ ] **Night Light Filter**: Reduce blue light for night reading
- [ ] **Reading Speed Adjustment**: Customize scrolling/page turn speed
- [ ] **Backup & Restore**: Export/import library data
- [ ] **Multiple Themes**: Additional color schemes beyond light/dark
- [ ] **Gesture Controls**: Swipe gestures for navigation

### Technical Improvements
- [ ] **Offline Mode**: Full offline functionality
- [ ] **Performance Optimization**: Faster book loading and rendering
- [ ] **Accessibility**: Screen reader support and high contrast modes
- [ ] **Unit Tests**: Comprehensive test coverage
- [ ] **CI/CD Pipeline**: Automated testing and deployment
- [ ] **Localization**: Multi-language support (i18n)
- [ ] **Analytics**: User behavior insights (privacy-focused)

---

## 📄 License

This project is licensed under the **MIT License**.

```
MIT License

Copyright (c) 2025 ReadSmart

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 📧 Contact Information

**Project Maintainer**: ReadSmart Team

- **Email**: support@readsmart.app
- **GitHub**: [@yourusername/read_smart](https://github.com/yourusername/read_smart)
- **Issues**: [Report a Bug](https://github.com/yourusername/read_smart/issues)
- **Discussions**: [Join the Community](https://github.com/yourusername/read_smart/discussions)

### Contributing
We welcome contributions! Please feel free to:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Support
If you find this project helpful, please consider:
- ⭐ Starring the repository
- 🐛 Reporting bugs and issues
- 💡 Suggesting new features
- 📖 Improving documentation
- 🔀 Contributing code

---

<div align="center">

**Made with ❤️ and Flutter**

*Happy Reading! 📚*

</div>
