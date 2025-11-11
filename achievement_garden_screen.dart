import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(FocusPlantApp());

class FocusPlantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusFlow Plant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFDF6F0), // cream background
        primaryColor: const Color(0xFFE75480), // Rani Pink
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
      home: FocusPlantPage(),
    );
  }
}

class FocusPlantPage extends StatefulWidget {
  @override
  _FocusPlantPageState createState() => _FocusPlantPageState();
}

class _FocusPlantPageState extends State<FocusPlantPage>
    with SingleTickerProviderStateMixin {
  int growthLevel = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _waterPlant() {
    setState(() {
      growthLevel = min(growthLevel + 1, 10); // max 10 levels
    });
    _controller.forward(from: 0);
  }

  void _resetPlant() {
    setState(() => growthLevel = 0);
  }

  @override
  Widget build(BuildContext context) {
    double plantHeight = 100 + growthLevel * 15;
    Color leafColor =
        Color.lerp(Colors.green[300], Colors.green[800], growthLevel / 10)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE75480),
        title: const Text("Focus Plant 🌱", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetPlant,
            tooltip: "Reset Growth",
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDF6F0), Color(0xFFFFE4E1)], // cream → light pastel pink
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: CustomPaint(
                  size: Size(120, plantHeight),
                  painter: PlantPainter(leafColor),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Growth Level: $growthLevel / 10",
                style: const TextStyle(
                  color: Color(0xFFE75480),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE75480),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.water_drop, color: Colors.white),
                label: const Text("Water Plant", style: TextStyle(color: Colors.white)),
                onPressed: _waterPlant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlantPainter extends CustomPainter {
  final Color leafColor;

  PlantPainter(this.leafColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    double stemHeight = size.height * 0.8;
    double stemWidth = 6.0;

    // Draw stem
    paint.color = Colors.brown[600]!;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height - stemHeight / 2),
        width: stemWidth,
        height: stemHeight,
      ),
      paint,
    );

    // Draw leaves (growing number of leaves)
    paint.color = leafColor;
    for (int i = 0; i < 5; i++) {
      double y = size.height - (i + 1) * stemHeight / 6;
      double leafWidth = 30 + i * 3;
      Path leaf = Path()
        ..moveTo(size.width / 2, y)
        ..quadraticBezierTo(size.width / 2 - leafWidth, y - 10, size.width / 2, y - 20)
        ..quadraticBezierTo(size.width / 2 + leafWidth, y - 10, size.width / 2, y)
        ..close();
      canvas.drawPath(leaf, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
