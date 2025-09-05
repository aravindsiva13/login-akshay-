
import 'package:flutter/material.dart';
import '../../viewmodels/register_viewmodel.dart';
import '../../utils/validators.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/animated_button.dart';
import '../widgets/animated_background.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final RegisterViewModel _viewModel = RegisterViewModel();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
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
    _nameController.dispose();
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
                          // User Icon
                          _buildUserIcon(),
                          const SizedBox(height: 24),
                          
                          // Title
                          const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          Text(
                            'Join us today and get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Name Field
                          GlassTextField(
                            controller: _nameController,
                            labelText: 'Full Name',
                            prefixIcon: Icons.person_outline_rounded,
                            validator: (value) {
                              if (value?.isEmpty ?? true) return 'Name is required';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Email Field
                          GlassTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            prefixIcon: Icons.email_outlined,
                            validator: Validators.validateEmail,
                          ),
                          const SizedBox(height: 16),
                          
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
                          const SizedBox(height: 24),
                          
                          // Create Account Button
                          AnimatedBuilder(
                            animation: _viewModel,
                            builder: (context, child) {
                              return AnimatedButton(
                                text: 'Create Account',
                                onPressed: _viewModel.isLoading ? null : _handleRegister,
                                isLoading: _viewModel.isLoading,
                                isPrimary: true,
                                height: 56,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Sign In Link
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Already have an account? Sign In',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
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
          ),
        ),
      ),
    );
  }

  Widget _buildUserIcon() {
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
        Icons.person_add_outlined,
        size: 36,
        color: Colors.white.withOpacity(0.9),
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
            backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
          ),
        );
        if (success) Navigator.pop(context);
      }
    }
  }
}