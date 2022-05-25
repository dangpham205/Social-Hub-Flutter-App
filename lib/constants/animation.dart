import 'package:flutter/material.dart';

class Animations {
  static fromLeft(Animation<double> _animation, Animation<double> _secondaryAnimation, Widget _child) {
    return SlideTransition(
      child: _child,
      position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(_animation),
    );
  }
}