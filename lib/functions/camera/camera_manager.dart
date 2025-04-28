import 'package:camera/camera.dart';

class CameraManager {
  CameraController? controller;
  Function(CameraImage)? onFrameAvailable;

  CameraManager({this.onFrameAvailable});

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.low);
    await controller!.initialize();
    
    controller!.startImageStream((image) {
      onFrameAvailable?.call(image);
    });
  }

  void dispose() {
    controller?.dispose();
  }
}
