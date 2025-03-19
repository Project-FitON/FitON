import 'package:flutter/material.dart';

class HumanSketchPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  
  HumanSketchPainter({
    this.color = Colors.black,
    this.strokeWidth = 2.0,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    
    // Head
    final headRadius = size.width * 0.15;
    final headCenter = Offset(size.width / 2, size.height * 0.15);
    canvas.drawCircle(headCenter, headRadius, paint);
    
    // Neck
    final neckTop = Offset(size.width / 2, headCenter.dy + headRadius);
    final neckBottom = Offset(size.width / 2, size.height * 0.25);
    canvas.drawLine(neckTop, neckBottom, paint);
    
    // Shoulders
    final shoulderLeft = Offset(size.width * 0.3, size.height * 0.28);
    final shoulderRight = Offset(size.width * 0.7, size.height * 0.28);
    canvas.drawLine(neckBottom, shoulderLeft, paint);
    canvas.drawLine(neckBottom, shoulderRight, paint);
    
    // Body
    final bodyBottom = Offset(size.width / 2, size.height * 0.55);
    canvas.drawLine(neckBottom, bodyBottom, paint);
    
    // Arms
    final elbowLeft = Offset(size.width * 0.2, size.height * 0.4);
    final elbowRight = Offset(size.width * 0.8, size.height * 0.4);
    canvas.drawLine(shoulderLeft, elbowLeft, paint);
    canvas.drawLine(shoulderRight, elbowRight, paint);
    
    final handLeft = Offset(size.width * 0.15, size.height * 0.5);
    final handRight = Offset(size.width * 0.85, size.height * 0.5);
    canvas.drawLine(elbowLeft, handLeft, paint);
    canvas.drawLine(elbowRight, handRight, paint);
    
    // Hips
    final hipLeft = Offset(size.width * 0.4, size.height * 0.6);
    final hipRight = Offset(size.width * 0.6, size.height * 0.6);
    canvas.drawLine(bodyBottom, hipLeft, paint);
    canvas.drawLine(bodyBottom, hipRight, paint);
    
    // Legs
    final kneeLeft = Offset(size.width * 0.35, size.height * 0.75);
    final kneeRight = Offset(size.width * 0.65, size.height * 0.75);
    canvas.drawLine(hipLeft, kneeLeft, paint);
    canvas.drawLine(hipRight, kneeRight, paint);
    
    final footLeft = Offset(size.width * 0.3, size.height * 0.95);
    final footRight = Offset(size.width * 0.7, size.height * 0.95);
    canvas.drawLine(kneeLeft, footLeft, paint);
    canvas.drawLine(kneeRight, footRight, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class HumanSketchWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final Color color;
  final double strokeWidth;
  
  const HumanSketchWidget({
    Key? key,
    this.width,
    this.height,
    this.color = Colors.black,
    this.strokeWidth = 2.0,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width ?? 200, height ?? 400),
      painter: HumanSketchPainter(
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
} 