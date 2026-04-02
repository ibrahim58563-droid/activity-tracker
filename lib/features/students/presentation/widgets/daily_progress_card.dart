import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Dark primary card showing today's completion percentage.
class DailyProgressCard extends StatelessWidget {
  final double percentage;

  const DailyProgressCard({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final pct = (percentage * 100).round();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withAlpha(15),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DAILY PROGRESS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: AppColors.onPrimary.withAlpha(178),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$pct% Complete',
                    style: GoogleFonts.notoSerif(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.auto_awesome,
                color: AppColors.onPrimary.withAlpha(128),
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 10,
              backgroundColor: AppColors.onPrimary.withAlpha(26),
              valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }
}
