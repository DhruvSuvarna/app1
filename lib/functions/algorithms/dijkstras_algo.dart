import 'package:collection/collection.dart';

class Graph {
  static final Graph _instance = Graph._internal();
  factory Graph() => _instance;
  Graph._internal();

  final Map<String, List<MapEntry<String, int>>> _adjacencyList = {};

  void addEdge(String from, String to, int weight) {
    _adjacencyList.putIfAbsent(from, () => []).add(MapEntry(to, weight));
    _adjacencyList.putIfAbsent(to, () => []).add(MapEntry(from, weight)); // Bidirectional
  }

  List<String> dijkstra(String start, String end) {
    if (!_adjacencyList.containsKey(start) || !_adjacencyList.containsKey(end)) {
      return []; // Return empty path if start or end nodes don't exist
    }

    final Map<String, int> distances = {};
    final Map<String, String?> previous = {};
    final Set<String> visited = {};

    // Custom comparator for the priority queue
    final queue = PriorityQueue<MapEntry<String, int>>(
      (a, b) => a.value.compareTo(b.value)
    );

    // Initialize distances with infinity except for start node
    for (var node in _adjacencyList.keys) {
      distances[node] = node == start ? 0 : double.maxFinite.toInt();
      previous[node] = null;
    }

    queue.add(MapEntry(start, 0));

    while (queue.isNotEmpty) {
      final current = queue.removeFirst().key;

      if (current == end) {
        break; // Found the target node, no need to continue
      }

      if (visited.contains(current)) {
        continue; // Skip if node already visited
      }

      visited.add(current);

      for (var neighborEntry in _adjacencyList[current] ?? []) {
        if (visited.contains(neighborEntry.key)) {
          continue; // Skip if neighbor already visited
        }

        final newDistance = distances[current]! + neighborEntry.value;

        if (newDistance < distances[neighborEntry.key]!) {
          distances[neighborEntry.key] = newDistance.toInt();
          previous[neighborEntry.key] = current;
          queue.add(MapEntry(neighborEntry.key, newDistance.toInt()));
        }
      }
    }

    // Reconstruct path
    if (previous[end] == null && start != end) {
      return []; // No path exists
    }

    final List<String> path = [];
    String? current = end;
    while (current != null) {
      path.add(current);
      current = previous[current];
    }

    return path.reversed.toList();
  }

  // Helper method to clear the graph
  void clear() {
    _adjacencyList.clear();
  }
}