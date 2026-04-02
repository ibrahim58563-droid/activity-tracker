import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/student_providers.dart';

/// Weekly summary card with bar chart visualization.
class WeeklySummaryCard extends ConsumerWidget {
  final String studentId;

  const WeeklySummaryCard({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(studentRecordsProvider(studentId));

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Scholar\'s Log',
                      style: GoogleFonts.notoSerif(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Your consistency reflects the discipline of a true scholar. Keep the flame of curiosity burning.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            height: 1.6,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          // Mini bar chart
          recordsAsync.when(
            loading: () => const SizedBox(height: 120),
            error: (_, __) => const SizedBox(height: 120),
            data: (records) {
              // Take the last 7 records
              final recent = records.take(7).toList().reversed.toList();
              if (recent.isEmpty) {
                return SizedBox(
                  height: 120,
                  child: Center(
                    child: Text(
                      'Start tracking to see your progress',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 120,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (i) {
                    final pct = i < recent.length ? recent[i].completionPercentage : 0.0;
                    final opacity = 0.2 + (pct * 0.8);
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: FractionallySizedBox(
                          heightFactor: pct > 0 ? pct : 0.05,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withAlpha((opacity * 255).round()),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          // CTA button
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.trending_up, size: 18),
            label: const Text('VIEW DETAILED INSIGHTS'),
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
