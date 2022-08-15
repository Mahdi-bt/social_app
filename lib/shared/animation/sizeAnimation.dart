import 'package:flutter/material.dart';

class SizeAnimationToRight extends PageRouteBuilder {
  final Widget page;
  SizeAnimationToRight({required this.page})
      : super(
            pageBuilder: (context, animation, anotherAnimation) => page,
            transitionDuration: const Duration(milliseconds: 1000),
            reverseTransitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastLinearToSlowEaseIn,
                  reverseCurve: Curves.fastOutSlowIn);
              return Align(
                alignment: Alignment.centerLeft,
                child: SizeTransition(
                    axis: Axis.horizontal,
                    sizeFactor: animation,
                    axisAlignment: 0,
                    child: page),
              );
            });
}

class SizeAnimationToLeft extends PageRouteBuilder {
  final Widget page;
  SizeAnimationToLeft({required this.page})
      : super(
            pageBuilder: (context, animation, anotherAnimation) => page,
            transitionDuration: const Duration(milliseconds: 1000),
            reverseTransitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastLinearToSlowEaseIn,
                  reverseCurve: Curves.fastOutSlowIn);
              return Align(
                alignment: Alignment.centerRight,
                child: SizeTransition(
                    axis: Axis.horizontal,
                    sizeFactor: animation,
                    axisAlignment: 0,
                    child: page),
              );
            });
}
