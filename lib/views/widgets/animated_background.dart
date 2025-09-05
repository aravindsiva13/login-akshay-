
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
    this.secondaryColor = const Color(0xFF0A0A0A), // Dark gray
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
  late AnimationController _glowController;
  
  late Animation<double> _rotationAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _primaryController = AnimationController(
      duration: Duration(seconds: (25 / widget.animationSpeed).round()),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: Duration(seconds: (8 / widget.animationSpeed).round()),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _primaryController,
      curve: Curves.linear,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOutSine,
    ));

    _primaryController.repeat();
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.8,
          colors: [
            widget.secondaryColor.withOpacity(0.8),
            widget.primaryColor,
            Colors.black,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Premium glowing particles
          if (widget.enableParticles) _buildPremiumParticles(),
          
          // 3D floating orbs
          if (widget.enableOrbs) _buildPremiumOrbs(),
          
          // Depth grid with glow
          if (widget.enableWaves) _buildPremiumGrid(),
          
          // Main content
          widget.child,
        ],
      ),
    );
  }

  Widget _buildPremiumParticles() {
    return AnimatedBuilder(
      animation: Listenable.merge([_primaryController, _glowController]),
      builder: (context, child) {
        return Stack(
          children: List.generate(6, (index) {
            final double size = 2.5 + (index % 3) * 1.5;
            final double speed = 0.3 + (index * 0.08);
            final double angle = (_rotationAnimation.value * speed) + (index * math.pi / 3);
            
            final double x = MediaQuery.of(context).size.width * (0.2 + (index * 0.15)) +
                            80 * math.sin(angle);
            final double y = MediaQuery.of(context).size.height * (0.1 + (index * 0.18)) +
                            60 * math.cos(angle * 0.7);
            final double z = 40 * math.sin(angle * 1.3);
            
            return Positioned(
              left: x,
              top: y,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(0.0, 0.0, z)
                  ..scale(0.8 + (z + 40) / 80 * 0.4),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.9 * _glowAnimation.value),
                        Colors.blue.withOpacity(0.4 * _glowAnimation.value),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.6 * _glowAnimation.value),
                        blurRadius: 20 + (z + 40) / 10,
                        spreadRadius: 5 + (z + 40) / 15,
                      ),
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3 * _glowAnimation.value),
                        blurRadius: 35 + (z + 40) / 8,
                        spreadRadius: 8 + (z + 40) / 12,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildPremiumOrbs() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Stack(
          children: List.generate(3, (index) {
            final double orbSize = 120 - (index * 25);
            final double speed = 0.15 + (index * 0.05);
            final double radius = 100 + (index * 140);
            final double angle = (_rotationAnimation.value * speed) + (index * (2 * math.pi / 3));
            
            final double x = MediaQuery.of(context).size.width / 2 + 
                            radius * math.cos(angle);
            final double y = MediaQuery.of(context).size.height / 2 + 
                            radius * math.sin(angle) * 0.4;
            final double z = 60 * math.sin(angle * 1.5);
            
            return Positioned(
              left: x - orbSize / 2,
              top: y - orbSize / 2,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(0.0, 0.0, z)
                  ..rotateY(angle * 0.3)
                  ..scale(0.7 + (z + 60) / 120 * 0.3),
                child: Container(
                  width: orbSize,
                  height: orbSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      center: Alignment(-0.3, -0.3),
                      colors: [
                        Colors.white.withOpacity(0.15 * _glowAnimation.value),
                        Colors.white.withOpacity(0.08 * _glowAnimation.value),
                        Colors.blue.withOpacity(0.04 * _glowAnimation.value),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4, 0.7, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.15 * _glowAnimation.value),
                        blurRadius: 50 + (z + 60) / 5,
                        spreadRadius: 15 + (z + 60) / 8,
                      ),
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.08 * _glowAnimation.value),
                        blurRadius: 80 + (z + 60) / 4,
                        spreadRadius: 25 + (z + 60) / 6,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildPremiumGrid() {
    return AnimatedBuilder(
      animation: Listenable.merge([_primaryController, _glowController]),
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: PremiumGridPainter(
              animation: _rotationAnimation.value,
              glowAnimation: _glowAnimation.value,
            ),
          ),
        );
      },
    );
  }
}

class PremiumGridPainter extends CustomPainter {
  final double animation;
  final double glowAnimation;

  PremiumGridPainter({
    required this.animation,
    required this.glowAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Premium flowing lines
    _drawFlowingLines(canvas, size, paint);
    
    // Glowing connection nodes
    _drawGlowingNodes(canvas, size, paint);
  }

  void _drawFlowingLines(Canvas canvas, Size size, Paint paint) {
    const int lines = 4;
    
    for (int i = 0; i < lines; i++) {
      final double waveOffset = (i / lines) * 2 * math.pi;
      final double amplitude = 40 * glowAnimation;
      
      final Path path = Path();
      bool firstPoint = true;
      
      for (double x = 0; x <= size.width + 50; x += 25) {
        final double wave = math.sin((x * 0.01) + (animation * 0.5) + waveOffset) * amplitude;
        final double y = (size.height * (0.2 + i * 0.25)) + wave;
        
        if (firstPoint) {
          path.moveTo(x, y);
          firstPoint = false;
        } else {
          path.lineTo(x, y);
        }
      }
      
      paint.color = Colors.white.withOpacity(0.06 * glowAnimation);
      paint.shader = LinearGradient(
        colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.15 * glowAnimation),
          Colors.blue.withOpacity(0.08 * glowAnimation),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      
      canvas.drawPath(path, paint);
    }
  }

  void _drawGlowingNodes(Canvas canvas, Size size, Paint paint) {
    paint.style = PaintingStyle.fill;
    
    for (int i = 0; i < 4; i++) {
      final double nodeSpeed = 0.7 + (i * 0.4);
      final double x = size.width * (0.15 + i * 0.25) + 40 * math.sin(animation * nodeSpeed);
      final double y = size.height * (0.25 + math.sin(animation * 0.8 + i) * 0.3);
      
      // Individual node glow animation
      final double nodeGlow = math.sin((animation * nodeSpeed) + (i * math.pi / 2));
      final double nodeGlowIntensity = glowAnimation * (0.3 + 0.7 * ((nodeGlow + 1) / 2));
      final double nodeSize = 3 + math.sin(animation * 2.5 + i) * 2 + (nodeGlowIntensity * 2);
      
      // Outer aura
      paint.color = Colors.cyan.withOpacity(0.05 * nodeGlowIntensity);
      canvas.drawCircle(Offset(x, y), nodeSize * 8, paint);
      
      // Mid glow
      paint.color = Colors.blue.withOpacity(0.15 * nodeGlowIntensity);
      canvas.drawCircle(Offset(x, y), nodeSize * 5, paint);
      
      // Inner glow
      paint.color = Colors.white.withOpacity(0.4 * nodeGlowIntensity);
      canvas.drawCircle(Offset(x, y), nodeSize * 2.5, paint);
      
      // Core
      paint.color = const Color.fromARGB(255, 3, 3, 3).withOpacity(0.9 * nodeGlowIntensity);
      canvas.drawCircle(Offset(x, y), nodeSize, paint);
    }
  }

  @override
  bool shouldRepaint(PremiumGridPainter oldDelegate) {
    return oldDelegate.animation != animation ||
           oldDelegate.glowAnimation != glowAnimation;
  }
}


