import 'package:flutter/material.dart';
import '../../viewmodels/forgot_password_viewmodel.dart';
import '../../utils/validators.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/animated_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with TickerProviderStateMixin {
  final ForgotPasswordViewModel _viewModel = ForgotPasswordViewModel();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  late AnimationController _containerAnimationController;
  late AnimationController _fieldAnimationController;
  late Animation<double> _containerAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _containerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fieldAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _containerAnimation = CurvedAnimation(
      parent: _containerAnimationController,
      curve: Curves.elasticOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fieldAnimationController,
      curve: Curves.easeOutBack,
    ));

    // Start animations when the page loads
    Future.delayed(const Duration(milliseconds: 100), () {
      _containerAnimationController.forward();
      _fieldAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _viewModel.dispose();
    _containerAnimationController.dispose();
    _fieldAnimationController.dispose();
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
              child: AnimatedBuilder(
                animation: _containerAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _containerAnimation.value,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(0.1 * (1 - _containerAnimation.value))
                        ..rotateY(0.05 * (1 - _containerAnimation.value)),
                      child: GlassContainer(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Back button
                              _buildAnimatedField(
                                child: Align(
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
                                delay: 0,
                              ),
                              
                              // Lock Icon
                              _buildAnimatedLockIcon(),
                              const SizedBox(height: 24),
                              
                              // Title
                              SlideTransition(
                                position: _slideAnimation,
                                child: FadeTransition(
                                  opacity: _fieldAnimationController,
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              // Subtitle
                              SlideTransition(
                                position: _slideAnimation,
                                child: FadeTransition(
                                  opacity: _fieldAnimationController,
                                  child: Text(
                                    'Enter your email address and we\'ll send you a link to reset your password',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.7),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              
                              // Email Field
                              _buildAnimatedField(
                                child: GlassTextField(
                                  controller: _emailController,
                                  labelText: 'Email Address',
                                  prefixIcon: Icons.email_outlined,
                                  validator: Validators.validateEmail,
                                ),
                                delay: 200,
                              ),
                              const SizedBox(height: 32),
                              
                              // Send Reset Link Button
                              _buildAnimatedField(
                                child: AnimatedBuilder(
                                  animation: _viewModel,
                                  builder: (context, child) {
                                    return AnimatedButton(
                                      text: 'Send Reset Link',
                                      onPressed: _viewModel.isLoading ? null : _handleSendResetLink,
                                      isLoading: _viewModel.isLoading,
                                      isPrimary: true,
                                    );
                                  },
                                ),
                                delay: 300,
                              ),
                              const SizedBox(height: 20),
                              
                              // Back to Sign In Button
                              _buildAnimatedField(
                                child: AnimatedButton(
                                  text: 'Back to Sign In',
                                  onPressed: () => Navigator.pop(context),
                                  isPrimary: false,
                                ),
                                delay: 400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLockIcon() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fieldAnimationController,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(0.1 * (1 - _containerAnimation.value)),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange.withOpacity(0.1),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.lock_reset_outlined,
              size: 40,
              color: Colors.orange.shade300,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedField({required Widget child, required int delay}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(0.05 * (1 - value)),
              child: child,
            ),
          ),
        );
      },
      child: child,
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
            backgroundColor: success 
                ? const Color.fromARGB(238, 45, 65, 45) 
                : const Color.fromARGB(255, 87, 26, 22),
            duration: const Duration(seconds: 4),
          ),
        );
        
        if (success) {
          // Optional: Navigate back after successful request
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) Navigator.pop(context);
          });
        }
      }
    }
  }
}