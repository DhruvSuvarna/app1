// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import '../functions/camera/camera_manager.dart';
// import '../functions/camera/light_signal_analyzer.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import '../../functions/camera/camera_manager.dart';
import '../../functions/camera/light_signal_analyzer.dart';

class CameraService {
  late CameraManager _cameraManager;
  late LightSignalAnalyzer _analyzer;
  String _textDataStream = "";

  final _textStreamController = StreamController<String>.broadcast();

  Stream<String> get textStream => _textStreamController.stream;

  CameraService() {
    _cameraManager = CameraManager(onFrameAvailable: _onNewFrame);
    _analyzer = LightSignalAnalyzer(_onNewCharReceived);
  }

  Future<void> initialize() async {
    await _cameraManager.initializeCamera();
  }

  void _onNewFrame(CameraImage image) {
    _analyzer.analyze(image);
  }

  void _onNewCharReceived(String char) {
    _textDataStream += char;
    if (_textDataStream.length > 100) {
      _textDataStream = _textDataStream.substring(_textDataStream.length - 100);
    }
    _textStreamController.add(_textDataStream); // Send updated text
  }

  void dispose() {
    _cameraManager.dispose();
    _textStreamController.close();
  }
}

// class CameraPage extends StatefulWidget {
//   @override
//   // ignore: library_private_types_in_public_api
//   _CameraPageState createState() => _CameraPageState();
//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     body: Center(child: Text("Welcome to Camera Page"))
//   //   );
//   // }
// }

// class _CameraPageState extends State<CameraPage> {
//   late CameraManager _cameraManager;
//   late LightSignalAnalyzer _analyzer;
//   String textDataStream = "";

//   @override
//   void initState() {
//     super.initState();
//     _cameraManager = CameraManager(onFrameAvailable: _onNewFrame);
//     _analyzer = LightSignalAnalyzer((char) {
//       setState(() {
//         textDataStream += char;
//         if (textDataStream.length > 100) {
//           textDataStream = textDataStream.substring(textDataStream.length - 100);
//         }
//       });
//     });

//     _initialize();
//   }

//   Future<void> _initialize() async {
//     await _cameraManager.initializeCamera();
//     setState(() {});
//   }

//   void _onNewFrame(CameraImage image) {
//     _analyzer.analyze(image);
//   }

//   @override
//   void dispose() {
//     _cameraManager.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           _cameraManager.controller != null && _cameraManager.controller!.value.isInitialized
//               ? CameraPreview(_cameraManager.controller!)
//               : Center(child: CircularProgressIndicator()),
//           Positioned(
//             bottom: 80,
//             left: 20,
//             right: 20,
//             child: Container(
//               padding: EdgeInsets.all(10),
//               color: Colors.black.withValues(alpha: 0.5),
//               child: Text(
//                 textDataStream,
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
