import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Office Floor Plan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FloorPlanScreen(),
    );
  }
}

class FloorPlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Office Floor Plan'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Make the container fit the screen width
              Container(
                width: MediaQuery.of(context).size.width,
                // Set aspect ratio to maintain proportions
                height: MediaQuery.of(context).size.width * 0.75,
                color: Color(0xFFF0F8FF),
                child: FittedBox(
                  // This ensures the content scales to fit
                  fit: BoxFit.contain,
                  child: Container(
                    width: 800,
                    height: 600,
                    child: CustomPaint(
                      painter: OfficeFloorPlanPainter(),
                    ),
                  ),
                ),
              ),
              // Add zoom controls
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Pinch to zoom or use the controls below",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Implement zoom out functionality here
                    },
                    child: Icon(Icons.zoom_out),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Implement zoom in functionality here
                    },
                    child: Icon(Icons.zoom_in),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OfficeFloorPlanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Scale everything to fit inside the available canvas
    final scaleX = size.width / 800;
    final scaleY = size.height / 600;
    
    // Apply scaling to the canvas
    canvas.scale(scaleX, scaleY);
    
    final paint = Paint()
      ..color = Color(0xFF6495ED)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final lightBlueFill = Paint()
      ..color = Color(0xFFE6F0FF)
      ..style = PaintingStyle.fill;
    
    final stairsPaint = Paint()
      ..color = Color(0xFF36454F)
      ..style = PaintingStyle.fill;
    
    final elevatorPaint = Paint()
      ..color = Color(0xFF36454F)
      ..style = PaintingStyle.fill;
    
    final textStyle = TextStyle(
      color: Colors.black87,
      fontSize: 16,
    );
    
    final titleStyle = TextStyle(
      color: Colors.black87,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    // Left Wing
    drawLeftWing(canvas, paint, lightBlueFill, stairsPaint, textPainter, textStyle, titleStyle);
    
    // Right Wing
    drawRightWing(canvas, paint, lightBlueFill, stairsPaint, textPainter, textStyle, titleStyle);
    
    // Middle Section
    drawMiddleSection(canvas, paint, lightBlueFill, stairsPaint, textPainter, textStyle);
    
    // Elevators
    drawElevators(canvas, elevatorPaint, textPainter);
  }
  
  void drawLeftWing(Canvas canvas, Paint paint, Paint fillPaint, Paint stairsPaint, 
                   TextPainter textPainter, TextStyle textStyle, TextStyle titleStyle) {
    // Left Wing Outer Wall
    final leftWing = Rect.fromLTWH(50, 100, 300, 400);
    canvas.drawRect(leftWing, fillPaint);
    canvas.drawRect(leftWing, paint);
    
    // Ladies WC
    final ladiesWC = Rect.fromLTWH(50, 100, 200, 80);
    canvas.drawRect(ladiesWC, paint);
    textPainter.text = TextSpan(text: 'Ladies WC', style: titleStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(120, 130));
    
    // Room 405
    final room405 = Rect.fromLTWH(50, 180, 200, 60);
    canvas.drawRect(room405, paint);
    textPainter.text = TextSpan(text: '405', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(120, 210));
    
    // Room 404A
    final room404A = Rect.fromLTWH(50, 240, 200, 50);
    canvas.drawRect(room404A, paint);
    textPainter.text = TextSpan(text: '404A', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(120, 265));
    
    // Room 404B
    final room404B = Rect.fromLTWH(50, 290, 200, 50);
    canvas.drawRect(room404B, paint);
    textPainter.text = TextSpan(text: '404B', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(120, 315));
    
    // Room 403A
    final room403A = Rect.fromLTWH(50, 340, 200, 50);
    canvas.drawRect(room403A, paint);
    textPainter.text = TextSpan(text: '403A', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(120, 365));
    
    // Room 403B
    final room403B = Rect.fromLTWH(50, 390, 200, 50);
    canvas.drawRect(room403B, paint);
    textPainter.text = TextSpan(text: '403B', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(120, 415));
    
    // Room 402
    final room402 = Rect.fromLTWH(50, 440, 200, 100);
    canvas.drawRect(room402, paint);
    textPainter.text = TextSpan(text: '402', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(120, 490));
    
    // Room 401A & 401B
    canvas.drawLine(Offset(140, 540), Offset(140, 500), paint);
    canvas.drawLine(Offset(50, 540), Offset(350, 540), paint);
    
    textPainter.text = TextSpan(text: '401B', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(80, 520));
    
    textPainter.text = TextSpan(text: '401A', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(220, 520));
    
    // Stairs near Ladies WC
    final ladiesStairs = Rect.fromLTWH(300, 120, 40, 40);
    canvas.drawRect(ladiesStairs, stairsPaint);
    
    // Draw diagonal lines for stairs
    canvas.drawLine(Offset(305, 120), Offset(335, 155), Paint()
      ..color = Colors.white
      ..strokeWidth = 2);
  }
  
  void drawRightWing(Canvas canvas, Paint paint, Paint fillPaint, Paint stairsPaint, 
                    TextPainter textPainter, TextStyle textStyle, TextStyle titleStyle) {
    // Right Wing Outer Wall
    final rightWing = Rect.fromLTWH(450, 100, 300, 400);
    canvas.drawRect(rightWing, fillPaint);
    canvas.drawRect(rightWing, paint);
    
    // Gents WC
    final gentsWC = Rect.fromLTWH(550, 100, 200, 80);
    canvas.drawRect(gentsWC, paint);
    textPainter.text = TextSpan(text: 'Gents WC', style: titleStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(620, 130));
    
    // Room 413
    final room413 = Rect.fromLTWH(550, 180, 200, 60);
    canvas.drawRect(room413, paint);
    textPainter.text = TextSpan(text: '413', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(620, 210));
    
    // Room 412
    final room412 = Rect.fromLTWH(550, 240, 200, 100);
    canvas.drawRect(room412, paint);
    textPainter.text = TextSpan(text: '412', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(620, 290));
    
    // Room 411
    final room411 = Rect.fromLTWH(550, 340, 200, 90);
    canvas.drawRect(room411, paint);
    textPainter.text = TextSpan(text: '411', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(620, 380));
    
    // Room 410
    final room410 = Rect.fromLTWH(550, 430, 200, 110);
    canvas.drawRect(room410, paint);
    textPainter.text = TextSpan(text: '410', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(620, 480));
    
    // Room 409A & 409B
    canvas.drawLine(Offset(660, 540), Offset(660, 500), paint);
    textPainter.text = TextSpan(text: '409A', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(580, 520));
    
    textPainter.text = TextSpan(text: '409B', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(700, 520));
    
    // Stairs near Gents WC
    final gentsStairs = Rect.fromLTWH(510, 120, 40, 40);
    canvas.drawRect(gentsStairs, stairsPaint);
    
    // Draw diagonal lines for stairs
    canvas.drawLine(Offset(515, 120), Offset(545, 155), Paint()
      ..color = Colors.white
      ..strokeWidth = 2);
  }
  
  void drawMiddleSection(Canvas canvas, Paint paint, Paint fillPaint, Paint stairsPaint, 
                        TextPainter textPainter, TextStyle textStyle) {
    // Middle section
    final middleTop = Path();
    middleTop.moveTo(350, 380);
    middleTop.lineTo(450, 380);
    middleTop.lineTo(450, 300);
    middleTop.lineTo(350, 300);
    middleTop.close();
    
    canvas.drawPath(middleTop, fillPaint);
    canvas.drawPath(middleTop, paint);
    
    // Room 407 & 408
    final middleBottom = Rect.fromLTWH(330, 425, 140, 65);
    canvas.drawRect(middleBottom, fillPaint);
    canvas.drawRect(middleBottom, paint);
    
    // Divider between 407 & 408
    canvas.drawLine(Offset(400, 425), Offset(400, 490), paint);
    
    textPainter.text = TextSpan(text: '407', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(350, 450));
    
    textPainter.text = TextSpan(text: '408', style: textStyle);
    textPainter.layout();
    textPainter.paint(canvas, Offset(420, 450));
    
    // Stairs in middle
    final middleStairs = Rect.fromLTWH(380, 395, 40, 30);
    canvas.drawRect(middleStairs, stairsPaint);
    
    // Draw diagonal lines for stairs
    canvas.drawLine(Offset(385, 395), Offset(415, 425), Paint()
      ..color = Colors.white
      ..strokeWidth = 2);
  }
  
  void drawElevators(Canvas canvas, Paint elevatorPaint, TextPainter textPainter) {
    // Elevator 1
    final elevator1 = Rect.fromLTWH(466, 217, 28, 28);
    canvas.drawRect(elevator1, elevatorPaint);
    
    // Elevator 2
    final elevator2 = Rect.fromLTWH(466, 380, 28, 28);
    canvas.drawRect(elevator2, elevatorPaint);
    
    // Elevator symbol
    textPainter.text = TextSpan(
      text: 'E',
      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(474, 222));
    textPainter.paint(canvas, Offset(474, 385));
  }

  @override
  bool shouldRepaint(OfficeFloorPlanPainter oldDelegate) => false;
}