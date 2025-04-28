import 'package:flutter/material.dart';
import 'dart:math' as math;

class FloorMapPainter2 extends CustomPainter {
  final List<String> shortestPath;
  
  FloorMapPainter2({required this.shortestPath});

  void _drawArrow(Canvas canvas, Offset start, Offset end, Paint paint) {
    // Compute direction vector
    Offset direction = end - start;
    double length = direction.distance;
    Offset end2 = end;
     // Ensure the line doesn't invert
    if (length > 4) {
      Offset unitDirection = direction / length; // Normalize
      end2 = end - (unitDirection * 4); // Reduce length by 4
    }
    // Draw the main line
    canvas.drawLine(start, end2, paint);

    // Calculate the angle of the line
    double angle = math.atan2(end.dy - start.dy, end.dx - start.dx);

    // Arrow properties
    double arrowLength = 20.0;
    double arrowAngle = 25 * math.pi / 180; // 25 degrees in radians

    // Calculate arrow points
    Offset point1 = Offset(
      end.dx - arrowLength * math.cos(angle + arrowAngle),
      end.dy - arrowLength * math.sin(angle + arrowAngle),
    );

    Offset point2 = Offset(
      end.dx - arrowLength * math.cos(angle - arrowAngle),
      end.dy - arrowLength * math.sin(angle - arrowAngle),
    );

    // Draw the arrow head
    final arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(point1.dx, point1.dy)
      ..lineTo(point2.dx, point2.dy)
      ..close();

    canvas.drawPath(arrowPath, paint..style = PaintingStyle.fill);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final double scaleX = size.width / 800;  // Scaling factors for responsiveness
    final double scaleY = size.height / 1200;

    // Draw Main Building Outline
    final Path building = Path()
      ..addRect(Rect.fromLTWH(50 * scaleX, 50 * scaleY, 700 * scaleX, 1100 * scaleY));
    canvas.drawPath(building, paint);

    // Draw Central Void
    final Paint voidPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Rect centralVoid = Rect.fromLTWH(250 * scaleX, 280 * scaleY, 300 * scaleX, 640 * scaleY);
    canvas.drawRect(centralVoid, voidPaint);
    canvas.drawRect(centralVoid, paint);

    // Room Data (Positioning)
    final List<Map<String, dynamic>> rooms = [
      {"number": "201", "x": 495, "y": 100},
      {"number": "202", "x": 615, "y": 250},
      {"number": "203", "x": 615, "y": 450},
      {"number": "204", "x": 615, "y": 650},
      {"number": "205", "x": 615, "y": 850},
      {"number": "206", "x": 495, "y": 1000},
      {"number": "207", "x": 200, "y": 1000},
      {"number": "208", "x": 80, "y": 850},
      {"number": "209", "x": 80, "y": 650},
      {"number": "210", "x": 80, "y": 450},
      {"number": "211", "x": 80, "y": 250},
      {"number": "212", "x": 200, "y": 100},
    ];

    final Map<String, Offset> nodePositions = {
      "201": Offset(545 * scaleX, 230 * scaleY),
      "202": Offset(590 * scaleX, 300 * scaleY),
      "203": Offset(590 * scaleX, 500 * scaleY),
      "204": Offset(590 * scaleX, 700 * scaleY),
      "205": Offset(590 * scaleX, 900 * scaleY),
      "206": Offset(545 * scaleX, 970 * scaleY),
      "207": Offset(250 * scaleX, 970 * scaleY),
      "208": Offset(205 * scaleX, 900 * scaleY),
      "209": Offset(205 * scaleX, 700 * scaleY),
      "210": Offset(205 * scaleX, 500 * scaleY),
      "211": Offset(205 * scaleX, 300 * scaleY),
      "212": Offset(250 * scaleX, 230 * scaleY),
      "S2a": Offset(400 * scaleX, 230 * scaleY),
      "S2b": Offset(400 * scaleX, 970 * scaleY),
    };

    final Paint nodePaint = Paint()
      ..color = Colors.transparent;

    final Paint pathPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;
    
    final Paint roomPaint = Paint()
      ..color = Color.fromARGB(255, 123, 252, 191)
      ..style = PaintingStyle.fill;

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 20 * scaleX,
    );

    for (var room in rooms) {
      double x = room["x"] * scaleX;
      double y = room["y"] * scaleY;
      Rect roomRect = Rect.fromLTWH(x, y, 100 * scaleX, 100 * scaleY);

      // Draw room
      canvas.drawRect(roomRect, roomPaint);
      canvas.drawRect(roomRect, paint);

      // Draw text
      textPainter.text = TextSpan(text: room["number"], style: textStyle);
      textPainter.layout();
      textPainter.paint(canvas, Offset(x + 50 * scaleX - textPainter.width / 2, y + 50 * scaleY - textPainter.height / 2));
    }

    // 🏃 Draw Stairs
    final Paint stairPaint = Paint()..color = Colors.grey;
    for (int i = 0; i < 5; i++) {
      double stairWidth = (50 - i * 10) * scaleX;
      canvas.drawRect(Rect.fromLTWH(380 * scaleX, (150 - i * 10) * scaleY, stairWidth, 10 * scaleY), stairPaint);
      canvas.drawRect(Rect.fromLTWH(380 * scaleX, (1090 - i * 10) * scaleY, stairWidth, 10 * scaleY), stairPaint);
    }

    // Draw nodes
    nodePositions.forEach((name, position) {
      canvas.drawCircle(position, 5, nodePaint);
    });

    // Draw path with arrow only on the last segment
    for (int i = 0; i < shortestPath.length - 1; i++) {
      final Offset start = nodePositions[shortestPath[i]]!;
      final Offset end = nodePositions[shortestPath[i + 1]]!;
      
      if (i == shortestPath.length - 2) {
        // This is the last segment, draw with arrow
        _drawArrow(canvas, start, end, pathPaint);
      } else {
        // For all other segments, just draw the line
        canvas.drawLine(start, end, pathPaint);
      }
    }
  }

  @override
  bool shouldRepaint(FloorMapPainter2 oldDelegate) => false;
}
