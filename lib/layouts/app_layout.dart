import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  static const Color topBottomBarColor = Color.fromARGB(255, 0, 101, 184);
  static const Color activeItemColor = Colors.white;
  static const Color inactiveItemColor = Color.fromARGB(255, 0, 208, 255);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: topBottomBarColor,
        title: Center(child: Text("Offline Indoor Navigator", style: TextStyle(color: activeItemColor))),
      ),
      body: child, // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getCurrentIndex(context),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go("/");
            case 1:
              context.go("/floor-map");
          }
        },
        backgroundColor: topBottomBarColor,
        selectedItemColor: activeItemColor, // Change color when the item is selected
        unselectedItemColor: inactiveItemColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Floor Map"),
          // BottomNavigationBarItem(icon: Icon(Icons.camera), label: "Camera"),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).fullPath.toString();
    if (location.startsWith("/floor-map")) return 1;
    return 0; // Default: Home
  }
}
