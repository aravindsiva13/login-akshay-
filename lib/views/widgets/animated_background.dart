// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// class AnimatedBackground extends StatefulWidget {
//   final Widget child;
//   final Color primaryColor;
//   final Color secondaryColor;
//   final bool enableParticles;
//   final bool enableWaves;
//   final bool enableOrbs;
//   final double animationSpeed;

//   const AnimatedBackground({
//     super.key,
//     required this.child,
//     this.primaryColor = const Color(0xFF0F172A), // Dark slate
//     this.secondaryColor = const Color(0xFF1E293B), // Lighter slate
//     this.enableParticles = true,
//     this.enableWaves = true,
//     this.enableOrbs = true,
//     this.animationSpeed = 1.0,
//   });

//   @override
//   State<AnimatedBackground> createState() => _AnimatedBackgroundState();
// }

// class _AnimatedBackgroundState extends State<AnimatedBackground>
//     with TickerProviderStateMixin {
//   late AnimationController _primaryController;
//   late AnimationController _secondaryController;
//   late AnimationController _particleController;
  
//   late Animation<double> _rotationAnimation;
//   late Animation<double> _pulseAnimation;
//   late Animation<double> _particleAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//   }

//   void _setupAnimations() {
//     // Primary rotation animation for orbs
//     _primaryController = AnimationController(
//       duration: Duration(seconds: (25 / widget.animationSpeed).round()),
//       vsync: this,
//     );

//     // Secondary pulse animation for depth
//     _secondaryController = AnimationController(
//       duration: Duration(seconds: (4 / widget.animationSpeed).round()),
//       vsync: this,
//     );

//     // Particle floating animation
//     _particleController = AnimationController(
//       duration: Duration(seconds: (15 / widget.animationSpeed).round()),
//       vsync: this,
//     );

//     _rotationAnimation = Tween<double>(
//       begin: 0,
//       end: 2 * math.pi,
//     ).animate(CurvedAnimation(
//       parent: _primaryController,
//       curve: Curves.linear,
//     ));

//     _pulseAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.2,
//     ).animate(CurvedAnimation(
//       parent: _secondaryController,
//       curve: Curves.easeInOut,
//     ));

//     _particleAnimation = Tween<double>(
//       begin: 0,
//       end: 2 * math.pi,
//     ).animate(CurvedAnimation(
//       parent: _particleController,
//       curve: Curves.linear,
//     ));

//     // Start all animations
//     _primaryController.repeat();
//     _secondaryController.repeat(reverse: true);
//     _particleController.repeat();
//   }

//   @override
//   void dispose() {
//     _primaryController.dispose();
//     _secondaryController.dispose();
//     _particleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: RadialGradient(
//           center: Alignment.topLeft,
//           radius: 1.5,
//           colors: [
//             widget.secondaryColor,
//             widget.primaryColor,
//             Colors.black,
//           ],
//           stops: const [0.0, 0.6, 1.0],
//         ),
//       ),
//       child: Stack(
//         children: [
//           // Animated wave layers
//           if (widget.enableWaves) ..._buildWaveLayers(),
          
//           // Floating orbs
//           if (widget.enableOrbs) ..._buildFloatingOrbs(),
          
//           // Particle system
//           if (widget.enableParticles) ..._buildParticleSystem(),
          
//           // Depth grid effect
//           _buildDepthGrid(),
          
//           // Child content
//           widget.child,
//         ],
//       ),
//     );
//   }

//   List<Widget> _buildWaveLayers() {
//     return List.generate(3, (index) {
//       return AnimatedBuilder(
//         animation: Listenable.merge([_primaryController, _pulseAnimation]),
//         builder: (context, child) {
//           return Positioned(
//             left: -200,
//             top: -100 + (index * 150),
//             child: Transform.rotate(
//               angle: _rotationAnimation.value * (0.3 + index * 0.1),
//               child: Transform.scale(
//                 scale: _pulseAnimation.value * (0.8 + index * 0.1),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 1.5,
//                   height: 300,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.blue.withOpacity(0.03 / (index + 1)),
//                         Colors.purple.withOpacity(0.02 / (index + 1)),
//                         Colors.transparent,
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(150),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }

//   List<Widget> _buildFloatingOrbs() {
//     return List.generate(5, (index) {
//       final double orbSize = 120 - (index * 15);
//       final double speed = 0.5 + (index * 0.2);
      
//       return AnimatedBuilder(
//         animation: _rotationAnimation,
//         builder: (context, child) {
//           final double radius = 150 + (index * 80);
//           final double angle = (_rotationAnimation.value * speed) + (index * (2 * math.pi / 5));
          
//           final double x = MediaQuery.of(context).size.width / 2 + 
//                           radius * math.cos(angle);
//           final double y = MediaQuery.of(context).size.height / 2 + 
//                           radius * math.sin(angle) * 0.6; // Flatten the orbit
          
//           return Positioned(
//             left: x - orbSize / 2,
//             top: y - orbSize / 2,
//             child: Transform(
//               alignment: Alignment.center,
//               transform: Matrix4.identity()
//                 ..setEntry(3, 2, 0.001)
//                 ..rotateY(angle * 0.3)
//                 ..rotateX(angle * 0.1),
//               child: Container(
//                 width: orbSize,
//                 height: orbSize,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       Colors.white.withOpacity(0.08 / (index + 1)),
//                       Colors.blue.withOpacity(0.05 / (index + 1)),
//                       Colors.transparent,
//                     ],
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.blue.withOpacity(0.1 / (index + 1)),
//                       blurRadius: 20,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }

//   List<Widget> _buildParticleSystem() {
//     return List.generate(15, (index) {
//       final double particleSize = 3 + (index % 4);
      
//       return AnimatedBuilder(
//         animation: _particleAnimation,
//         builder: (context, child) {
//           final double offsetX = index * 80.0;
//           final double offsetY = index * 60.0;
//           final double floatX = 40 * math.sin(_particleAnimation.value + index);
//           final double floatY = 30 * math.cos(_particleAnimation.value * 0.7 + index);
          
//           return Positioned(
//             left: (offsetX + floatX) % MediaQuery.of(context).size.width,
//             top: (offsetY + floatY) % MediaQuery.of(context).size.height,
//             child: Transform.scale(
//               scale: _pulseAnimation.value * (0.5 + (index % 3) * 0.2),
//               child: Container(
//                 width: particleSize,
//                 height: particleSize,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white.withOpacity(0.4),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.white.withOpacity(0.6),
//                       blurRadius: 8,
//                       spreadRadius: 2,
//                     ),
//                     BoxShadow(
//                       color: Colors.blue.withOpacity(0.3),
//                       blurRadius: 15,
//                       spreadRadius: 3,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }

//   Widget _buildDepthGrid() {
//     return AnimatedBuilder(
//       animation: _primaryController,
//       builder: (context, child) {
//         return Positioned.fill(
//           child: CustomPaint(
//             painter: DepthGridPainter(
//               animation: _rotationAnimation.value,
//               pulseAnimation: _pulseAnimation.value,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class DepthGridPainter extends CustomPainter {
//   final double animation;
//   final double pulseAnimation;

//   DepthGridPainter({
//     required this.animation,
//     required this.pulseAnimation,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 0.5;

//     // Create perspective grid lines
//     final int gridLines = 8;
//     final double centerX = size.width / 2;
//     final double centerY = size.height / 2;

//     // Vertical perspective lines
//     for (int i = 0; i < gridLines; i++) {
//       final double t = (i / (gridLines - 1)) - 0.5;
//       final double x = centerX + (t * size.width * 0.6);
//       final double perspective = (1 - math.cos(animation + t)) * 0.1;
      
//       paint.color = Colors.white.withOpacity(0.03 * pulseAnimation);
      
//       final Path path = Path()
//         ..moveTo(x + perspective * 50, 0)
//         ..lineTo(x - perspective * 50, size.height);
      
//       canvas.drawPath(path, paint);
//     }

//     // Horizontal perspective lines
//     for (int i = 0; i < gridLines; i++) {
//       final double t = (i / (gridLines - 1)) - 0.5;
//       final double y = centerY + (t * size.height * 0.6);
//       final double perspective = math.sin(animation + t) * 0.05;
      
//       paint.color = Colors.white.withOpacity(0.02 * pulseAnimation);
      
//       final Path path = Path()
//         ..moveTo(0, y + perspective * 30)
//         ..lineTo(size.width, y - perspective * 30);
      
//       canvas.drawPath(path, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(DepthGridPainter oldDelegate) {
//     return oldDelegate.animation != animation ||
//            oldDelegate.pulseAnimation != pulseAnimation;
//   }
// }


//2



import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final Color primaryColor;
  final Color secondaryColor;
  final bool enableParticles;
  final bool enableWaves;
  final bool enableOrbs;
  final double animationSpeed;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.primaryColor = const Color(0xFF0A0A0A), // Deep black
    this.secondaryColor = const Color(0xFF1C1C1E), // Dark gray
    this.enableParticles = true,
    this.enableWaves = true,
    this.enableOrbs = true,
    this.animationSpeed = 1.0,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _secondaryController;
  late AnimationController _particleController;
  
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _primaryController = AnimationController(
      duration: Duration(seconds: (30 / widget.animationSpeed).round()),
      vsync: this,
    );

    _secondaryController = AnimationController(
      duration: Duration(seconds: (5 / widget.animationSpeed).round()),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: Duration(seconds: (20 / widget.animationSpeed).round()),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _primaryController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _secondaryController,
      curve: Curves.easeInOutSine,
    ));

    _particleAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.linear,
    ));

    _primaryController.repeat();
    _secondaryController.repeat(reverse: true);
    _particleController.repeat();
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 2.0,
          colors: [
            widget.secondaryColor,
            widget.primaryColor,
            Colors.black,
          ],
          stops: const [0.0, 0.4, 1.0],
        ),
      ),
      child: Stack(
        children: [
          if (widget.enableWaves) ..._buildWaveLayers(),
          if (widget.enableOrbs) ..._buildFloatingOrbs(),
          if (widget.enableParticles) ..._buildParticleSystem(),
          _buildDepthGrid(),
          widget.child,
        ],
      ),
    );
  }

  List<Widget> _buildWaveLayers() {
    return List.generate(2, (index) {
      return AnimatedBuilder(
        animation: Listenable.merge([_primaryController, _pulseAnimation]),
        builder: (context, child) {
          return Positioned(
            left: -200,
            top: -100 + (index * 200),
            child: Transform.rotate(
              angle: _rotationAnimation.value * (0.2 + index * 0.1),
              child: Transform.scale(
                scale: _pulseAnimation.value * (0.9 + index * 0.05),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.6,
                  height: 350,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.015 / (index + 1)),
                        Colors.grey.withOpacity(0.01 / (index + 1)),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(200),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  List<Widget> _buildFloatingOrbs() {
    return List.generate(4, (index) {
      final double orbSize = 100 - (index * 15);
      final double speed = 0.4 + (index * 0.15);
      
      return AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          final double radius = 120 + (index * 90);
          final double angle = (_rotationAnimation.value * speed) + (index * (2 * math.pi / 4));
          
          final double x = MediaQuery.of(context).size.width / 2 + 
                          radius * math.cos(angle);
          final double y = MediaQuery.of(context).size.height / 2 + 
                          radius * math.sin(angle) * 0.5;
          
          return Positioned(
            left: x - orbSize / 2,
            top: y - orbSize / 2,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle * 0.2)
                ..rotateX(angle * 0.05),
              child: Container(
                width: orbSize,
                height: orbSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.05 / (index + 1)),
                      Colors.grey.withOpacity(0.03 / (index + 1)),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.07 / (index + 1)),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  List<Widget> _buildParticleSystem() {
    return List.generate(8, (index) {
      final double particleSize = 2 + (index % 3);
      
      return AnimatedBuilder(
        animation: _particleAnimation,
        builder: (context, child) {
          final double offsetX = index * 100.0;
          final double offsetY = index * 80.0;
          final double floatX = 30 * math.sin(_particleAnimation.value + index);
          final double floatY = 20 * math.cos(_particleAnimation.value * 0.6 + index);
          
          return Positioned(
            left: (offsetX + floatX) % MediaQuery.of(context).size.width,
            top: (offsetY + floatY) % MediaQuery.of(context).size.height,
            child: Transform.scale(
              scale: _pulseAnimation.value * (0.6 + (index % 3) * 0.15),
              child: Container(
                width: particleSize,
                height: particleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildDepthGrid() {
    return AnimatedBuilder(
      animation: _primaryController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: DepthGridPainter(
              animation: _rotationAnimation.value,
              pulseAnimation: _pulseAnimation.value,
            ),
          ),
        );
      },
    );
  }
}

class DepthGridPainter extends CustomPainter {
  final double animation;
  final double pulseAnimation;

  DepthGridPainter({
    required this.animation,
    required this.pulseAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3;

    final int gridLines = 6;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    for (int i = 0; i < gridLines; i++) {
      final double t = (i / (gridLines - 1)) - 0.5;
      final double x = centerX + (t * size.width * 0.7);
      final double perspective = (1 - math.cos(animation + t)) * 0.08;
      
      paint.color = Colors.white.withOpacity(0.02 * pulseAnimation);
      
      final Path path = Path()
        ..moveTo(x + perspective * 40, 0)
        ..lineTo(x - perspective * 40, size.height);
      
      canvas.drawPath(path, paint);
    }

    for (int i = 0; i < gridLines; i++) {
      final double t = (i / (gridLines - 1)) - 0.5;
      final double y = centerY + (t * size.height * 0.7);
      final double perspective = math.sin(animation + t) * 0.04;
      
      paint.color = Colors.white.withOpacity(0.01 * pulseAnimation);
      
      final Path path = Path()
        ..moveTo(0, y + perspective * 20)
        ..lineTo(size.width, y - perspective * 20);
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(DepthGridPainter oldDelegate) {
    return oldDelegate.animation != animation ||
           oldDelegate.pulseAnimation != pulseAnimation;
  }
}