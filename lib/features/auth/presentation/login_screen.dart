import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/mashrabiya_background.dart';
import '../domain/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isSignUpMode = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter email and password');
      return;
    }

    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    setState(() => _isLoading = true);

    final notifier = ref.read(authNotifierProvider.notifier);
    final String? error;

    if (_isSignUpMode) {
      error = await notifier.signUp(email, password);
    } else {
      error = await notifier.login(email, password);
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      _showError(error);
    } else if (_isSignUpMode) {
      _showSuccess('Account created! Please check your email to confirm, then log in.');
      setState(() => _isSignUpMode = false);
    } else {
      context.go('/students');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryContainer,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MashrabiyaBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
                _buildLogo(),
                const SizedBox(height: AppSpacing.sectionGap),
                _buildWelcomeText(),
                const SizedBox(height: AppSpacing.xxxl),
                _buildForm(),
                const SizedBox(height: AppSpacing.xxxl),
                _buildActions(),
                const SizedBox(height: AppSpacing.xxxl),
                _buildToggleMode(),
                const SizedBox(height: AppSpacing.xxxl),
                _buildFooter(),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        const Icon(
          Icons.menu_book,
          color: AppColors.primaryContainer,
          size: 28,
        ),
        const SizedBox(width: 12),
        Text(
          'The Archivist',
          style: GoogleFonts.notoSerif(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: AppColors.primaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isSignUpMode ? 'Create\nAccount' : 'Welcome\nBack',
          style: GoogleFonts.notoSerif(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          _isSignUpMode
              ? 'Begin your scholarly journey. Create an account to start tracking progress.'
              : 'Continue your journey through the manuscripts. Your collection awaits your scholarly touch.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('EMAIL'),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurface,
              ),
          decoration: const InputDecoration(
            hintText: 'archivist@scholarly.edu',
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _buildFieldLabel('PASSWORD'),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurface,
              ),
          decoration: InputDecoration(
            hintText: _isSignUpMode ? 'Min 6 characters' : '••••••••••••',
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.outlineVariant,
              ),
            ),
          ),
          onSubmitted: (_) => _handleSubmit(),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
    );
  }

  Widget _buildActions() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onPrimary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_isSignUpMode ? 'Create Account' : 'Log In to Archive'),
                  const SizedBox(width: 12),
                  Icon(_isSignUpMode ? Icons.person_add : Icons.login, size: 20),
                ],
              ),
      ),
    );
  }

  Widget _buildToggleMode() {
    return Container(
      padding: const EdgeInsets.only(top: AppSpacing.xxl),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant.withAlpha(26)),
        ),
      ),
      child: Row(
        children: [
          Text(
            _isSignUpMode ? 'Already have\nan account?' : 'New to the\ncollection?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(width: AppSpacing.lg),
          GestureDetector(
            onTap: () => setState(() => _isSignUpMode = !_isSignUpMode),
            child: Row(
              children: [
                Text(
                  _isSignUpMode ? 'Log in\ninstead' : 'Create an\naccount',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.secondary,
                      ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Icon(
                  Icons.arrow_forward,
                  color: AppColors.secondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text(
        'Est. 2024 — Al-Andalus Modern',
        style: GoogleFonts.notoSerif(
          fontSize: 12,
          fontStyle: FontStyle.italic,
          color: AppColors.primary.withAlpha(102),
          letterSpacing: 2,
        ),
      ),
    );
  }
}
