// import 'package:flutter/material.dart';
// import '../../viewmodels/register_viewmodel.dart';
// import '../../utils/validators.dart';
// import '../widgets/glass_container.dart';
// import '../widgets/glass_text_field.dart';
// import '../widgets/animated_button.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final RegisterViewModel _viewModel = RegisterViewModel();
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _nameController.dispose();
//     _passwordController.dispose();
//     _viewModel.dispose();
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
//               child: GlassContainer(
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         'Create Account',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(height: 32),
                      
//                       GlassTextField(
//                         controller: _nameController,
//                         labelText: 'Full Name',
//                         prefixIcon: Icons.person,
//                         validator: (value) {
//                           if (value?.isEmpty ?? true) return 'Name is required';
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
                      
//                       GlassTextField(
//                         controller: _emailController,
//                         labelText: 'Email',
//                         prefixIcon: Icons.email,
//                         validator: Validators.validateEmail,
//                       ),
//                       const SizedBox(height: 16),
                      
//                       GlassTextField(
//                         controller: _passwordController,
//                         labelText: 'Password',
//                         prefixIcon: Icons.lock,
//                         obscureText: _obscurePassword,
//                         validator: Validators.validatePassword,
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                             color: Colors.white.withOpacity(0.7),
//                           ),
//                           onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
//                         ),
//                       ),
//                       const SizedBox(height: 32),
                      
//                       AnimatedBuilder(
//                         animation: _viewModel,
//                         builder: (context, child) {
//                           return AnimatedButton(
//                             text: 'Create Account',
//                             onPressed: _viewModel.isLoading ? null : _handleRegister,
//                             isLoading: _viewModel.isLoading,
//                             isPrimary: true,
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 16),
                      
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text(
//                           'Already have an account? Sign In',
//                           style: TextStyle(color: Colors.white70),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _handleRegister() async {
//     if (_formKey.currentState!.validate()) {
//       final success = await _viewModel.register(
//         _emailController.text.trim(),
//         _nameController.text.trim(),
//         _passwordController.text,
//       );
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(success ? 'Account created successfully!' : _viewModel.errorMessage ?? 'Registration failed'),
//             backgroundColor: success ? const Color.fromARGB(238, 45, 65, 45) : const Color.fromARGB(255, 87, 26, 22),
//           ),
//         );
//         if (success) Navigator.pop(context);
//       }
//     }
//   }
// }


//2



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
    with TickerProviderStateMixin {
  final RegisterViewModel _viewModel = RegisterViewModel();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
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
    _nameController.dispose();
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
                                  // User Icon
                                  _buildAnimatedUserIcon(),
                                  const SizedBox(height: 32),
                                  
                                  // Title
                                  _buildAnimatedText(
                                    'Create Account',
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    delay: 200,
                                  ),
                                  const SizedBox(height: 8),
                                  
                                  // Subtitle
                                  _buildAnimatedText(
                                    'Join us today and get started',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    opacity: 0.7,
                                    delay: 300,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 40),
                                  
                                  // Name Field
                                  _buildAnimatedField(
                                    GlassTextField(
                                      controller: _nameController,
                                      labelText: 'Full Name',
                                      prefixIcon: Icons.person_outline_rounded,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) return 'Name is required';
                                        return null;
                                      },
                                    ),
                                    delay: 400,
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  // Email Field
                                  _buildAnimatedField(
                                    GlassTextField(
                                      controller: _emailController,
                                      labelText: 'Email',
                                      prefixIcon: Icons.email_outlined,
                                      validator: Validators.validateEmail,
                                    ),
                                    delay: 500,
                                  ),
                                  const SizedBox(height: 20),
                                  
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
                                  const SizedBox(height: 32),
                                  
                                  // Create Account Button
                                  _buildAnimatedField(
                                    AnimatedBuilder(
                                      animation: _viewModel,
                                      builder: (context, child) {
                                        return AnimatedButton(
                                          text: 'Create Account',
                                          onPressed: _viewModel.isLoading ? null : _handleRegister,
                                          isLoading: _viewModel.isLoading,
                                          isPrimary: true,
                                          height: 64,
                                        );
                                      },
                                    ),
                                    delay: 800,
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  // Sign In Link
                                  _buildAnimatedField(
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                      ),
                                      child: Text(
                                        'Already have an account? Sign In',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    delay: 1000,
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

  Widget _buildAnimatedUserIcon() {
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
              width: 90,
              height: 90,
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
                Icons.person_add_outlined,
                size: 45,
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