import 'package:flutter/material.dart';

class NoTransitionPageRoute extends PageRouteBuilder {
  final Widget page;
  @override
  final RouteSettings settings;

  NoTransitionPageRoute({required this.page, super.settings})
      : settings = settings ?? const RouteSettings(),
        super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(seconds: 0),
          reverseTransitionDuration: const Duration(seconds: 0),
        );
}

class SlideUpTransitionPageRoute extends PageRouteBuilder {
  final Widget page;
  @override
  final RouteSettings settings;

  SlideUpTransitionPageRoute({required this.page, super.settings})
      : settings = settings ?? const RouteSettings(),
        super(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            });
}
