// import 'package:flutter/material.dart';
// import 'dart:ui';

// class BlurRoute<T> extends PageRouteBuilder<T> {
//   final Widget page;
  
//   BlurRoute({required this.page})
//       : super(
//           pageBuilder: (context, animation, secondaryAnimation) => page,
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             // Blur transition with slide
//             const begin = Offset(1.0, 0.0);
//             const end = Offset.zero;
            
//             var slideAnimation = Tween(begin: begin, end: end).animate(
//               CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
//             );
            
//             var blurAnimation = Tween<double>(begin: 10.0, end: 0.0).animate(
//               CurvedAnimation(parent: animation, curve: Curves.easeOut),
//             );
            
//             var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//               CurvedAnimation(parent: animation, curve: Curves.easeIn),
//             );
            
//             return AnimatedBuilder(
//               animation: animation,
//               builder: (context, child) {
//                 return BackdropFilter(
//                   filter: ImageFilter.blur(
//                     sigmaX: blurAnimation.value,
//                     sigmaY: blurAnimation.value,
//                   ),
//                   child: FadeTransition(
//                     opacity: fadeAnimation,
//                     child: SlideTransition(
//                       position: slideAnimation,
//                       child: child,
//                     ),
//                   ),
//                 );
//               },
//               child: child,
//             );
//           },
//           transitionDuration: const Duration(milliseconds: 500),
//           reverseTransitionDuration: const Duration(milliseconds: 400),
//         );
// }



//2



import 'package:flutter/material.dart';
import 'dart:ui';

class BlurRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  
  BlurRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Smooth slide transition without blur for better performance
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            
            final slideAnimation = Tween(begin: begin, end: end).animate(
              CurvedAnimation(
                parent: animation, 
                curve: Curves.easeOutCubic,
              ),
            );
            
            final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation, 
                curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
              ),
            );
            
            final scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: animation, 
                curve: Curves.easeOutBack,
              ),
            );
            
            return FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: child,
                ),
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          // Important: Set proper route settings to avoid red screen
          settings: RouteSettings(name: page.runtimeType.toString()),
        );
}