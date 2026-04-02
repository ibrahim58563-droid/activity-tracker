import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/top_app_bar.dart';
import '../domain/student_providers.dart';
import '../domain/models/student.dart';
import 'widgets/student_card.dart';
import 'widgets/class_insights_card.dart';

class StudentsListScreen extends ConsumerStatefulWidget {
  const StudentsListScreen({super.key});

  @override
  ConsumerState<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends ConsumerState<StudentsListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const ArchivistAppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.surfaceContainerHigh,
              child: Icon(Icons.person, color: AppColors.primary, size: 20),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/add-student'),
        backgroundColor: AppColors.primaryContainer,
        foregroundColor: AppColors.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Add Student'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.secondary,
        onRefresh: () => ref.refresh(studentsProvider.future),
        child: CustomScrollView(
          slivers: [
            // Hero section
            SliverToBoxAdapter(child: _buildHero()),
            // Search and filters
            SliverToBoxAdapter(child: _buildSearchAndFilters()),
            // Student grid or empty state
            studentsAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator(color: AppColors.secondary)),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Error: $e')),
              ),
              data: (students) {
                final filtered = _searchQuery.isEmpty
                    ? students
                    : students.where((s) =>
                        s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        s.levelOfStudy.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

                if (filtered.isEmpty) {
                  return SliverFillRemaining(child: _buildEmptyState());
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageMargin),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      mainAxisSpacing: AppSpacing.xl,
                      crossAxisSpacing: AppSpacing.xl,
                      childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => StudentCard(
                        student: filtered[index],
                        onTap: () => context.go('/students/${filtered[index].id}'),
                      ),
                      childCount: filtered.length,
                    ),
                  ),
                );
              },
            ),
            // Class insights
            SliverToBoxAdapter(child: _buildClassInsights()),
            // Bottom padding for nav bar
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageMargin, AppSpacing.xl, AppSpacing.pageMargin, AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Student Registry',
            style: GoogleFonts.notoSerif(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Cultivating wisdom through disciplined study.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageMargin, AppSpacing.lg, AppSpacing.pageMargin, AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FIND SCHOLAR',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: const InputDecoration(
              hintText: 'Search by name or cohort...',
              suffixIcon: Icon(Icons.search, color: AppColors.onSurfaceVariant),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.outlineVariant),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              _FilterChip(label: 'All Cohorts', isSelected: true),
              const SizedBox(width: AppSpacing.lg),
              _FilterChip(label: 'Active Only', isSelected: false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories,
              size: 64,
              color: AppColors.outlineVariant.withAlpha(128),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'No scholars yet',
              style: GoogleFonts.notoSerif(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Begin your collection by adding the first student to the archive.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassInsights() {
    final insightsAsync = ref.watch(classInsightsProvider);

    return insightsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (insights) {
        if (insights.totalStudents == 0) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageMargin, AppSpacing.sectionGap, AppSpacing.pageMargin, 0,
          ),
          child: ClassInsightsCard(insights: insights),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.surfaceContainerHighest
            : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.onSurface,
            ),
      ),
    );
  }
}
