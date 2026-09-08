import 'package:flutter/material.dart';

class FadeIndexedStack extends StatefulWidget {
  const FadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 280),
    this.curve = Curves.easeInOut,
  });

  final int index;
  final List<Widget> children;
  final Duration duration;
  final Curve curve;

  @override
  State<FadeIndexedStack> createState() => FadeIndexedStackState();
}

class FadeIndexedStackState extends State<FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
    value: 1,
  );

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: widget.curve,
  );

  @override
  void didUpdateWidget(covariant FadeIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: IndexedStack(index: widget.index, children: widget.children),
    );
  }
}