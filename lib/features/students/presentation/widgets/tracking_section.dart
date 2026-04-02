import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/arch_container.dart';

/// Tracking section with mihrab arch shape, matching the Stitch profile mockup.
class TrackingSection extends StatelessWidget {
  final String titleArabic;
  final String titleEnglish;
  final Map<String, bool> items;
  final Map<String, IconData> icons;
  final void Function(String key, bool value) onToggle;

  const TrackingSection({
    super.key,
    required this.titleArabic,
    required this.titleEnglish,
    required this.items,
    required this.icons,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Text(
              titleArabic,
              style: GoogleFonts.notoSerif(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              titleEnglish,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        // Arch container with checklist
        ArchContainer(
          child: Column(
            children: items.entries.map((entry) {
              final isDone = entry.value;
              final icon = icons[entry.key];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: GestureDetector(
                  onTap: () => onToggle(entry.key, !isDone),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isDone ? 1.0 : 0.6,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: isDone,
                            onChanged: (v) => onToggle(entry.key, v ?? false),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: Text(
                            entry.key,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  decoration: isDone ? TextDecoration.none : null,
                                ),
                          ),
                        ),
                        if (icon != null)
                          Icon(
                            icon,
                            color: AppColors.secondary,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
