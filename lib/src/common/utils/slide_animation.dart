import 'dart:async';

import 'package:flutter/material.dart';

/// Creates a animation widget that slides from right to left.
class SlideAnimation extends StatefulWidget {
  /// Initializes child, key
  const SlideAnimation({required this.child, super.key});

  /// Creates a animation widget that slides from right to left.
  final Widget child;

  @override
  SlideAnimationState createState() => SlideAnimationState();
}

/// Widget that animates the right slide of filter
class SlideAnimationState extends State<SlideAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    final curve = CurvedAnimation(
      curve: Curves.decelerate,
      parent: _controller,
    );
    _animOffset = Tween<Offset>(
      begin: const Offset(0.35, 0),
      end: Offset.zero,
    ).animate(curve);

    Timer(Duration.zero, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      key: widget.key,
      opacity: _controller,
      child: SlideTransition(position: _animOffset, child: widget.child),
    );
  }
}
