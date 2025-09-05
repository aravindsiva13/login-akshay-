

  import 'package:flutter/material.dart';
import '../../viewmodels/forgot_password_viewmodel.dart';
import '../../utils/validators.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/animated_button.dart';
import '../widgets/animated_background.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final ForgotPasswordViewModel _viewModel = ForgotPasswordViewModel();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

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
                          // Back button
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white70,
                                size: 20,
                              ),
                            ),
                          ),
                          
                          // Lock Icon
                          _buildLockIcon(),
                          const SizedBox(height: 24),
                          
                          // Title
                          const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Subtitle
                          Text(
                            'Enter your email address and we\'ll send you a link to reset your password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Email Field
                          GlassTextField(
                            controller: _emailController,
                            labelText: 'Email Address',
                            prefixIcon: Icons.email_outlined,
                            validator: Validators.validateEmail,
                          ),
                          const SizedBox(height: 24),
                          
                          // Send Reset Link Button
                          AnimatedBuilder(
                            animation: _viewModel,
                            builder: (context, child) {
                              return AnimatedButton(
                                text: 'Send Reset Link',
                                onPressed: _viewModel.isLoading ? null : _handleSendResetLink,
                                isLoading: _viewModel.isLoading,
                                isPrimary: true,
                                height: 56,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Back to Sign In Button
                          AnimatedButton(
                            text: 'Back to Sign In',
                            onPressed: () => Navigator.pop(context),
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

  Widget _buildLockIcon() {
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
        Icons.lock_reset_outlined,
        size: 36,
        color: Colors.white.withOpacity(0.9),
      ),
    );
  }

  Future<void> _handleSendResetLink() async {
    if (_formKey.currentState!.validate()) {
      final success = await _viewModel.sendResetLink(_emailController.text.trim());
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success 
                  ? 'Password reset link sent to your email!' 
                  : _viewModel.errorMessage ?? 'Failed to send reset link'
            ),
            backgroundColor: success ? Colors.green.shade700 : Colors.red.shade700,
            duration: const Duration(seconds: 4),
          ),
        );
        
        if (success) {
          // Navigate back after successful request
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) Navigator.pop(context);
          });
        }
      }
    }
  }
}