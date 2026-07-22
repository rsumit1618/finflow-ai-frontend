import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finflow_app/core/common/ui/utils/error_handler_ui.dart';
import 'package:finflow_app/core/common/utils/routing/app_router.dart';
import 'package:finflow_app/core/common/ui/widgets/custom_button.dart';
import 'package:finflow_app/core/common/ui/widgets/custom_text_field.dart';
import 'package:finflow_app/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:finflow_app/features/auth/presentation/providers/auth_state.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _ageController;
  late TextEditingController _collegeController;
  late TextEditingController _qualYearController;
  late TextEditingController _addressController;
  late TextEditingController _highestQualController;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authNotifierProvider);
    final user = authState is AuthAuthenticated ? authState.user : null;
    
    _firstNameController = TextEditingController(text: user?.firstName);
    _lastNameController = TextEditingController(text: user?.lastName);
    _ageController = TextEditingController(text: user?.age?.toString());
    _collegeController = TextEditingController(text: user?.college);
    _qualYearController = TextEditingController(text: user?.qualificationYear?.toString());
    _addressController = TextEditingController(text: user?.address);
    _highestQualController = TextEditingController(text: user?.highestQualification);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _collegeController.dispose();
    _qualYearController.dispose();
    _addressController.dispose();
    _highestQualController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authNotifierProvider.notifier).updateProfile(
        UpdateProfileParams(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          age: int.tryParse(_ageController.text.trim()) ?? 0,
          college: _collegeController.text.trim(),
          qualificationYear: int.tryParse(_qualYearController.text.trim()) ?? 0,
          address: _addressController.text.trim(),
          highestQualification: _highestQualController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is AuthAuthenticated && previous is AuthLoading) {
        ErrorHandlerUI.showSnackBar(context, 'Profile updated successfully!', isError: false);
        // If we are in onboarding, go to dashboard. If editing, just pop.
        if (Navigator.of(context).canPop()) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        }
      } else if (next is AuthError) {
        ErrorHandlerUI.showError(context, next.message);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile'),
        automaticallyImplyLeading: Navigator.of(context).canPop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _firstNameController,
                      label: 'First Name',
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _lastNameController,
                      label: 'Last Name',
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _ageController,
                label: 'Age',
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _addressController,
                label: 'Address',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              const Text(
                'Education Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _collegeController,
                label: 'College/University',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _highestQualController,
                label: 'Highest Qualification',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _qualYearController,
                label: 'Graduation Year',
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: 'Save & Continue',
                onPressed: _submit,
                isLoading: authState is AuthLoading,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
