import 'package:flutter/material.dart';
import '../maps/multi_floor_navigator.dart';

class FloorMapPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _FloorMapPageState createState() => _FloorMapPageState();
}

class _FloorMapPageState extends State<FloorMapPage> {
  String? source;
  String? destination;
  final List<String> roomList = [ 
    "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", 
    "201", "202", "203", "204", "205", "206", "207", "208", "209", "210", "211", "212", 
    "301", "302", "303", "304", "305", "306", "307", "308", "309", "310", "311", "312"
  ];
  List<String> shortestPath = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Select Your Route"))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: source,
              hint: Text("Select Source"),
              items: roomList
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() => source = value),
            ),
            DropdownButton<String>(
              value: destination,
              hint: Text("Select Destination"),
              items: roomList
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() => destination = value),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (source != null && destination != null)
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigationDemo(startRoom: source, endRoom: destination),
                        ),
                      );
                    }
                  : null,
              child: Text("Find Path"),
            ),
          ],
        ),
      ),
    );
  }
}
