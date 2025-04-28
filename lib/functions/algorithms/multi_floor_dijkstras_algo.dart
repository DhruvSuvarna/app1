import 'package:collection/collection.dart';

class MultiFloorGraph {
  static final MultiFloorGraph _instance = MultiFloorGraph._internal();
  factory MultiFloorGraph() => _instance;
  MultiFloorGraph._internal();

  // Map to store floor-specific graphs: floor number -> adjacency list
  final Map<int, Map<String, List<MapEntry<String, int>>>> _floorGraphs = {};
  
  // Store vertical connections (stairs/lifts) between floors
  final Map<String, List<MapEntry<String, int>>> _verticalConnections = {};

  // Add edge within the same floor
  void addEdge(int floor, String from, String to, int weight) {
    _floorGraphs.putIfAbsent(floor, () => {});
    _floorGraphs[floor]!.putIfAbsent(from, () => []).add(MapEntry(to, weight));
    _floorGraphs[floor]!.putIfAbsent(to, () => []).add(MapEntry(from, weight));
  }

  // Add vertical connection between floors
  void addVerticalConnection(String from, String to, int weight) {
    _verticalConnections.putIfAbsent(from, () => []).add(MapEntry(to, weight));
    _verticalConnections.putIfAbsent(to, () => []).add(MapEntry(from, weight));
  }

  // Get floor number from room number (e.g., "312" -> 3)
  int _getFloorFromRoom(String room) {
    if (room.startsWith('S')) {
      // For stairway nodes (e.g., "S1a", "S2b"), get the floor number after "S"
      var floor = int.parse(room.substring(1, 2));
      print('Floor: $floor');
      return floor;
    }
    // For regular rooms (e.g., "101", "202"), get first digit
    return int.parse(room[0]);
  }

  List<String> findPath(String start, String end) {
    
    final Map<String, int> distances = {};
    final Map<String, String?> previous = {};
    final Set<String> visited = {};

    final queue = PriorityQueue<MapEntry<String, int>>(
      (a, b) => a.value.compareTo(b.value)
    );

    // Initialize distances for all nodes in all floors and vertical connections
    distances[start] = 0;
    for (var floor in _floorGraphs.keys) {
      for (var node in _floorGraphs[floor]!.keys) {
        if (node != start) {
          distances[node] = double.maxFinite.toInt();
        }
        previous[node] = null;
      }
    }

    queue.add(MapEntry(start, 0));

    while (queue.isNotEmpty) {
      final current = queue.removeFirst().key;
      
      if (current == end) break;
      
      if (visited.contains(current)) continue;
      
      visited.add(current);

      // Get current floor's connections
      final currentFloor = _getFloorFromRoom(current);
      final floorConnections = _floorGraphs[currentFloor]?[current] ?? [];

      // Get vertical connections if available
      final verticalConnections = _verticalConnections[current] ?? [];

      // Combine both types of connections
      final allConnections = [...floorConnections, ...verticalConnections];

      for (var neighborEntry in allConnections) {
        if (visited.contains(neighborEntry.key)) continue;

        final newDistance = distances[current]! + neighborEntry.value;

        if (newDistance < distances[neighborEntry.key]!) {
          distances[neighborEntry.key] = newDistance;
          previous[neighborEntry.key] = current;
          queue.add(MapEntry(neighborEntry.key, newDistance));
        }
      }
    }

    // Reconstruct path
    if (previous[end] == null && start != end) return [];

    final List<String> path = [];
    String? current = end;
    while (current != null) {
      path.add(current);
      current = previous[current];
    }

    return path.reversed.toList();
  }

  void clear() {
    _floorGraphs.clear();
    _verticalConnections.clear();
  }
}