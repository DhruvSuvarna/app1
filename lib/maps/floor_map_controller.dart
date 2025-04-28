import 'package:flutter/material.dart';

class FloorMapController extends ChangeNotifier {
  // Store painters for each floor
  final Map<int, CustomPainter> _floorPainters = {};
  
  // Current floor being displayed
  int _currentFloor = 1;
  
  // Current navigation path
  List<String> _currentPath = [];
  
  // Getters
  int get currentFloor => _currentFloor;
  List<String> get currentPath => _currentPath;
  
  // Add or update a floor painter
  void addFloorPainter(int floor, CustomPainter painter) {
    _floorPainters[floor] = painter;
    notifyListeners();
  }

  // Navigate to a specific floor
  void navigateToFloor(int floor) {
    if (_floorPainters.containsKey(floor)) {
      _currentFloor = floor;
      notifyListeners();
    }
  }

  // Get the painter for the current floor
  CustomPainter? getCurrentPainter() {
    return _floorPainters[_currentFloor];
  }

  // Get a specific floor's painter
  CustomPainter? getPainter(int floor) {
    return _floorPainters[floor];
  }

  // Update navigation path and adjust floor painters
  void updatePath(List<String> path) {
    _currentPath = path;
    
    // If path exists, move to the floor of the first node
    if (path.isNotEmpty) {
      // Extract floor number from first room in path (e.g., "101" -> 1)
      int startFloor = int.parse(path[0][0]);
      navigateToFloor(startFloor);
    }
    
    notifyListeners();
  }

  // Get path segments for a specific floor
  List<String> getFloorPath(int floor) {
    return _currentPath.where((node) => int.parse(node[0]) == floor).toList();
  }

  // Check if a floor has any path segments
  bool hasPathOnFloor(int floor) {
    return getFloorPath(floor).isNotEmpty;
  }

  // Get available floor numbers
  List<int> getAvailableFloors() {
    return _floorPainters.keys.toList()..sort();
  }

  // Move to next floor (if available)
  bool nextFloor() {
    List<int> floors = getAvailableFloors();
    int currentIndex = floors.indexOf(_currentFloor);
    if (currentIndex < floors.length - 1) {
      navigateToFloor(floors[currentIndex + 1]);
      return true;
    }
    return false;
  }

  // Move to previous floor (if available)
  bool previousFloor() {
    List<int> floors = getAvailableFloors();
    int currentIndex = floors.indexOf(_currentFloor);
    if (currentIndex > 0) {
      navigateToFloor(floors[currentIndex - 1]);
      return true;
    }
    return false;
  }

  // Clear all paths but keep painters
  void clearPath() {
    _currentPath = [];
    notifyListeners();
  }

  // Reset everything
  void reset() {
    _floorPainters.clear();
    _currentPath = [];
    _currentFloor = 1;
    notifyListeners();
  }
}

// Example usage with widgets:
// class FloorMapWidget extends StatefulWidget {
//   final FloorMapController controller;
  
//   FloorMapWidget({super.key, required this.controller});
  
//   @override
//   // ignore: library_private_types_in_public_api
//   _FloorMapWidgetState createState() => _FloorMapWidgetState();
// }

// class _FloorMapWidgetState extends State<FloorMapWidget> {
//   @override
//   void initState() {
//     super.initState();
//     widget.controller.addListener(_onControllerUpdate);
//   }

//   @override
//   void dispose() {
//     widget.controller.removeListener(_onControllerUpdate);
//     super.dispose();
//   }

//   void _onControllerUpdate() {
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Floor navigation buttons
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: widget.controller.getAvailableFloors().map((floor) {
//             return Padding(
//               padding: EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 onPressed: () => widget.controller.navigateToFloor(floor),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: widget.controller.currentFloor == floor 
//                     ? Colors.blue 
//                     : Colors.grey,
//                 ),
//                 child: Text('Floor $floor'),
//               ),
//             );
//           }).toList(),
//         ),
        
//         // Floor map display
//         Expanded(
//           child: CustomPaint(
//             painter: widget.controller.getCurrentPainter(),
//             size: Size(800, 1200),
//           ),
//         ),
        
//         // Optional floor navigation arrows
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               icon: Icon(Icons.arrow_upward),
//               onPressed: () => widget.controller.previousFloor(),
//             ),
//             IconButton(
//               icon: Icon(Icons.arrow_downward),
//               onPressed: () => widget.controller.nextFloor(),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
