import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/arch_container.dart';
import '../../domain/models/student.dart';
import '../../domain/student_providers.dart';

/// Student card matching the Stitch design: arch avatar, mastery %, progress bar.
class StudentCard extends ConsumerWidget {
  final Student student;
  final VoidCallback onTap;

  const StudentCard({super.key, required this.student, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordAsync = ref.watch(dailyRecordProvider(student.id));
    final percentage = recordAsync.whenOrNull(
      data: (record) => (record.completionPercentage * 100).round(),
    ) ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: avatar + mastery
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Arch avatar
                ArchClip(
                  width: 64,
                  height: 88,
                  child: Container(
                    color: AppColors.surfaceContainerHighest,
                    child: Center(
                      child: Text(
                        student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                        style: GoogleFonts.notoSerif(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Mastery level
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$percentage%',
                      style: GoogleFonts.notoSerif(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                    Text(
                      'MASTERY LEVEL',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 9,
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            // Name
            Text(
              student.name,
              style: GoogleFonts.notoSerif(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Subtitle
            Text(
              student.levelOfStudy.isNotEmpty
                  ? student.levelOfStudy
                  : 'New Student',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.lg),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 4,
                backgroundColor: AppColors.surfaceContainerHighest,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
