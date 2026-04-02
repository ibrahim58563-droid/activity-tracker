import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/student_providers.dart';

/// Dark primary card showing class-level aggregate insights.
class ClassInsightsCard extends StatelessWidget {
  final ClassInsights insights;

  const ClassInsightsCard({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Stack(
        children: [
          // Decorative gold accent
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: AppColors.secondary.withAlpha(51),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Class Insights',
                style: GoogleFonts.notoSerif(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Wrap(
                spacing: AppSpacing.xxxl,
                runSpacing: AppSpacing.xl,
                children: [
                  _InsightItem(
                    label: 'Average Progress',
                    value: '${(insights.averageProgress * 100).toStringAsFixed(1)}%',
                    icon: Icons.trending_up,
                  ),
                  _InsightItem(
                    label: 'Total Students',
                    value: '${insights.totalStudents}',
                    subtitle: 'Registered scholars',
                  ),
                  _InsightItem(
                    label: 'Active Today',
                    value: '${insights.activeToday}',
                    subtitle: 'Currently tracking',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final String? subtitle;

  const _InsightItem({
    required this.label,
    required this.value,
    this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: AppColors.onPrimary.withAlpha(153),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: GoogleFonts.notoSerif(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: AppColors.onPrimary,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Icon(icon, color: AppColors.secondary, size: 24),
              ),
            ],
          ],
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: AppColors.onPrimary.withAlpha(102),
            ),
          ),
      ],
    );
  }
}
