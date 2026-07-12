import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../core/localization/app_localizations.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_textfield.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController(text: 'test1@gmail.com');
  final _passwordController = TextEditingController(text: '123456');
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -100,
            right: -100,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.05),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: theme.colorScheme.secondary.withOpacity(0.05),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // App Branding
                        Hero(
                          tag: 'app_logo',
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.auto_graph_rounded,
                              size: 60,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          loc?.translate('app_title') ?? 'FinFlow AI',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: theme.colorScheme.onSurface,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isLogin ? 'Welcome back, you\'ve been missed!' : 'Let\'s get you started on your journey',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),

                        // Form Fields
                        if (!_isLogin) ...[
                          CustomTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            prefixIcon: Icons.person_rounded,
                            validator: (v) => v!.isEmpty ? 'Enter your name' : null,
                          ),
                          const SizedBox(height: 20),
                        ],
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          prefixIcon: Icons.alternate_email_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) =>
                              v!.isEmpty || !v.contains('@') ? 'Enter a valid email' : null,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _passwordController,
                          label: 'Password',
                          prefixIcon: Icons.lock_open_rounded,
                          obscureText: true,
                          validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                        ),
                        
                        const SizedBox(height: 32),

                        CustomButton(
                          text: _isLogin ? 'Sign In' : 'Create Account',
                          isLoading: viewModel.isLoading,
                          onPressed: _submit,
                        ),
                        
                        const SizedBox(height: 24),

                        // Toggle Login/Register
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isLogin ? "New to FinFlow? " : "Already have an account? ",
                              style: theme.textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () => setState(() => _isLogin = !_isLogin),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                _isLogin ? 'Join now' : 'Log in',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (viewModel.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Material(
                              color: theme.colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Text(
                                  viewModel.errorMessage!,
                                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final viewModel = context.read<AuthViewModel>();
    if (_isLogin) {
      await viewModel.login(_emailController.text, _passwordController.text);
    } else {
      await viewModel.register(_nameController.text, _emailController.text, _passwordController.text);
    }
  }
}
