import 'package:flutter/material.dart';
import '../theme/design_system.dart';
import '../widgets/mobile_header.dart';
import '../widgets/brutal_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.primaryWhite,
      body: Container(
        constraints: const BoxConstraints(maxWidth: DesignSystem.maxWidth),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > DesignSystem.maxWidth
              ? (MediaQuery.of(context).size.width - DesignSystem.maxWidth) / 2
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
            // Header
            MobileHeader(
              title: 'PROFILE',
              onBack: () => Navigator.of(context).pop(),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(DesignSystem.spacingMD),
                child: Column(
                  children: [
                    // Profile Header
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: DesignSystem.grey100,
                        border: DesignSystem.border,
                        boxShadow: DesignSystem.shadowMedium,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: DesignSystem.iconSizeXL,
                        color: DesignSystem.primaryBlack,
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacingMD),
                    Text(
                      'JOHN DOE',
                      style: DesignSystem.text2XL.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.02,
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacingXS),
                    Text(
                      'john.doe@example.com',
                      style: DesignSystem.textSM.copyWith(
                        fontWeight: FontWeight.w500,
                        color: DesignSystem.grey600,
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacing2XL),
                    // Stats Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.library_books,
                            number: '12',
                            label: 'BOOKS',
                          ),
                        ),
                        const SizedBox(width: DesignSystem.spacingMD),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.bookmark,
                            number: '24',
                            label: 'BOOKMARKS',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignSystem.spacingMD),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.format_quote,
                            number: '18',
                            label: 'HIGHLIGHTS',
                          ),
                        ),
                        const SizedBox(width: DesignSystem.spacingMD),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.timer,
                            number: '45',
                            label: 'HOURS',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: DesignSystem.spacing2XL),
                    // Reading Goal
                    BrutalCard(
                      padding: const EdgeInsets.all(DesignSystem.spacingLG),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'READING GOAL',
                            style: DesignSystem.textSM.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.05,
                            ),
                          ),
                          const SizedBox(height: DesignSystem.spacingMD),
                          Container(
                            height: 16,
                            decoration: BoxDecoration(
                              color: DesignSystem.grey200,
                              border: DesignSystem.border,
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.65,
                              child: Container(
                                color: DesignSystem.primaryBlack,
                              ),
                            ),
                          ),
                          const SizedBox(height: DesignSystem.spacingSM),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '65%',
                                style: DesignSystem.textBase.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '13 / 20 books',
                                style: DesignSystem.textXS.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: DesignSystem.grey600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacing2XL),
                    // Recent Activity
                    Text(
                      'RECENT ACTIVITY',
                      style: DesignSystem.textSM.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.05,
                      ),
                    ),
                    const SizedBox(height: DesignSystem.spacingMD),
                    _buildActivityCard(
                      'Finished reading "The Great Gatsby"',
                      '2 days ago',
                    ),
                    const SizedBox(height: DesignSystem.spacingSM),
                    _buildActivityCard(
                      'Added bookmark in "1984"',
                      '3 days ago',
                    ),
                    const SizedBox(height: DesignSystem.spacingSM),
                    _buildActivityCard(
                      'Highlighted text in "To Kill a Mockingbird"',
                      '5 days ago',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String number,
    required String label,
  }) {
    return BrutalCard(
      padding: const EdgeInsets.all(DesignSystem.spacingMD),
      child: Column(
        children: [
          Icon(
            icon,
            size: DesignSystem.iconSizeLG,
            color: DesignSystem.primaryBlack,
          ),
          const SizedBox(height: DesignSystem.spacingSM),
          Text(
            number,
            style: DesignSystem.text3XL.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: DesignSystem.spacingXS),
          Text(
            label,
            style: DesignSystem.textXS.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String text, String timestamp) {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingMD),
      decoration: BoxDecoration(
        color: DesignSystem.primaryWhite,
        border: DesignSystem.border,
        boxShadow: DesignSystem.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: DesignSystem.textSM.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: DesignSystem.spacingXS),
          Text(
            timestamp,
            style: DesignSystem.textXS.copyWith(
              fontWeight: FontWeight.w500,
              color: DesignSystem.grey600,
            ),
          ),
        ],
      ),
    );
  }
}
