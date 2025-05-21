// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/constants.dart';

class CustomLoader extends StatefulWidget {
  final double size;
  final Color color;
  final String text;
  final TextStyle? textStyle;

  const CustomLoader({
    super.key,
    this.size = 60.0,
    this.color = AppColors.primary,
    this.text = 'Loading properties...',
    this.textStyle,
  });

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Outer circle
                Transform.rotate(
                  angle: _controller.value * 2 * math.pi,
                  child: CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _CirclePainter(
                      color: widget.color.withAlpha(100),
                      strokeWidth: 3.0,
                    ),
                  ),
                ),
                // Inner circle
                Transform.rotate(
                  angle: _controller.value * 2 * math.pi * -1,
                  child: CustomPaint(
                    size: Size(widget.size * 0.7, widget.size * 0.7),
                    painter: _CirclePainter(
                      color: widget.color,
                      strokeWidth: 4.0,
                      dashPattern: const [2, 4],
                    ),
                  ),
                ),
                // House icon
                Icon(
                  Icons.home_rounded,
                  color: widget.color,
                  size: widget.size * 0.4,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          widget.text,
          style: widget.textStyle ??
              TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

class _CirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final List<double>? dashPattern;

  _CirclePainter({
    required this.color,
    required this.strokeWidth,
    this.dashPattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - strokeWidth / 2;

    if (dashPattern != null) {
      // Draw dashed circle
      final path = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
      
      final dashPath = Path();
      final dashLength = dashPattern![0];
      final dashSpace = dashPattern![1];
      final totalLength = dashLength + dashSpace;
      
      final circumference = 2 * math.pi * radius;
      final dashCount = (circumference / totalLength).floor();
      
      for (int i = 0; i < dashCount; i++) {
        final startAngle = i * totalLength / radius;
        final endAngle = startAngle + dashLength / radius;
        
        dashPath.addArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          endAngle - startAngle,
        );
      }
      
      canvas.drawPath(dashPath, paint);
    } else {
      // Draw solid circle
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
