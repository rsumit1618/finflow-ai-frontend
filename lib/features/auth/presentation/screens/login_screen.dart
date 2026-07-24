import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:finflow_app/core/common/ui/theme/finflow_colors.dart';
import 'package:finflow_app/core/common/ui/widgets/finflow_button.dart';
import 'package:finflow_app/core/common/ui/widgets/finflow_text_field.dart';
import 'package:finflow_app/core/common/utils/routing/app_router.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_state.dart';
import 'package:finflow_app/core/common/ui/utils/error_handler_ui.dart';
import 'package:finflow_app/core/common/errors/failures.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authNotifierProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is AuthError) {
        ErrorType errorType;
        switch (next.type) {
          case FailureType.network:
            errorType = ErrorType.network;
            break;
          case FailureType.server:
            errorType = ErrorType.server;
            break;
          case FailureType.validation:
            errorType = ErrorType.validation;
            break;
          default:
            errorType = ErrorType.unknown;
        }
        ErrorHandlerUI.showError(context, next.message, type: errorType);
      } else if (next is AuthAuthenticated) {
        if (next.user.isProfileComplete) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.dashboard, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.updateProfile, (route) => false);
        }
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        return Scaffold(
          backgroundColor: FinFlowColors.lightBg,
          body: isMobile
              ? _buildMobileLayout(authState)
              : _buildWebLayout(authState),
        );
      },
    );
  }

  Widget _buildMobileLayout(AuthState authState) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 390,
        height: 882,
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/images/login_mobile_bg.svg',
                width: 390,
                height: 882,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: _buildLoginCard(authState, isMobile: true),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildFooter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebLayout(AuthState authState) {
    return Stack(
      children: [
        Positioned.fill(
          child: SvgPicture.asset(
            'assets/images/login_web_bg.svg',
            width: 1280,
            height: 1024,
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: _buildLoginCard(authState),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(32),
            child: _buildFooter(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(AuthState authState, {bool isMobile = false}) {
    return Container(
      width: isMobile ? null : 480,
      constraints: const BoxConstraints(maxWidth: 480),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: FinFlowColors.lightCardBg,
        borderRadius: BorderRadius.circular(isMobile ? 24 : 32),
        border: Border.all(
          color: FinFlowColors.glassStroke,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: FinFlowColors.primary.withValues(alpha: 0.05),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 32 : 48),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBrand(),
                const SizedBox(height: 32),
                _buildForm(authState),
                const SizedBox(height: 32),
                _buildDivider(),
                const SizedBox(height: 24),
                _buildSocialButtons(),
                const SizedBox(height: 24),
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: FinFlowColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'FinFlow AI',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: FinFlowColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Welcome back! Sign in to continue',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: FinFlowColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(AuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FinFlowTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(
            Icons.email_outlined,
            size: 20,
            color: FinFlowColors.textMuted,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Email is required';
            if (!value.contains('@')) return 'Invalid email';
            return null;
          },
        ),
        const SizedBox(height: 24),
        FinFlowTextField(
          controller: _passwordController,
          label: 'Password',
          hint: 'Enter your password',
          obscureText: true,
          prefixIcon: const Icon(
            Icons.lock_outlined,
            size: 20,
            color: FinFlowColors.textMuted,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Password is required';
            if (value.length < 6)
              return 'Password must be at least 6 characters';
            return null;
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (v) => setState(() => _rememberMe = v ?? false),
                activeColor: FinFlowColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Remember me',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: FinFlowColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        FinFlowButton.primary(
          text: 'Sign In',
          onPressed: _submit,
          isLoading: authState is AuthLoading,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: FinFlowColors.borderSoft)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or continue with',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: FinFlowColors.textSecondary.withValues(alpha: 0.6),
            ),
          ),
        ),
        const Expanded(child: Divider(color: FinFlowColors.borderSoft)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        SocialButton(
          onPressed: () {},
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.g_mobiledata,
                  size: 24, color: FinFlowColors.textSecondary),
              const SizedBox(width: 8),
              const Text(
                'Google',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: FinFlowColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SocialButton(
          onPressed: () {},
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.apple,
                  size: 24, color: FinFlowColors.textSecondary),
              const SizedBox(width: 8),
              const Text(
                'Apple',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: FinFlowColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Text.rich(
      TextSpan(
        text: "New to FinFlow? ",
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: FinFlowColors.textSecondary,
        ),
        children: [
          TextSpan(
            text: 'Create an account',
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: FinFlowColors.primaryDark,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Navigator.pushNamed(context, AppRoutes.register),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFooter() {
    return Opacity(
      opacity: 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _footerLink('Privacy Policy'),
              const SizedBox(width: 32),
              _footerLink('Terms of Service'),
              const SizedBox(width: 32),
              _footerLink('Cookie Policy'),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '© 2024 FinFlow AI. All rights reserved.',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: FinFlowColors.textMuted,
              letterSpacing: 0.05,
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String text) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: FinFlowColors.textMuted,
          letterSpacing: 0.05,
        ),
      ),
    );
  }
}
