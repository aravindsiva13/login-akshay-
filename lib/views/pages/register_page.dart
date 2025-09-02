import 'package:flutter/material.dart';
import '../../viewmodels/register_viewmodel.dart';
import '../../utils/validators.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/animated_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterViewModel _viewModel = RegisterViewModel();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a1a), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: GlassContainer(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      GlassTextField(
                        controller: _nameController,
                        labelText: 'Full Name',
                        prefixIcon: Icons.person,
                        validator: (value) {
                          if (value?.isEmpty ?? true) return 'Name is required';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      GlassTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        prefixIcon: Icons.email,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      
                      GlassTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        prefixIcon: Icons.lock,
                        obscureText: _obscurePassword,
                        validator: Validators.validatePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      AnimatedBuilder(
                        animation: _viewModel,
                        builder: (context, child) {
                          return AnimatedButton(
                            text: 'Create Account',
                            onPressed: _viewModel.isLoading ? null : _handleRegister,
                            isLoading: _viewModel.isLoading,
                            isPrimary: true,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Already have an account? Sign In',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final success = await _viewModel.register(
        _emailController.text.trim(),
        _nameController.text.trim(),
        _passwordController.text,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Account created successfully!' : _viewModel.errorMessage ?? 'Registration failed'),
            backgroundColor: success ? const Color.fromARGB(238, 45, 65, 45) : const Color.fromARGB(255, 87, 26, 22),
          ),
        );
        if (success) Navigator.pop(context);
      }
    }
  }
}