import 'package:flutter/material.dart';
import '../functions/algorithms/multi_floor_dijkstras_algo.dart';
import 'floor_map_controller.dart';
import 'floor_painter_1.dart';
import 'floor_painter_2.dart';
import 'floor_painter_3.dart';
import '../pages/camera_init.dart';

class NavigationDemo extends StatefulWidget {

  final String? startRoom;
  final String? endRoom;

  NavigationDemo({this.startRoom, this.endRoom});

  @override
  // ignore: library_private_types_in_public_api
  _NavigationDemoState createState() => _NavigationDemoState();
}

class _NavigationDemoState extends State<NavigationDemo> {
  CameraService cameraService = CameraService();
  final FloorMapController _controller = FloorMapController();
  final MultiFloorGraph _graph = MultiFloorGraph();
  final List<String> codeNames = [
    "1A", "1B", "1C", "1D", "1E", "1F", "1G", "1H", "1I", "1J", "1K", "1L", 
    "2A", "2B", "2C", "2D", "2E", "2F", "2G", "2H", "2I", "2J", "2K", "2L", 
    "3A", "3B", "3C", "3D", "3E", "3F", "3G", "3H", "3I", "3J", "3K", "3L"
  ];
  final Map<String, String> codetoRoomMapper = {
    "1A": "101", "1B": "102", "1C": "103", "1D": "104", "1E": "105", "1F": "106", "1G": "107", "1H": "108", "1I": "109", "1J": "110", "1K": "111", "1L": "112",
    "2A": "201", "2B": "202", "2C": "203", "2D": "204", "2E": "205", "2F": "206", "2G": "207", "2H": "208", "2I": "209", "2J": "210", "2K": "211", "2L": "212",
    "3A": "301", "3B": "302", "3C": "303", "3D": "304", "3E": "305", "3F": "306", "3G": "307", "3H": "308", "3I": "309", "3J": "310", "3K": "311", "3L": "312"
  };

  int currentFloor = 1;

  @override
  void initState() {
    super.initState();
    _navigate();
    initializeCamera();
  }

  void initializeCamera() async {
    await cameraService.initialize();
    cameraService.textStream.listen((text) {
      for (var code in codeNames) {
        if (text.contains(code)) {
          final room = codetoRoomMapper[code];
          _navigate(start: room);
        }
      }
      print('Text: $text');
    });
  }

  void _navigate({String? start}) {
    start ??= widget.startRoom;
    if (start != null && widget.endRoom != null) {
      final path = _graph.findPath(start, widget.endRoom!);
      print('Path: $path');
      if (path.isNotEmpty) {
        setState(() {
          // Update the current floor to the starting floor
          if(path[0][0] == 'S') {
            currentFloor = int.parse(path[0][1]);
          } else {
            currentFloor = int.parse(path[0][0]);
          }
          
          // Update painters with new paths
          _controller.addFloorPainter(1, FloorMapPainter1(shortestPath: _getFloorPath(path, 1)));
          _controller.addFloorPainter(2, FloorMapPainter2(shortestPath: _getFloorPath(path, 2)));
          _controller.addFloorPainter(3, FloorMapPainter3(shortestPath: _getFloorPath(path, 3)));
          
          print('navigated to Floor: $currentFloor');
          _controller.navigateToFloor(currentFloor);
        });
      }
    }
    print('Start: $start, End: ${widget.endRoom}');
  }

  List<String> _getFloorPath(List<String> fullPath, int floor) {
    return fullPath.where((node) {
      if (node[0] == 'S') {
        return int.parse(node[1]) == floor;
      } else {
        return int.parse(node[0]) == floor;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Multi-Floor Navigation')),
      body: Column(
        children: [
          // Floor selection buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int floor = 1; floor <= 3; floor++)
                Padding(
                  padding: EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () => setState(() {
                      currentFloor = floor;
                      _controller.navigateToFloor(floor);
                    }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentFloor == floor ? Colors.blue : Colors.grey,
                    ),
                    child: Text('Floor $floor'),
                  ),
                ),
            ],
          ),
          
          // Floor map display
          Expanded(
            child: CustomPaint(
              painter: _controller.getCurrentPainter(),
              size: Size(800, 1200),
            ),
          ),
        ],
      ),
    );
  }
}