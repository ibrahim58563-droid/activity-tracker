import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/top_app_bar.dart';
import '../domain/student_providers.dart';
import '../domain/models/daily_record.dart';
import 'widgets/tracking_section.dart';
import 'widgets/streak_counter.dart';
import 'widgets/daily_progress_card.dart';
import 'widgets/weekly_summary_card.dart';

class StudentProfileScreen extends ConsumerWidget {
  final String studentId;

  const StudentProfileScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentAsync = ref.watch(studentProvider(studentId));
    final recordAsync = ref.watch(dailyRecordProvider(studentId));
    final streakAsync = ref.watch(streakProvider(studentId));

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: ArchivistAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/students'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.secondary),
            onPressed: () => context.go('/edit-student/$studentId'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: studentAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.secondary),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (student) {
          if (student == null) {
            return const Center(child: Text('Student not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Student Record No. ${student.id.substring(0, 6).toUpperCase()}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 3,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        student.name,
                        style: GoogleFonts.notoSerif(
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        student.levelOfStudy.isNotEmpty
                            ? student.levelOfStudy
                            : 'Navigating the path of knowledge with discipline and devotion.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.onSurfaceVariant,
                              height: 1.6,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Streak + Daily progress row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageMargin),
                  child: Column(
                    children: [
                      StreakCounter(
                        streak: streakAsync.valueOrNull ?? 0,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      recordAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (record) => DailyProgressCard(
                          percentage: record.completionPercentage,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // Bento grid: 4 tracking sections
                recordAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.secondary),
                  ),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (record) => _buildTrackingSections(context, ref, record),
                ),
                const SizedBox(height: AppSpacing.sectionGap),

                // Weekly summary
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageMargin),
                  child: WeeklySummaryCard(studentId: studentId),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrackingSections(BuildContext context, WidgetRef ref, DailyRecord record) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageMargin),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TrackingSection(
                    titleArabic: 'عبادات',
                    titleEnglish: 'Ibadaat',
                    items: record.ibadaat,
                    icons: _ibadaatIcons,
                    onToggle: (key, value) => _toggleItem(ref, record, 'ibadaat', key, value),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: TrackingSection(
                    titleArabic: 'القرآن',
                    titleEnglish: 'Quran',
                    items: record.quran,
                    icons: _quranIcons,
                    onToggle: (key, value) => _toggleItem(ref, record, 'quran', key, value),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: TrackingSection(
                    titleArabic: 'عادات',
                    titleEnglish: 'Habits',
                    items: record.habits,
                    icons: _habitsIcons,
                    onToggle: (key, value) => _toggleItem(ref, record, 'habits', key, value),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: TrackingSection(
                    titleArabic: 'دراسة',
                    titleEnglish: 'Study',
                    items: record.study,
                    icons: _studyIcons,
                    onToggle: (key, value) => _toggleItem(ref, record, 'study', key, value),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TrackingSection(
                      titleArabic: 'عبادات',
                      titleEnglish: 'Ibadaat',
                      items: record.ibadaat,
                      icons: _ibadaatIcons,
                      onToggle: (key, value) => _toggleItem(ref, record, 'ibadaat', key, value),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: TrackingSection(
                      titleArabic: 'القرآن',
                      titleEnglish: 'Quran',
                      items: record.quran,
                      icons: _quranIcons,
                      onToggle: (key, value) => _toggleItem(ref, record, 'quran', key, value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TrackingSection(
                      titleArabic: 'عادات',
                      titleEnglish: 'Habits',
                      items: record.habits,
                      icons: _habitsIcons,
                      onToggle: (key, value) => _toggleItem(ref, record, 'habits', key, value),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: TrackingSection(
                      titleArabic: 'دراسة',
                      titleEnglish: 'Study',
                      items: record.study,
                      icons: _studyIcons,
                      onToggle: (key, value) => _toggleItem(ref, record, 'study', key, value),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _toggleItem(WidgetRef ref, DailyRecord record, String category, String key, bool value) {
    final repo = ref.read(studentRepositoryProvider);
    DailyRecord updated;

    switch (category) {
      case 'ibadaat':
        updated = record.copyWith(ibadaat: {...record.ibadaat, key: value});
        break;
      case 'quran':
        updated = record.copyWith(quran: {...record.quran, key: value});
        break;
      case 'habits':
        updated = record.copyWith(habits: {...record.habits, key: value});
        break;
      case 'study':
        updated = record.copyWith(study: {...record.study, key: value});
        break;
      default:
        return;
    }

    repo.saveDailyRecord(updated);
    ref.invalidate(dailyRecordProvider(studentId));
    ref.invalidate(studentsProvider);
  }

  static const _ibadaatIcons = {
    'Fajr Prayer': Icons.wb_twilight,
    'Morning Adhkar': Icons.auto_stories,
    'Dhuhr Prayer': Icons.wb_sunny,
    'Asr Prayer': Icons.flare,
    'Maghrib Prayer': Icons.nightlight_round,
    'Isha Prayer': Icons.nights_stay,
    'Evening Adhkar': Icons.auto_stories,
  };

  static const _quranIcons = {
    'Hifz Revision': Icons.history_edu,
    'Tafsir Study': Icons.menu_book,
    'Daily Tilawah': Icons.diamond,
  };

  static const _habitsIcons = {
    'Hydration': Icons.water_drop,
    'Daily Walk': Icons.directions_walk,
    'Digital Detox': Icons.phonelink_erase,
    'Early Bedtime': Icons.bedtime,
  };

  static const _studyIcons = {
    'Arabic Grammar': Icons.edit_note,
    'Islamic Studies': Icons.psychology,
    'Mathematics': Icons.calculate,
  };
}
