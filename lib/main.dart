import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'layouts/app_layout.dart';
import 'pages/home_page.dart';
import 'pages/floor_map_page.dart';
import 'test/floor_map_controller.dart';
import 'functions/algorithms/multi_floor_dijkstras_algo.dart';
import 'maps/floor_painter_1.dart';
import 'maps/floor_painter_2.dart';
import 'maps/floor_painter_3.dart';

void main() {
  _initializeGraphAndPainters();
  runApp(MyApp());
}

void _initializeGraphAndPainters() {
  final FloorMapController controller = FloorMapController();
  final MultiFloorGraph graph = MultiFloorGraph();
  // Initialize floor painters
  controller.addFloorPainter(1, FloorMapPainter1(shortestPath: []));
  controller.addFloorPainter(2, FloorMapPainter2(shortestPath: []));
  controller.addFloorPainter(3, FloorMapPainter3(shortestPath: []));

  // Add edges for floor 1
  graph.addEdge(1, "101", "102", 1);
  graph.addEdge(1, "102", "103", 3);
  graph.addEdge(1, "103", "104", 3);
  graph.addEdge(1, "104", "105", 3);
  graph.addEdge(1, "105", "106", 1);
  graph.addEdge(1, "106", "S1b", 2);
  graph.addEdge(1, "S1b", "107", 2);
  graph.addEdge(1, "107", "108", 1);
  graph.addEdge(1, "108", "109", 3);
  graph.addEdge(1, "109", "110", 3);
  graph.addEdge(1, "110", "111", 3);
  graph.addEdge(1, "111", "112", 1);
  graph.addEdge(1, "112", "S1a", 2);
  graph.addEdge(1, "S1a", "101", 2);

  // Add edges for floor 2
  graph.addEdge(2, "201", "202", 1);
  graph.addEdge(2, "202", "203", 3);
  graph.addEdge(2, "203", "204", 3);
  graph.addEdge(2, "204", "205", 3);
  graph.addEdge(2, "205", "206", 1);
  graph.addEdge(2, "206", "S2b", 2);
  graph.addEdge(2, "S2b", "207", 2);
  graph.addEdge(2, "207", "208", 1);
  graph.addEdge(2, "208", "209", 3);
  graph.addEdge(2, "209", "210", 3);
  graph.addEdge(2, "210", "211", 3);
  graph.addEdge(2, "211", "212", 1);
  graph.addEdge(2, "212", "S2a", 2);
  graph.addEdge(2, "S2a", "201", 2);

  // Add edges for floor 3
  graph.addEdge(3, "301", "302", 1);
  graph.addEdge(3, "302", "303", 3);
  graph.addEdge(3, "303", "304", 3);
  graph.addEdge(3, "304", "305", 3);
  graph.addEdge(3, "305", "306", 1);
  graph.addEdge(3, "306", "S3b", 2);
  graph.addEdge(3, "S3b", "307", 2);
  graph.addEdge(3, "307", "308", 1);
  graph.addEdge(3, "308", "309", 3);
  graph.addEdge(3, "309", "310", 3);
  graph.addEdge(3, "310", "311", 3);
  graph.addEdge(3, "311", "312", 1);
  graph.addEdge(3, "312", "S3a", 2);
  graph.addEdge(3, "S3a", "301", 2);
  // Add more floor 3 connections...

  // Add vertical connections (stairs/elevators)
  graph.addVerticalConnection("S1a", "S2a", 5); // Floor 1 Staircase1 to Floor 2 Staircase1
  graph.addVerticalConnection("S1b", "S2b", 5); // Floor 1 Staircase2 to Floor 2 Staircase2
  graph.addVerticalConnection("S2a", "S3a", 5); // Floor 2 Staircase1 to Floor 3 Staircase1
  graph.addVerticalConnection("S2b", "S3b", 5); // Floor 2 Staircase2 to Floor 3 Staircase2
}


class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    initialLocation: "/",
    routes: [
      ShellRoute(
      builder: (context, state, child) => AppLayout(child: child),
      routes: [
        GoRoute(path: "/", builder: (context, state) => HomePage()),
        GoRoute(path: "/floor-map", builder: (context, state) => FloorMapPage()),
      ],
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.light(),
      routerConfig: _router,
    );
  }
}
