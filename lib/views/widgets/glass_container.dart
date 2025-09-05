// import 'package:flutter/material.dart';
// import 'dart:ui';

// class GlassContainer extends StatelessWidget {
//   final Widget child;

//   const GlassContainer({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 400,
//       constraints: const BoxConstraints(maxWidth: 400),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.2),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(32),
//       child: child,
//     );
//   }
// }


// //2- corect hover tracker 

// import 'package:flutter/material.dart';
// import 'dart:ui';
// import 'dart:math' as math;

// class GlassContainer extends StatefulWidget {
//   final Widget child;
//   final bool enable3DEffect;

//   const GlassContainer({
//     super.key, 
//     required this.child,
//     this.enable3DEffect = true,
//   });

//   @override
//   State<GlassContainer> createState() => _GlassContainerState();
// }

// class _GlassContainerState extends State<GlassContainer>
//     with SingleTickerProviderStateMixin {
  
//   double _rotateX = 0.0;
//   double _rotateY = 0.0;
//   double _targetRotateX = 0.0;
//   double _targetRotateY = 0.0;
//   bool _isHovered = false;
  
//   late AnimationController _smoothController;
  
//   @override
//   void initState() {
//     super.initState();
//     _smoothController = AnimationController(
//       duration: const Duration(milliseconds: 100), // Fast but smooth
//       vsync: this,
//     );
    
//     _smoothController.addListener(() {
//       setState(() {
//         // Interpolate between current and target positions
//         _rotateX = _lerp(_rotateX, _targetRotateX, 0.15);
//         _rotateY = _lerp(_rotateY, _targetRotateY, 0.15);
//       });
//     });
    
//     // Start continuous smooth animation
//     _smoothController.repeat();
//   }

//   @override
//   void dispose() {
//     _smoothController.dispose();
//     super.dispose();
//   }

//   // Linear interpolation for smooth movement
//   double _lerp(double current, double target, double factor) {
//     return current + (target - current) * factor;
//   }

//   void _updateTransform(Offset localPosition, Size size) {
//     if (!widget.enable3DEffect) return;

//     // Normalize position to -1 to 1 range
//     final double normalizedX = (localPosition.dx / size.width) * 2 - 1;
//     final double normalizedY = (localPosition.dy / size.height) * 2 - 1;

//     // Calculate target rotation (reduced intensity for smoothness)
//     final double maxRotation = 10.0;
//     _targetRotateY = normalizedX * maxRotation;
//     _targetRotateX = -normalizedY * maxRotation;
//   }

//   void _onHoverEnter() {
//     if (mounted) {
//       setState(() {
//         _isHovered = true;
//       });
//     }
//   }

//   void _onHoverExit() {
//     if (mounted) {
//       setState(() {
//         _targetRotateX = 0.0;
//         _targetRotateY = 0.0;
//         _isHovered = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: widget.enable3DEffect ? (_) => _onHoverEnter() : null,
//       onExit: widget.enable3DEffect ? (_) => _onHoverExit() : null,
//       onHover: widget.enable3DEffect ? (event) {
//         final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
//         if (renderBox != null) {
//           final Size size = renderBox.size;
//           final Offset localPosition = renderBox.globalToLocal(event.position);
//           _updateTransform(localPosition, size);
//         }
//       } : null,
//       child: Transform(
//         alignment: Alignment.center,
//         transform: widget.enable3DEffect 
//             ? (Matrix4.identity()
//                 ..setEntry(3, 2, 0.001) // perspective
//                 ..rotateX(_rotateX * (math.pi / 180))
//                 ..rotateY(_rotateY * (math.pi / 180)))
//             : Matrix4.identity(),
//         child: Container(
//           width: 400,
//           constraints: const BoxConstraints(maxWidth: 400),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: Colors.white.withOpacity(0.2),
//               width: 1,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//               // Enhanced shadow on hover
//               if (_isHovered && widget.enable3DEffect)
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.15),
//                   blurRadius: 15,
//                   offset: Offset(_rotateY * 0.3, 8 + (_rotateX * 0.2)),
//                 ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: _isHovered && widget.enable3DEffect
//                       ? Colors.white.withOpacity(0.12)
//                       : Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 padding: const EdgeInsets.all(32),
//                 child: widget.child,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


//3



import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class GlassContainer extends StatefulWidget {
  final Widget child;
  final bool enable3DEffect;

  const GlassContainer({
    super.key, 
    required this.child,
    this.enable3DEffect = true,
  });

  @override
  State<GlassContainer> createState() => _GlassContainerState();
}

class _GlassContainerState extends State<GlassContainer>
    with SingleTickerProviderStateMixin {
  
  double _rotateX = 0.0;
  double _rotateY = 0.0;
  double _targetRotateX = 0.0;
  double _targetRotateY = 0.0;
  bool _isHovered = false;
  
  late AnimationController _smoothController;
  
  @override
  void initState() {
    super.initState();
    _smoothController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    _smoothController.addListener(() {
      setState(() {
        _rotateX = _lerp(_rotateX, _targetRotateX, 0.15);
        _rotateY = _lerp(_rotateY, _targetRotateY, 0.15);
      });
    });
    
    _smoothController.repeat();
  }

  @override
  void dispose() {
    _smoothController.dispose();
    super.dispose();
  }

  double _lerp(double current, double target, double factor) {
    return current + (target - current) * factor;
  }

  void _updateTransform(Offset localPosition, Size size) {
    if (!widget.enable3DEffect) return;

    final double normalizedX = (localPosition.dx / size.width) * 2 - 1;
    final double normalizedY = (localPosition.dy / size.height) * 2 - 1;

    final double maxRotation = 10.0;
    _targetRotateY = normalizedX * maxRotation;
    _targetRotateX = -normalizedY * maxRotation;
  }

  void _onHoverEnter() {
    if (mounted) {
      setState(() {
        _isHovered = true;
      });
    }
  }

  void _onHoverExit() {
    if (mounted) {
      setState(() {
        _targetRotateX = 0.0;
        _targetRotateY = 0.0;
        _isHovered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.enable3DEffect ? (_) => _onHoverEnter() : null,
      onExit: widget.enable3DEffect ? (_) => _onHoverExit() : null,
      onHover: widget.enable3DEffect ? (event) {
        final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final Size size = renderBox.size;
          final Offset localPosition = renderBox.globalToLocal(event.position);
          _updateTransform(localPosition, size);
        }
      } : null,
      child: Transform(
        alignment: Alignment.center,
        transform: widget.enable3DEffect 
            ? (Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_rotateX * (math.pi / 180))
                ..rotateY(_rotateY * (math.pi / 180)))
            : Matrix4.identity(),
        child: Container(
          width: 400,
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03), // Increased white for glassy effect
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.25), // Slightly brighter border
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
              if (_isHovered && widget.enable3DEffect)
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 18,
                  offset: Offset(_rotateY * 0.3, 6 + (_rotateX * 0.2)),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: _isHovered && widget.enable3DEffect
                      ? Colors.white.withOpacity(0.04) // Slightly brighter on hover
                      : Colors.white.withOpacity(0.02), // Increased white
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(32),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}