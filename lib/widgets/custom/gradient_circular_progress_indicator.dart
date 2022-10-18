import 'package:flutter/material.dart';
import 'package:zpass/widgets/custom/gradient_circular.dart';

class GradientCircularProgressIndicator extends StatefulWidget {
  const GradientCircularProgressIndicator(
      {Key? key,
      this.radius = 20,
      this.strokeWidth = 3.0,
      this.gradientColors = const [Colors.white10, Colors.white]})
      : super(key: key);

  final double radius;
  final double strokeWidth;
  final List<Color> gradientColors;

  @override
  _GradientCircularProgressIndicatorState createState() => _GradientCircularProgressIndicatorState();
}

class _GradientCircularProgressIndicatorState extends State<GradientCircularProgressIndicator> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(() => setState(() {}))
          ..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
      child: GradientCircular(
        radius: widget.radius,
        gradientColors: widget.gradientColors,
        strokeWidth: widget.strokeWidth,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
