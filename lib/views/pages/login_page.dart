


import 'package:flutter/material.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../../utils/validators.dart';
import '../../utils/page_transitions.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/animated_button.dart';
import '../widgets/animated_background.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final LoginViewModel _viewModel = LoginViewModel();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    // Start animation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _animationController.forward();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _viewModel.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        enableParticles: true,
        enableWaves: true,
        enableOrbs: true,
        animationSpeed: 0.8,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: GlassContainer(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Profile Icon
                          _buildProfileIcon(),
                          const SizedBox(height: 24),
                          
                          // Welcome Text
                          const Text(
                            'Sign in ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          Text(
                            'Sign in to continue',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 32),
                          
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
                          const SizedBox(height: 16),
                          
                          // Forgot Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _handleForgotPassword,
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Sign In Button
                          AnimatedBuilder(
                            animation: _viewModel,
                            builder: (context, child) {
                              return AnimatedButton(
                                text: 'Sign In',
                                onPressed: _viewModel.isLoading ? null : _handleSignIn,
                                isLoading: _viewModel.isLoading,
                                isPrimary: true,
                                height: 56,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Create Account Button
                          AnimatedButton(
                            text: 'Create New Account',
                            onPressed: _handleCreateAccount,
                            isPrimary: false,
                            height: 56,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(
        Icons.person_outline_rounded,
        size: 36,
        color: Colors.white.withOpacity(0.9),
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
            backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
          ),
        );
      }
    }
  }

  void _handleCreateAccount() {
    Navigator.push(context, BlurRoute(page: const RegisterPage()));
  }

  void _handleForgotPassword() {
    Navigator.push(context, BlurRoute(page: const ForgotPasswordPage()));
  }
}