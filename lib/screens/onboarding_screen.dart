import 'package:flutter/material.dart';
import '../theme/design_system.dart';
import '../widgets/brutal_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  late PageController _pageController;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.tablet,
      iconBackgroundColor: DesignSystem.grey200,
      title: 'READ SMART',
      description:
          'Your minimalist eBook reader. No distractions, just pure reading.',
    ),
    OnboardingPage(
      icon: Icons.format_quote,
      iconBackgroundColor: DesignSystem.primaryWhite,
      title: 'HIGHLIGHT',
      description: 'Capture important moments. Save quotes that matter.',
    ),
    OnboardingPage(
      icon: Icons.bookmark,
      iconBackgroundColor: DesignSystem.grey200,
      title: 'ORGANIZE',
      description: 'Keep track of your progress. Never lose your place.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to home
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  String get _buttonText {
    return _currentPage == _pages.length - 1 ? 'GET STARTED' : 'NEXT';
  }

  void _skip() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.primaryWhite,
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints(maxWidth: DesignSystem.maxWidth),
          margin: EdgeInsets.symmetric(
            horizontal:
                MediaQuery.of(context).size.width > DesignSystem.maxWidth
                ? (MediaQuery.of(context).size.width - DesignSystem.maxWidth) /
                      2
                : 0,
          ),
          decoration: const BoxDecoration(
            border: Border(
              left: DesignSystem.borderSide,
              right: DesignSystem.borderSide,
            ),
          ),
          child: Column(
            children: [
              // Progress Indicators
              Padding(
                padding: const EdgeInsets.all(DesignSystem.spacingMD),
                child: Row(
                  children: List.generate(
                    _pages.length,
                    (index) => Expanded(
                      child: Container(
                        height: 8,
                        margin: EdgeInsets.only(
                          right: index < _pages.length - 1
                              ? DesignSystem.spacingSM
                              : 0,
                        ),
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? DesignSystem.primaryBlack
                              : DesignSystem.primaryWhite,
                          border: DesignSystem.borderSmall,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: PageView.builder(
                  itemCount: _pages.length,
                  controller: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) => _buildPage(_pages[index]),
                ),
              ),
              // Buttons
              Padding(
                padding: const EdgeInsets.all(DesignSystem.spacingMD),
                child: Column(
                  children: [
                    BrutalButton(
                      text: _buttonText,
                      onPressed: _nextPage,
                      fullWidth: true,
                      size: BrutalButtonSize.lg,
                      icon: _currentPage < _pages.length - 1
                          ? const Icon(
                              Icons.arrow_forward,
                              color: DesignSystem.primaryWhite,
                              size: DesignSystem.iconSizeMD,
                            )
                          : null,
                    ),
                    const SizedBox(height: DesignSystem.spacingSM),
                    BrutalButton(
                      text: 'SKIP',
                      onPressed: _skip,
                      variant: BrutalButtonVariant.secondary,
                      fullWidth: true,
                      size: BrutalButtonSize.lg,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(DesignSystem.spacingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: page.iconBackgroundColor,
              border: DesignSystem.border,
              boxShadow: DesignSystem.shadowSmall,
            ),
            child: Icon(
              page.icon,
              size: DesignSystem.iconSize3XL,
              color: DesignSystem.primaryBlack,
            ),
          ),
          const SizedBox(height: DesignSystem.spacing2XL),
          // Title
          Text(
            page.title,
            style: DesignSystem.text4XL.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.02,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignSystem.spacingLG),
          // Description
          Text(
            page.description,
            style: DesignSystem.textBase.copyWith(
              fontWeight: FontWeight.w500,
              color: DesignSystem.grey700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String description;

  OnboardingPage({
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.description,
  });
}
