import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Streak counter card with fire icon, matching the Stitch profile mockup.
class StreakCounter extends StatelessWidget {
  final int streak;
  final int personalBest;

  const StreakCounter({
    super.key,
    required this.streak,
    this.personalBest = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Row(
        children: [
          // Fire icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: AppColors.onSecondaryContainer,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          // Streak info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CURRENT STREAK',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                ),
                Text(
                  '$streak Day${streak == 1 ? '' : 's'}',
                  style: GoogleFonts.notoSerif(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          if (personalBest > 0)
            Text(
              'Personal Best: $personalBest',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
        ],
      ),
    );
  }
}
