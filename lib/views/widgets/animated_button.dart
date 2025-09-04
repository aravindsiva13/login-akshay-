// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:math' as math;

// class AnimatedButton extends StatefulWidget {
//   final String text;
//   final VoidCallback? onPressed;
//   final bool isLoading;
//   final bool isPrimary;
//   final double? height;

//   const AnimatedButton({
//     super.key,
//     required this.text,
//     this.onPressed,
//     this.isLoading = false,
//     this.isPrimary = true,
//     this.height,
//   });

//   @override
//   State<AnimatedButton> createState() => _AnimatedButtonState();
// }

// class _AnimatedButtonState extends State<AnimatedButton>
//     with TickerProviderStateMixin {
//   bool _isPressed = false;
//   late AnimationController _pressController;
//   late AnimationController _glowController;
//   late AnimationController _rippleController;
  
//   late Animation<double> _pressScale;
//   late Animation<double> _pressDepth;
//   late Animation<double> _glowIntensity;
//   late Animation<double> _rippleScale;
//   late Animation<double> _rippleOpacity;

//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//   }

//   void _setupAnimations() {
//     _pressController = AnimationController(
//       duration: const Duration(milliseconds: 120),
//       vsync: this,
//     );
    
//     _glowController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );
    
//     _rippleController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _pressScale = Tween<double>(
//       begin: 1.0,
//       end: 0.96,
//     ).animate(CurvedAnimation(
//       parent: _pressController,
//       curve: Curves.easeInOut,
//     ));

//     _pressDepth = Tween<double>(
//       begin: 0.0,
//       end: 8.0,
//     ).animate(CurvedAnimation(
//       parent: _pressController,
//       curve: Curves.easeInOut,
//     ));

//     _glowIntensity = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _glowController,
//       curve: Curves.easeOut,
//     ));

//     _rippleScale = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _rippleController,
//       curve: Curves.easeOut,
//     ));

//     _rippleOpacity = Tween<double>(
//       begin: 0.8,
//       end: 0.0,
//     ).animate(CurvedAnimation(
//       parent: _rippleController,
//       curve: Curves.easeOut,
//     ));
//   }

//   @override
//   void dispose() {
//     _pressController.dispose();
//     _glowController.dispose();
//     _rippleController.dispose();
//     super.dispose();
//   }

//   void _onTapDown(TapDownDetails details) {
//     if (widget.onPressed != null && !widget.isLoading) {
//       setState(() => _isPressed = true);
//       _pressController.forward();
//       _rippleController.forward();
//       HapticFeedback.mediumImpact();
//     }
//   }

//   void _onTapUp(TapUpDetails details) {
//     _resetButton();
//   }

//   void _onTapCancel() {
//     _resetButton();
//   }

//   void _resetButton() {
//     if (mounted) {
//       setState(() => _isPressed = false);
//       _pressController.reverse();
//       _glowController.forward().then((_) {
//         if (mounted) _glowController.reverse();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: _onTapDown,
//       onTapUp: _onTapUp,
//       onTapCancel: _onTapCancel,
//       onTap: widget.onPressed,
//       child: AnimatedBuilder(
//         animation: Listenable.merge([
//           _pressController,
//           _glowController,
//           _rippleController,
//         ]),
//         builder: (context, child) {
//           return Transform.scale(
//             scale: _pressScale.value,
//             child: Container(
//               width: double.infinity,
//               height: widget.height ?? 56,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   // Main shadow that moves with press
//                   BoxShadow(
//                     color: widget.isPrimary 
//                         ? Colors.black.withOpacity(0.3)
//                         : Colors.black.withOpacity(0.2),
//                     offset: Offset(0, 12 - _pressDepth.value),
//                     blurRadius: 25 - (_pressDepth.value * 2),
//                     spreadRadius: 2 - (_pressDepth.value * 0.3),
//                   ),
//                   // Glow effect
//                   if (_glowIntensity.value > 0.1)
//                     BoxShadow(
//                       color: (widget.isPrimary ? Colors.blue : Colors.white)
//                           .withOpacity(0.4 * _glowIntensity.value),
//                       blurRadius: 30 * _glowIntensity.value,
//                       spreadRadius: 8 * _glowIntensity.value,
//                     ),
//                 ],
//               ),
//               child: Transform.translate(
//                 offset: Offset(0, _pressDepth.value),
//                 child: Stack(
//                   children: [
//                     // Main button container
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: widget.isPrimary
//                               ? (_isPressed
//                                   ? [
//                                       const Color(0xFFE0E0E0),
//                                       const Color(0xFFD0D0D0),
//                                       const Color(0xFFB8B8B8),
//                                       const Color(0xFFA0A0A0),
//                                     ]
//                                   : [
//                                       const Color(0xFFFFFFFF),
//                                       const Color(0xFFF8F8F8),
//                                       const Color(0xFFE8E8E8),
//                                       const Color(0xFFD8D8D8),
//                                     ])
//                               : (_isPressed
//                                   ? [
//                                       Colors.white.withOpacity(0.12),
//                                       Colors.white.withOpacity(0.08),
//                                       Colors.white.withOpacity(0.04),
//                                       Colors.white.withOpacity(0.02),
//                                     ]
//                                   : [
//                                       Colors.white.withOpacity(0.20),
//                                       Colors.white.withOpacity(0.15),
//                                       Colors.white.withOpacity(0.10),
//                                       Colors.white.withOpacity(0.05),
//                                     ]),
//                           stops: const [0.0, 0.3, 0.7, 1.0],
//                         ),
//                         border: widget.isPrimary
//                             ? null
//                             : Border.all(
//                                 color: Colors.white.withOpacity(_isPressed ? 0.2 : 0.3),
//                                 width: 1.5,
//                               ),
//                         boxShadow: [
//                           // Inner highlight
//                           if (!_isPressed)
//                             BoxShadow(
//                               color: Colors.white.withOpacity(widget.isPrimary ? 0.6 : 0.2),
//                               offset: const Offset(0, -1),
//                               blurRadius: 3,
//                               spreadRadius: 0,
//                             ),
//                           // Inner shadow when pressed
//                           if (_isPressed)
//                             BoxShadow(
//                               color: Colors.black.withOpacity(widget.isPrimary ? 0.15 : 0.1),
//                               offset: const Offset(0, 3),
//                               blurRadius: 6,
//                               spreadRadius: -2,
//                             ),
//                         ],
//                       ),
//                       child: Material(
//                         color: Colors.transparent,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Center(
//                             child: AnimatedSwitcher(
//                               duration: const Duration(milliseconds: 200),
//                               child: widget.isLoading
//                                   ? SizedBox(
//                                       width: 24,
//                                       height: 24,
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 3,
//                                         valueColor: AlwaysStoppedAnimation<Color>(
//                                           widget.isPrimary 
//                                               ? Colors.black54 
//                                               : Colors.white70,
//                                         ),
//                                       ),
//                                     )
//                                   : Text(
//                                       widget.text,
//                                       style: TextStyle(
//                                         fontSize: 17,
//                                         fontWeight: widget.isPrimary 
//                                             ? FontWeight.w700 
//                                             : FontWeight.w600,
//                                         color: widget.isPrimary
//                                             ? (_isPressed ? Colors.black54 : Colors.black87)
//                                             : (_isPressed ? Colors.white60 : Colors.white),
//                                         letterSpacing: 0.8,
//                                       ),
//                                     ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
                    
//                     // Ripple effect overlay
//                     if (_rippleScale.value > 0)
//                       Positioned.fill(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                             color: (widget.isPrimary ? Colors.white : Colors.white)
//                                 .withOpacity(0.3 * _rippleOpacity.value),
//                           ),
//                           transform: Matrix4.identity()
//                             ..scale(_rippleScale.value),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


//2

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPrimary;
  final double? height;

  const AnimatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.height,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  bool _isPressed = false;
  bool _isHovered = false;
  late AnimationController _pressController;
  late AnimationController _glowController;
  late AnimationController _rippleController;
  late AnimationController _hoverController;
  late AnimationController _shimmerController;
  
  late Animation<double> _pressScale;
  late Animation<double> _pressDepth;
  late Animation<double> _glowIntensity;
  late Animation<double> _rippleScale;
  late Animation<double> _rippleOpacity;
  late Animation<double> _hoverScale;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    if (!widget.isPrimary) {
      _startShimmerAnimation();
    }
  }

  void _setupAnimations() {
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _pressScale = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));

    _pressDepth = Tween<double>(
      begin: 0.0,
      end: 6.0,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));

    _glowIntensity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeOut,
    ));

    _rippleScale = Tween<double>(
      begin: 0.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    _rippleOpacity = Tween<double>(
      begin: 0.6,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    _hoverScale = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.linear,
    ));
  }

  void _startShimmerAnimation() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !widget.isPrimary) {
        _shimmerController.repeat(period: const Duration(seconds: 4));
      }
    });
  }

  @override
  void dispose() {
    _pressController.dispose();
    _glowController.dispose();
    _rippleController.dispose();
    _hoverController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _pressController.forward();
      _rippleController.forward();
      HapticFeedback.mediumImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _resetButton();
  }

  void _onTapCancel() {
    _resetButton();
  }

  void _onHoverEnter() {
    setState(() => _isHovered = true);
    _hoverController.forward();
    if (!widget.isPrimary) {
      _glowController.forward();
    }
  }

  void _onHoverExit() {
    setState(() => _isHovered = false);
    _hoverController.reverse();
    if (!widget.isPrimary) {
      _glowController.reverse();
    }
  }

  void _resetButton() {
    if (mounted) {
      setState(() => _isPressed = false);
      _pressController.reverse();
      _rippleController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverEnter(),
      onExit: (_) => _onHoverExit(),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _pressController,
            _glowController,
            _rippleController,
            _hoverController,
            _shimmerController,
          ]),
          builder: (context, child) {
            return Transform.scale(
              scale: _pressScale.value * _hoverScale.value,
              child: Container(
                width: double.infinity,
                height: widget.height ?? 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    // Main shadow that moves with press
                    BoxShadow(
                      color: widget.isPrimary 
                          ? Colors.black.withOpacity(0.25)
                          : Colors.black.withOpacity(0.15),
                      offset: Offset(0, (widget.isPrimary ? 12 : 8) - _pressDepth.value),
                      blurRadius: (widget.isPrimary ? 25 : 20) - (_pressDepth.value * 2),
                      spreadRadius: (widget.isPrimary ? 2 : 1) - (_pressDepth.value * 0.3),
                    ),
                    // Enhanced glow effect for secondary button
                    if (!widget.isPrimary && _glowIntensity.value > 0.1)
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1 * _glowIntensity.value),
                        blurRadius: 5 * _glowIntensity.value,
                        spreadRadius: 3 * _glowIntensity.value,
                      ),
                    // if (!widget.isPrimary && _glowIntensity.value > 0.1)
                    //   BoxShadow(
                    //     color: Colors.blue.withOpacity(0.1 * _glowIntensity.value),
                    //     blurRadius: 60 * _glowIntensity.value,
                    //     spreadRadius: 15 * _glowIntensity.value,
                    //   ),
                    // Primary button glow
                    if (widget.isPrimary && _glowIntensity.value > 0.1)
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4 * _glowIntensity.value),
                        blurRadius: 30 * _glowIntensity.value,
                        spreadRadius: 8 * _glowIntensity.value,
                      ),
                  ],
                ),
                child: Transform.translate(
                  offset: Offset(0, _pressDepth.value),
                  child: Stack(
                    children: [
                      // Main button container
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: widget.isPrimary
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: _isPressed
                                      ? [
                                          const Color(0xFFE0E0E0),
                                          const Color(0xFFD0D0D0),
                                          const Color(0xFFB8B8B8),
                                          const Color(0xFFA0A0A0),
                                        ]
                                      : [
                                          const Color(0xFFFFFFFF),
                                          const Color(0xFFF8F8F8),
                                          const Color(0xFFE8E8E8),
                                          const Color(0xFFD8D8D8),
                                        ],
                                  stops: const [0.0, 0.3, 0.7, 1.0],
                                )
                              : LinearGradient(
  colors: _isPressed
      ? [
          Colors.black.withOpacity(0.1),
          Colors.black.withOpacity(0.08),
          Colors.black.withOpacity(0.06),
          Colors.black.withOpacity(0.03),
        ]
      : _isHovered
          ? [
              Colors.black.withOpacity(0.22),
              Colors.black.withOpacity(0.18),
              Colors.black.withOpacity(0.14),
              Colors.black.withOpacity(0.08),
            ]
          : [
              Colors.black.withOpacity(0.15),
              Colors.black.withOpacity(0.12),
              Colors.black.withOpacity(0.09),
              Colors.black.withOpacity(0.05),
            ],
  stops: const [0.0, 0.3, 0.7, 1.0],
),
                          border: widget.isPrimary
                              ? null
                              : Border.all(
                                  color: _isHovered
                                      ? Colors.white.withOpacity(0.4)
                                      : Colors.white.withOpacity(_isPressed ? 0.15 : 0.25),
                                  width: _isHovered ? 1.8 : 1.5,
                                ),
                          boxShadow: [
                            // Inner highlight
                            if (!_isPressed)
                              BoxShadow(
                                // color: const Color.fromARGB(0, 12, 11, 11).withOpacity(widget.isPrimary ? 0.6 : 0.3),


                                color: const Color.fromARGB(0, 12, 11, 11).withOpacity(0.30),
                                offset: const Offset(0, -1),
                                blurRadius: widget.isPrimary ? 3 : 4,
                                spreadRadius: 0,
                              ),
                            // Inner shadow when pressed
                            if (_isPressed)
                              BoxShadow(
                                color: Colors.black.withOpacity(widget.isPrimary ? 0.15 : 0.08),
                                offset: const Offset(0, 3),
                                blurRadius: 8,
                                spreadRadius: -2,
                              ),
                          ],     
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: widget.isLoading
                                    ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            widget.isPrimary 
                                                ? Colors.black54 
                                                : Colors.white70,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        widget.text,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: widget.isPrimary 
                                              ? FontWeight.w700 
                                              : FontWeight.w600,
                                          color: widget.isPrimary
                                              ? (_isPressed ? Colors.black54 : Colors.black87)
                                              : (_isPressed 
                                                  ? Colors.white60 
                                                  : _isHovered
                                                      ? Colors.white
                                                      : Colors.white.withOpacity(0.9)),
                                          letterSpacing: 0.8,
                                          shadows: !widget.isPrimary
                                              ? [
                                                  Shadow(
                                                    color: Colors.black.withOpacity(0.3),
                                                    offset: const Offset(0, 1),
                                                    blurRadius: 2,
                                                  ),
                                                ]
                                              : null,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Shimmer effect for secondary button
                      if (!widget.isPrimary && _shimmerAnimation.value > -0.5 && _shimmerAnimation.value < 1.5)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.1),
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                  stops: [
                                    math.max(0.0, _shimmerAnimation.value - 0.3),
                                    math.max(0.0, _shimmerAnimation.value - 0.15),
                                    math.min(1.0, _shimmerAnimation.value),
                                    math.min(1.0, _shimmerAnimation.value + 0.15),
                                    math.min(1.0, _shimmerAnimation.value + 0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      
                      // Ripple effect overlay
                      if (_rippleScale.value > 0)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: (widget.isPrimary ? Colors.white : Colors.white)
                                    .withOpacity(0.2 * _rippleOpacity.value),
                              ),
                              transform: Matrix4.identity()
                                ..scale(_rippleScale.value),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}