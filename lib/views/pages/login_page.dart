


// import 'package:flutter/material.dart';
// import 'dart:math' as math;
// import '../../viewmodels/login_viewmodel.dart';
// import '../../utils/validators.dart';
// import '../../utils/page_transitions.dart';
// import '../widgets/glass_container.dart';
// import '../widgets/glass_text_field.dart';
// import '../widgets/animated_button.dart';
// import 'register_page.dart';
// import 'forgot_password_page.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage>
//     with TickerProviderStateMixin {
//   final LoginViewModel _viewModel = LoginViewModel();
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   late AnimationController _backgroundController;
//   late AnimationController _containerController;
//   late AnimationController _pulseController;
  
//   late Animation<double> _backgroundRotation;
//   late Animation<double> _containerScale;
//   late Animation<double> _containerOpacity;
//   late Animation<Offset> _containerSlide;
//   late Animation<double> _pulseAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//     _startAnimations();
//   }

//   void _setupAnimations() {
//     // Background rotation animation
//     _backgroundController = AnimationController(
//       duration: const Duration(seconds: 20),
//       vsync: this,
//     );
    
//     // Container entrance animation
//     _containerController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );
    
//     // Pulse animation for elements
//     _pulseController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );

//     _backgroundRotation = Tween<double>(
//       begin: 0,
//       end: 2 * math.pi,
//     ).animate(CurvedAnimation(
//       parent: _backgroundController,
//       curve: Curves.linear,
//     ));

//     _containerScale = Tween<double>(
//       begin: 0.3,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _containerController,
//       curve: Curves.elasticOut,
//     ));

//     _containerOpacity = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _containerController,
//       curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
//     ));

//     _containerSlide = Tween<Offset>(
//       begin: const Offset(0, 1.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _containerController,
//       curve: Curves.easeOutBack,
//     ));

//     _pulseAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.05,
//     ).animate(CurvedAnimation(
//       parent: _pulseController,
//       curve: Curves.easeInOut,
//     ));

//     // Start continuous animations
//     _backgroundController.repeat();
//     _pulseController.repeat(reverse: true);
//   }

//   void _startAnimations() {
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) _containerController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _viewModel.dispose();
//     _backgroundController.dispose();
//     _containerController.dispose();
//     _pulseController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//   decoration: const BoxDecoration(
//     gradient: LinearGradient(
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//       colors: [Color(0xFF1a1a1a), Color(0xFF000000)],
//     ),
//   ),
//         child: Stack(
//           children: [
//             // // Animated background elements
//             // _buildAnimatedBackground(),
            
//             // Main content
//             SafeArea(
//               child: Center(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(24.0),
//                   child: AnimatedBuilder(
//                     animation: Listenable.merge([_containerController, _pulseController]),
//                     builder: (context, child) {
//                       return SlideTransition(
//                         position: _containerSlide,
//                         child: Transform.scale(
//                           scale: _containerScale.value,
//                           child: Opacity(
//                             opacity: _containerOpacity.value.clamp(0.0, 1.0),
//                             child: Transform(
//                               alignment: Alignment.center,
//                               transform: Matrix4.identity()
//                                 ..setEntry(3, 2, 0.001)
//                                 ..rotateX(0.05 * (1 - _containerScale.value))
//                                 ..rotateY(0.03 * math.sin(_backgroundRotation.value * 0.5)),
//                               child: GlassContainer(
//                                 child: Form(
//                                   key: _formKey,
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       // Animated profile icon with blue glow
//                                       _buildProfileIcon(),
//                                       const SizedBox(height: 32),
                                      
//                                       // Animated subtitle
//                                       _buildAnimatedText(
//                                         'Sign in to continue',
//                                         delay: 600,
//                                       ),
//                                       const SizedBox(height: 48),
                                      
//                                       // Email field with stagger
//                                       _buildStaggeredField(
//                                         GlassTextField(
//                                           controller: _emailController,
//                                           labelText: 'Email or Phone',
//                                           prefixIcon: Icons.person_outline_rounded,
//                                           validator: Validators.validateEmail,
//                                         ),
//                                         delay: 800,
//                                       ),
//                                       const SizedBox(height: 24),
                                      
//                                       // Password field with stagger
//                                       _buildStaggeredField(
//                                         GlassTextField(
//                                           controller: _passwordController,
//                                           labelText: 'Password',
//                                           prefixIcon: Icons.lock_outline_rounded,
//                                           obscureText: _obscurePassword,
//                                           validator: Validators.validatePassword,
//                                           suffixIcon: IconButton(
//                                             icon: Icon(
//                                               _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                                               color: Colors.white.withOpacity(0.7),
//                                             ),
//                                             onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//                                           ),
//                                         ),
//                                         delay: 1000,
//                                       ),
//                                       const SizedBox(height: 20),
                                      
//                                       // Forgot password link
//                                       _buildStaggeredField(
//                                         Align(
//                                           alignment: Alignment.centerRight,
//                                           child: TextButton(
//                                             onPressed: _handleForgotPassword,
//                                             style: TextButton.styleFrom(
//                                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                             ),
//                                             child: Text(
//                                               'Forgot Password?',
//                                               style: TextStyle(
//                                                 color: Colors.white.withOpacity(0.8),
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         delay: 1200,
//                                       ),
//                                       const SizedBox(height: 24),
                                      
//                                       // Sign in button with blue glow
//                                       _buildStaggeredField(
//                                         AnimatedBuilder(
//                                           animation: _viewModel,
//                                           builder: (context, child) {
//                                             return AnimatedButton(
//                                               text: 'Sign In',
//                                               onPressed: _viewModel.isLoading ? null : _handleSignIn,
//                                               isLoading: _viewModel.isLoading,
//                                               isPrimary: true,
//                                               height: 64,
//                                             );
//                                           },
//                                         ),
//                                         delay: 1400,
//                                       ),
//                                       const SizedBox(height: 20),
                                      
//                                       // Create account button with blue glow
//                                       _buildStaggeredField(
//                                         AnimatedButton(
//                                           text: 'Create New Account',
//                                           onPressed: _handleCreateAccount,
//                                           isPrimary: false,
//                                           height: 64,
//                                         ),
//                                         delay: 1600,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAnimatedBackground() {
//     return AnimatedBuilder(
//       animation: _backgroundController,
//       builder: (context, child) {
//         return Stack(
//           children: [
//             // Rotating background circles (removed blue/purple, made neutral)
//             ...List.generate(3, (index) {
//               final offset = index * (2 * math.pi / 3);
//               final radius = 150.0 + (index * 50);
//               final x = MediaQuery.of(context).size.width / 2 + 
//                        radius * math.cos(_backgroundRotation.value + offset);
//               final y = MediaQuery.of(context).size.height / 2 + 
//                        radius * math.sin(_backgroundRotation.value + offset);
              
//               return Positioned(
//                 left: x - 60,
//                 top: y - 60,
//                 child: Container(
//                   width: 120,
//                   height: 120,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: RadialGradient(
//                       colors: [
//                         Colors.white.withOpacity(0.05 / (index + 1)),
//                         Colors.white.withOpacity(0.02 / (index + 1)),
//                         Colors.transparent,
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }),
            
//             // Floating particles
//             ...List.generate(6, (index) {
//               final animationOffset = index * 0.3;
//               return AnimatedBuilder(
//                 animation: _backgroundController,
//                 builder: (context, child) {
//                   return Positioned(
//                     left: (index * 60.0) + 
//                           30 * math.sin(_backgroundRotation.value * 0.5 + animationOffset),
//                     top: (index * 80.0) + 
//                          20 * math.cos(_backgroundRotation.value * 0.3 + animationOffset),
//                     child: Container(
//                       width: 4 + (index % 3),
//                       height: 4 + (index % 3),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white.withOpacity(0.3),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.white.withOpacity(0.5),
//                             blurRadius: 10,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildProfileIcon() {
//     return AnimatedBuilder(
//       animation: _pulseController,
//       builder: (context, child) {
//         return TweenAnimationBuilder<double>(
//           duration: const Duration(milliseconds: 1200),
//           tween: Tween(begin: 0.0, end: 1.0),
//           curve: Curves.elasticOut,
//           builder: (context, value, child) {
//             return Transform.scale(
//               scale: value * _pulseAnimation.value,
//               child: Transform(
//                 alignment: Alignment.center,
//                 transform: Matrix4.identity()
//                   ..setEntry(3, 2, 0.001)
//                   ..rotateY(0.3 * (1 - value)),
//                 child: Container(
//                   width: 100,
//                   height: 100,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: RadialGradient(
//                       colors: [
//                         Colors.white.withOpacity(0.25),
//                         Colors.white.withOpacity(0.1),
//                         Colors.white.withOpacity(0.05),
//                       ],
//                     ),
//                     border: Border.all(
//                       color: Colors.white.withOpacity(0.4),
//                       width: 2,
//                     ),
//                     boxShadow: [
//                       // Blue glow for profile icon
//                       BoxShadow(
//                         color: Colors.blue.withOpacity(0.3),
//                         blurRadius: 20,
//                         spreadRadius: 5,
//                       ),
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.3),
//                         blurRadius: 15,
//                         offset: const Offset(0, 10),
//                       ),
//                     ],
//                   ),
//                   child: Icon(
//                     Icons.person_outline_rounded,
//                     size: 50,
//                     color: Colors.white.withOpacity(0.9),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildAnimatedText(String text, {required int delay}) {
//     return TweenAnimationBuilder<double>(
//       duration: Duration(milliseconds: delay + 400),
//       tween: Tween(begin: 0.0, end: 1.0),
//       curve: Curves.easeOutCubic,
//       builder: (context, value, child) {
//         return Transform.translate(
//           offset: Offset(0, 30 * (1 - value)),
//           child: Opacity(
//             opacity: value.clamp(0.0, 1.0),
//             child: Text(
//               text,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.white.withOpacity(0.8),
//                 fontWeight: FontWeight.w400,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildStaggeredField(Widget child, {required int delay}) {
//     return TweenAnimationBuilder<double>(
//       duration: Duration(milliseconds: delay + 600),
//       tween: Tween(begin: 0.0, end: 1.0),
//       curve: Curves.easeOutBack,
//       builder: (context, value, child) {
//         return Transform.translate(
//           offset: Offset(0, 50 * (1 - value)),
//           child: Transform.scale(
//             scale: 0.8 + (0.2 * value),
//             child: Opacity(
//               opacity: value.clamp(0.0, 1.0),
//               child: Transform(
//                 alignment: Alignment.center,
//                 transform: Matrix4.identity()
//                   ..setEntry(3, 2, 0.001)
//                   ..rotateX(0.2 * (1 - value)),
//                 child: child,
//               ),
//             ),
//           ),
//         );
//       },
//       child: child,
//     );
//   }

//   Future<void> _handleSignIn() async {
//     if (_formKey.currentState!.validate()) {
//       final success = await _viewModel.login(
//         _emailController.text,
//         _passwordController.text,
//       );

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(success ? 'Welcome back!' : _viewModel.errorMessage ?? 'Login failed'),
//             backgroundColor: success ? const Color.fromARGB(238, 45, 65, 45) : const Color.fromARGB(255, 87, 26, 22),
//           ),
//         );
//       }
//     }
//   }

//   void _handleCreateAccount() {
//     Navigator.push(context, BlurRoute(page: const RegisterPage()));
//   }

//   void _handleForgotPassword() {
//     Navigator.push(context, BlurRoute(page: const ForgotPasswordPage()));
//   }
// }


//2


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
    with TickerProviderStateMixin {
  final LoginViewModel _viewModel = LoginViewModel();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
    _passwordController.dispose();
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
                                  // Profile Icon with blue glow
                                  _buildAnimatedProfileIcon(),
                                  const SizedBox(height: 32),
                                  
                                  // Subtitle
                                  _buildAnimatedText(
                                    'Sign in to continue',
                                    delay: 200,
                                  ),
                                  const SizedBox(height: 48),
                                  
                                  // Email Field
                                  _buildAnimatedField(
                                    GlassTextField(
                                      controller: _emailController,
                                      labelText: 'Email or Phone',
                                      prefixIcon: Icons.person_outline_rounded,
                                      validator: Validators.validateEmail,
                                    ),
                                    delay: 400,
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Password Field
                                  _buildAnimatedField(
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
                                    delay: 600,
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  // Forgot Password Link
                                  _buildAnimatedField(
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: _handleForgotPassword,
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        ),
                                        child: Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    delay: 800,
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Sign In Button
                                  _buildAnimatedField(
                                    AnimatedBuilder(
                                      animation: _viewModel,
                                      builder: (context, child) {
                                        return AnimatedButton(
                                          text: 'Sign In',
                                          onPressed: _viewModel.isLoading ? null : _handleSignIn,
                                          isLoading: _viewModel.isLoading,
                                          isPrimary: true,
                                          height: 64,
                                        );
                                      },
                                    ),
                                    delay: 1000,
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  // Create Account Button
                                  _buildAnimatedField(
                                    AnimatedButton(
                                      text: 'Create New Account',
                                      onPressed: _handleCreateAccount,
                                      isPrimary: false,
                                      height: 64,
                                    ),
                                    delay: 1200,
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

  Widget _buildAnimatedProfileIcon() {
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
              width: 100,
              height: 100,
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
                  // Blue glow for profile icon
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
                Icons.person_outline_rounded,
                size: 50,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedText(String text, {required int delay}) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
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

  void _handleForgotPassword() {
    Navigator.push(context, BlurRoute(page: const ForgotPasswordPage()));
  }
}