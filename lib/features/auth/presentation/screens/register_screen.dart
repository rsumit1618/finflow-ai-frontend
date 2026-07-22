import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finflow_app/core/common/errors/failures.dart';
import 'package:finflow_app/core/common/ui/utils/error_handler_ui.dart';
import 'package:finflow_app/core/common/utils/routing/app_router.dart';
import 'package:finflow_app/core/common/utils/validators.dart';
import 'package:finflow_app/core/common/ui/widgets/custom_button.dart';
import 'package:finflow_app/core/common/ui/widgets/custom_text_field.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_state.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ErrorHandlerUI.showError(context, 'Passwords do not match', type: ErrorType.validation);
        return;
      }
      ref.read(authNotifierProvider.notifier).register(
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
        // Registration always leads to update profile onboarding
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.updateProfile, (route) => false);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    prefixIcon: Icons.lock_clock_outlined,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Confirm your password';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Register',
                    onPressed: _submit,
                    isLoading: authState is AuthLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
