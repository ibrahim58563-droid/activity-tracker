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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final success = await ref.read(authNotifierProvider.notifier).login(email, password);
    setState(() => _isLoading = false);

    if (success && mounted) {
      context.go('/students');
    }
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
                // Logo
                _buildLogo(),
                const SizedBox(height: AppSpacing.sectionGap),
                // Welcome text
                _buildWelcomeText(),
                const SizedBox(height: AppSpacing.xxxl),
                // Form
                _buildForm(),
                const SizedBox(height: AppSpacing.xxxl),
                // Actions
                _buildActions(),
                const SizedBox(height: AppSpacing.xxxl),
                // Create account
                _buildCreateAccount(),
                const SizedBox(height: AppSpacing.xxxl),
                // Footer
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
          'Welcome\nBack',
          style: GoogleFonts.notoSerif(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Continue your journey through the manuscripts. Your collection awaits your scholarly touch.',
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
        // Email field
        _buildFieldLabel('EMAIL OR STUDENT ID'),
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
        // Password field
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildFieldLabel('PASSWORD'),
            GestureDetector(
              onTap: () {}, // Placeholder
              child: Text(
                'Forgot Key?',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurface,
              ),
          decoration: InputDecoration(
            hintText: '••••••••••••',
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.outlineVariant,
              ),
            ),
          ),
          onSubmitted: (_) => _handleLogin(),
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
    return Column(
      children: [
        // Primary login button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.onPrimary,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Log In to Archive'),
                      SizedBox(width: 12),
                      Icon(Icons.login, size: 20),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        // Divider
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.outlineVariant.withAlpha(51),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                'OR ENTRY VIA',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.outlineVariant,
                      letterSpacing: 2,
                    ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.outlineVariant.withAlpha(51),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        // SSO buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.school, size: 18),
                label: const Text('University\nSSO', textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.public, size: 18),
                label: const Text('Global ID'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreateAccount() {
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
            'New to the\ncollection?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(width: AppSpacing.lg),
          GestureDetector(
            onTap: () {}, // Placeholder
            child: Row(
              children: [
                Text(
                  'Create an\naccount',
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
