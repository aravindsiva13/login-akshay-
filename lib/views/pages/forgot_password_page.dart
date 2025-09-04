// import 'package:flutter/material.dart';
// import '../../viewmodels/forgot_password_viewmodel.dart';
// import '../../utils/validators.dart';
// import '../widgets/glass_container.dart';
// import '../widgets/glass_text_field.dart';
// import '../widgets/animated_button.dart';

// class ForgotPasswordPage extends StatefulWidget {
//   const ForgotPasswordPage({super.key});

//   @override
//   State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
// }

// class _ForgotPasswordPageState extends State<ForgotPasswordPage>
//     with TickerProviderStateMixin {
//   final ForgotPasswordViewModel _viewModel = ForgotPasswordViewModel();
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();

//   late AnimationController _containerAnimationController;
//   late AnimationController _fieldAnimationController;
//   late Animation<double> _containerAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//   }

//   void _setupAnimations() {
//     _containerAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _fieldAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _containerAnimation = CurvedAnimation(
//       parent: _containerAnimationController,
//       curve: Curves.elasticOut,
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _fieldAnimationController,
//       curve: Curves.easeOutBack,
//     ));

//     // Start animations when the page loads
//     Future.delayed(const Duration(milliseconds: 100), () {
//       _containerAnimationController.forward();
//       _fieldAnimationController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _viewModel.dispose();
//     _containerAnimationController.dispose();
//     _fieldAnimationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFF1a1a1a), Color(0xFF000000)],
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24.0),
//               child: AnimatedBuilder(
//                 animation: _containerAnimation,
//                 builder: (context, child) {
//                   return Transform.scale(
//                     scale: _containerAnimation.value,
//                     child: Transform(
//                       alignment: Alignment.center,
//                       transform: Matrix4.identity()
//                         ..setEntry(3, 2, 0.001)
//                         ..rotateX(0.1 * (1 - _containerAnimation.value))
//                         ..rotateY(0.05 * (1 - _containerAnimation.value)),
//                       child: GlassContainer(
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               // Back button
//                               _buildAnimatedField(
//                                 child: Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: IconButton(
//                                     onPressed: () => Navigator.pop(context),
//                                     icon: const Icon(
//                                       Icons.arrow_back_ios_rounded,
//                                       color: Colors.white70,
//                                       size: 20,
//                                     ),
//                                   ),
//                                 ),
//                                 delay: 0,
//                               ),
                              
//                               // Lock Icon
//                               _buildAnimatedLockIcon(),
//                               const SizedBox(height: 24),
                              
//                               // Title
//                               SlideTransition(
//                                 position: _slideAnimation,
//                                 child: FadeTransition(
//                                   opacity: _fieldAnimationController,
//                                   child: const Text(
//                                     'Forgot Password?',
//                                     style: TextStyle(
//                                       fontSize: 28,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
                              
//                               // Subtitle
//                               SlideTransition(
//                                 position: _slideAnimation,
//                                 child: FadeTransition(
//                                   opacity: _fieldAnimationController,
//                                   child: Text(
//                                     'Enter your email address and we\'ll send you a link to reset your password',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.white.withOpacity(0.7),
//                                       height: 1.5,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 40),
                              
//                               // Email Field
//                               _buildAnimatedField(
//                                 child: GlassTextField(
//                                   controller: _emailController,
//                                   labelText: 'Email Address',
//                                   prefixIcon: Icons.email_outlined,
//                                   validator: Validators.validateEmail,
//                                 ),
//                                 delay: 200,
//                               ),
//                               const SizedBox(height: 32),
                              
//                               // Send Reset Link Button
//                               _buildAnimatedField(
//                                 child: AnimatedBuilder(
//                                   animation: _viewModel,
//                                   builder: (context, child) {
//                                     return AnimatedButton(
//                                       text: 'Send Reset Link',
//                                       onPressed: _viewModel.isLoading ? null : _handleSendResetLink,
//                                       isLoading: _viewModel.isLoading,
//                                       isPrimary: true,
//                                     );
//                                   },
//                                 ),
//                                 delay: 300,
//                               ),
//                               const SizedBox(height: 20),
                              
//                               // Back to Sign In Button
//                               _buildAnimatedField(
//                                 child: AnimatedButton(
//                                   text: 'Back to Sign In',
//                                   onPressed: () => Navigator.pop(context),
//                                   isPrimary: false,
//                                 ),
//                                 delay: 400,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAnimatedLockIcon() {
//     return SlideTransition(
//       position: _slideAnimation,
//       child: FadeTransition(
//         opacity: _fieldAnimationController,
//         child: Transform(
//           alignment: Alignment.center,
//           transform: Matrix4.identity()
//             ..setEntry(3, 2, 0.001)
//             ..rotateX(0.1 * (1 - _containerAnimation.value)),
//           child: Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.orange.withOpacity(0.1),
//               border: Border.all(color: Colors.orange.withOpacity(0.3)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.orange.withOpacity(0.1),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Icon(
//               Icons.lock_reset_outlined,
//               size: 40,
//               color: Colors.orange.shade300,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAnimatedField({required Widget child, required int delay}) {
//     return TweenAnimationBuilder<double>(
//       duration: Duration(milliseconds: 600 + delay),
//       tween: Tween(begin: 0.0, end: 1.0),
//       curve: Curves.easeOutBack,
//       builder: (context, value, child) {
//         return Transform.translate(
//           offset: Offset(0, 30 * (1 - value)),
//           child: Opacity(
//             opacity: value.clamp(0.0, 1.0),
//             child: Transform(
//               alignment: Alignment.center,
//               transform: Matrix4.identity()
//                 ..setEntry(3, 2, 0.001)
//                 ..rotateX(0.05 * (1 - value)),
//               child: child,
//             ),
//           ),
//         );
//       },
//       child: child,
//     );
//   }

//   Future<void> _handleSendResetLink() async {
//     if (_formKey.currentState!.validate()) {
//       final success = await _viewModel.sendResetLink(_emailController.text.trim());
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               success 
//                   ? 'Password reset link sent to your email!' 
//                   : _viewModel.errorMessage ?? 'Failed to send reset link'
//             ),
//             backgroundColor: success 
//                 ? const Color.fromARGB(238, 45, 65, 45) 
//                 : const Color.fromARGB(255, 87, 26, 22),
//             duration: const Duration(seconds: 4),
//           ),
//         );
        
//         if (success) {
//           // Optional: Navigate back after successful request
//           Future.delayed(const Duration(seconds: 2), () {
//             if (mounted) Navigator.pop(context);
//           });
//         }
//       }
//     }
//   }
// }


//2


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
    with TickerProviderStateMixin {
  final ForgotPasswordViewModel _viewModel = ForgotPasswordViewModel();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  late AnimationController _containerController;
  late AnimationController _fieldsController;
  
  late Animation<double> _containerScale;
  late Animation<double> _containerOpacity;
  late Animation<Offset> _containerSlide;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    // Container entrance animation
    _containerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Fields staggered animation
    _fieldsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _containerScale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _containerController,
      curve: Curves.elasticOut,
    ));

    _containerOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _containerController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _containerSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _containerController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _containerController.forward();
        _fieldsController.forward();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _viewModel.dispose();
    _containerController.dispose();
    _fieldsController.dispose();
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
              child: AnimatedBuilder(
                animation: _containerController,
                builder: (context, child) {
                  return SlideTransition(
                    position: _containerSlide,
                    child: Transform.scale(
                      scale: _containerScale.value,
                      child: Opacity(
                        opacity: _containerOpacity.value.clamp(0.0, 1.0),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateX(0.05 * (1 - _containerScale.value))
                            ..rotateY(0.02 * (1 - _containerScale.value)),
                          child: GlassContainer(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Back button
                                  _buildAnimatedField(
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
                                    delay: 0,
                                  ),
                                  
                                  // Lock Icon
                                  _buildAnimatedLockIcon(),
                                  const SizedBox(height: 32),
                                  
                                  // Title
                                  _buildAnimatedText(
                                    'Forgot Password?',
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    delay: 200,
                                  ),
                                  const SizedBox(height: 8),
                                  
                                  // Subtitle
                                  _buildAnimatedText(
                                    'Enter your email address and we\'ll send you a link to reset your password',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    opacity: 0.7,
                                    delay: 300,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 48),
                                  
                                  // Email Field
                                  _buildAnimatedField(
                                    GlassTextField(
                                      controller: _emailController,
                                      labelText: 'Email Address',
                                      prefixIcon: Icons.email_outlined,
                                      validator: Validators.validateEmail,
                                    ),
                                    delay: 500,
                                  ),
                                  const SizedBox(height: 32),
                                  
                                  // Send Reset Link Button
                                  _buildAnimatedField(
                                    AnimatedBuilder(
                                      animation: _viewModel,
                                      builder: (context, child) {
                                        return AnimatedButton(
                                          text: 'Send Reset Link',
                                          onPressed: _viewModel.isLoading ? null : _handleSendResetLink,
                                          isLoading: _viewModel.isLoading,
                                          isPrimary: true,
                                          height: 64,
                                        );
                                      },
                                    ),
                                    delay: 700,
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  // Back to Sign In Button
                                  _buildAnimatedField(
                                    AnimatedButton(
                                      text: 'Back to Sign In',
                                      onPressed: () => Navigator.pop(context),
                                      isPrimary: false,
                                      height: 64,
                                    ),
                                    delay: 900,
                                  ),
                                ],
                              ),
                            ),
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
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(0.3 * (1 - value)),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.25),
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.05),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.lock_reset_outlined,
                size: 40,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedText(
    String text, {
    required int delay,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    double opacity = 0.8,
    TextAlign? textAlign,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: (value * opacity).clamp(0.0, 1.0),
            child: Text(
              text,
              textAlign: textAlign,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white.withOpacity(opacity),
                fontWeight: fontWeight,
                letterSpacing: 0.5,
                height: fontSize < 20 ? 1.5 : 1.2,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedField(Widget child, {required int delay}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 700 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(0.05 * (1 - value))
              ..scale(0.95 + (0.05 * value)),
            child: Opacity(
              opacity: value.clamp(0.0, 1.0),
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