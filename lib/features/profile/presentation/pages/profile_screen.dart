
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Information
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 85,
                    width: 85,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        'assets/coin_scope.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'CoinScope',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Crypto Market & Research',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // About Section
            _buildSectionTitle('About'),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.info_outline,
              title: 'About CoinScope',
              subtitle:
                  'Explore cryptocurrency prices, market trends, '
                  'coin details, and market insights.',
            ),

            const SizedBox(height: 24),

            // Data Source Section
            _buildSectionTitle('Data Source'),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.api,
              title: 'CoinGecko API',
              subtitle:
                  'Cryptocurrency prices and market data powered by CoinGecko.',
            ),

            const SizedBox(height: 24),

            // App Information Section
            _buildSectionTitle('App Information'),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.privacy_tip_outlined,
              title: 'Local Storage',
              subtitle:
                  'Your watchlist is stored locally on your device.',
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.code,
              title: 'Built with Flutter',
              subtitle:
                  'Developed using Flutter, Dart, BLoC, Dio, and REST API integration.',
            ),

            const SizedBox(height: 32),

            Center(
              child: Text(
                'Made for crypto enthusiasts',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Icon(
          icon,
          color: AppColors.primary,
          size: 25,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
