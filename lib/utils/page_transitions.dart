


// import 'package:flutter/material.dart';
// import 'dart:ui';

// class BlurRoute<T> extends PageRouteBuilder<T> {
//   final Widget page;
  
//   BlurRoute({required this.page})
//       : super(
//           pageBuilder: (context, animation, secondaryAnimation) => page,
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             // Smooth slide transition without blur for better performance
//             const begin = Offset(1.0, 0.0);
//             const end = Offset.zero;
            
//             final slideAnimation = Tween(begin: begin, end: end).animate(
//               CurvedAnimation(
//                 parent: animation, 
//                 curve: Curves.easeOutCubic,
//               ),
//             );
            
//             final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//               CurvedAnimation(
//                 parent: animation, 
//                 curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
//               ),
//             );
            
//             final scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
//               CurvedAnimation(
//                 parent: animation, 
//                 curve: Curves.easeOutBack,
//               ),
//             );
            
//             return FadeTransition(
//               opacity: fadeAnimation,
//               child: ScaleTransition(
//                 scale: scaleAnimation,
//                 child: SlideTransition(
//                   position: slideAnimation,
//                   child: child,
//                 ),
//               ),
//             );
//           },
//           transitionDuration: const Duration(milliseconds: 400),
//           reverseTransitionDuration: const Duration(milliseconds: 350),
//           // Important: Set proper route settings to avoid red screen
//           settings: RouteSettings(name: page.runtimeType.toString()),
//         );
// }

//2


import 'package:flutter/material.dart';
import 'dart:ui';

class BlurRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  BlurRoute({required this.page}) : super(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (_, animation, __, child) {
      final curve = CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
      
      return AnimatedBuilder(
        animation: curve,
        builder: (_, __) {
          final progress = curve.value;
          final blur = (1 - progress) * 12;
          
          return Stack(
            children: [
              if (blur > 0.5)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: ColoredBox(color: Colors.black.withOpacity(0.3 * (1 - progress))),
                ),
              Transform.scale(
                scale: 0.9 + (0.1 * progress),
                child: Opacity(opacity: progress, child: child),
              ),
            ],
          );
        },
      );
    },
  );
}

// Usage: Navigator.push(context, BlurRoute(page: NewPage()));