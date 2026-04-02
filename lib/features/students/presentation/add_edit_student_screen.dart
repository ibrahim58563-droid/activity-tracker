import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../auth/domain/auth_providers.dart';
import '../domain/models/student.dart';
import '../domain/student_providers.dart';

const _uuid = Uuid();

class AddEditStudentScreen extends ConsumerStatefulWidget {
  final String? studentId;

  const AddEditStudentScreen({super.key, this.studentId});

  bool get isEditing => studentId != null;

  @override
  ConsumerState<AddEditStudentScreen> createState() => _AddEditStudentScreenState();
}

class _AddEditStudentScreenState extends ConsumerState<AddEditStudentScreen> {
  final _nameController = TextEditingController();
  final _yearController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedLevel = 'Intermediate Grammar';
  bool _isLoading = false;
  bool _initialized = false;

  static const _levels = [
    'Advanced Manuscript Studies',
    'Intermediate Grammar',
    'Foundational Rhetoric',
    'Classical Logic',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initializeFromStudent(Student student) {
    if (_initialized) return;
    _initialized = true;
    _nameController.text = student.name;
    _yearController.text = student.academicYear;
    _notesController.text = student.notes;
    if (_levels.contains(student.levelOfStudy)) {
      _selectedLevel = student.levelOfStudy;
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the student\'s name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(studentRepositoryProvider);

      if (widget.isEditing) {
        final existing = await repo.getStudent(widget.studentId!);
        if (existing != null) {
          final updated = existing.copyWith(
            name: name,
            levelOfStudy: _selectedLevel,
            academicYear: _yearController.text.trim(),
            notes: _notesController.text.trim(),
          );
          await repo.updateStudent(updated);
        }
      } else {
        final userId = ref.read(currentUserIdProvider) ?? '';
        final student = Student(
          id: _uuid.v4(),
          userId: userId,
          name: name,
          levelOfStudy: _selectedLevel,
          academicYear: _yearController.text.trim(),
          notes: _notesController.text.trim(),
          createdAt: DateTime.now(),
        );
        await repo.addStudent(student);
      }

      ref.invalidate(studentsProvider);

      if (mounted) {
        setState(() => _isLoading = false);
        context.go('/students');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _delete() async {
    if (!widget.isEditing) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: const Text(
          'This will permanently delete this student and all their records. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(studentRepositoryProvider).deleteStudent(widget.studentId!);
      ref.invalidate(studentsProvider);
      if (mounted) context.go('/students');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting student: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If editing, load student data
    if (widget.isEditing) {
      final studentAsync = ref.watch(studentProvider(widget.studentId!));
      studentAsync.whenData((student) {
        if (student != null) _initializeFromStudent(student);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('/students'),
        ),
        title: Text(
          widget.isEditing ? 'Edit Student' : 'Add Student',
          style: GoogleFonts.notoSerif(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              'The Archivist',
              style: GoogleFonts.notoSerif(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppColors.primaryContainer,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.primary.withAlpha(26),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pageMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xl),

            // Avatar section
            Center(child: _buildAvatar()),
            const SizedBox(height: AppSpacing.xxxl),

            // Form fields
            _buildFormFields(context),
            const SizedBox(height: AppSpacing.xxl),

            // Registration tip
            _buildTipBox(context),
            const SizedBox(height: AppSpacing.xxl),

            // Action buttons
            _buildActions(context),
            const SizedBox(height: 120), // Bottom padding for nav
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Column(
      children: [
        // Main avatar
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 160,
              height: 210,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.archRadius),
                  topRight: Radius.circular(AppSpacing.archRadius),
                  bottomLeft: Radius.circular(AppSpacing.radiusXl),
                  bottomRight: Radius.circular(AppSpacing.radiusXl),
                ),
                border: Border.all(
                  color: AppColors.surfaceContainerLowest,
                  width: 4,
                ),
              ),
              child: Center(
                child: Text(
                  _nameController.text.isNotEmpty
                      ? _nameController.text[0].toUpperCase()
                      : '?',
                  style: GoogleFonts.notoSerif(
                    fontSize: 64,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            // Camera button
            Positioned(
              bottom: -16,
              right: 16,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onSurface.withAlpha(26),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.photo_camera,
                  color: AppColors.onSecondary,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        _buildSectionLabel('STUDENT IDENTITY'),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _nameController,
          onChanged: (_) => setState(() {}), // Update avatar letter
          style: GoogleFonts.notoSerif(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
          decoration: const InputDecoration(
            hintText: 'Full Name',
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Level + Year row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level of Study
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel('LEVEL OF STUDY'),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String>(
                    value: _selectedLevel,
                    decoration: const InputDecoration(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurface,
                        ),
                    items: _levels
                        .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _selectedLevel = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xxl),
            // Academic Year
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel('ACADEMIC YEAR'),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _yearController,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: '1445 AH',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Notes
        _buildSectionLabel('SCHOLARLY NOTES'),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          child: TextField(
            controller: _notesController,
            maxLines: 4,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Enter observational notes regarding student progress and character development...',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppSpacing.cardPadding),
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant.withAlpha(128),
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
    );
  }

  Widget _buildTipBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(AppSpacing.radiusXl),
          bottomRight: Radius.circular(AppSpacing.radiusXl),
        ),
        border: Border(
          left: BorderSide(color: AppColors.secondary, width: 4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.secondary, size: 20),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Registration Tip',
                  style: GoogleFonts.notoSerif(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ensure the student\'s name matches their official registry. This maintains continuity across the digital archives.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        height: 1.6,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _save,
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.onPrimary,
                        ),
                      )
                    : const Icon(Icons.save, size: 18),
                label: Text(widget.isEditing ? 'Save Changes' : 'Add Student'),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: FilledButton(
                onPressed: () => context.go('/students'),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
        if (widget.isEditing) ...[
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Delete Student'),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
            ),
          ),
        ],
      ],
    );
  }
}
