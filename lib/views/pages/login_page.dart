import 'package:flutter/material.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../../utils/validators.dart';
import '../../utils/page_transitions.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/animated_button.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginViewModel _viewModel = LoginViewModel();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
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
                      // Profile Icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Title
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Subtitle
                      Text(
                        'Sign in to continue',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Email Field
                      GlassTextField(
                        controller: _emailController,
                        labelText: 'Email or Phone',
                        prefixIcon: Icons.person_outline_rounded,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 20),
                      
                      // Password Field
                      GlassTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        prefixIcon: Icons.lock_outline_rounded,
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
                      
                      // Sign In Button
                      AnimatedBuilder(
                        animation: _viewModel,
                        builder: (context, child) {
                          return AnimatedButton(
                            text: 'Sign In',
                            onPressed: _viewModel.isLoading ? null : _handleSignIn,
                            isLoading: _viewModel.isLoading,
                            isPrimary: true,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      // Create Account Button
                      AnimatedButton(
                        text: 'Create New Account',
                        onPressed: _handleCreateAccount,
                        isPrimary: false,
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

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      final success = await _viewModel.login(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Welcome back!' : _viewModel.errorMessage ?? 'Login failed'),
             backgroundColor: success ? const Color.fromARGB(238, 45, 65, 45) : const Color.fromARGB(255, 87, 26, 22),
          ),
        );
      }
    }
  }

  void _handleCreateAccount() {
    Navigator.push(context, BlurRoute(page: const RegisterPage()));
  }
}