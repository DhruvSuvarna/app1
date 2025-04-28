import 'dart:typed_data';
import 'dart:math';
import 'package:camera/camera.dart';

class LightSignalAnalyzer {
  final Function(String) onByteReceived;
  final int bitDurationMs;
  int calibrationCount = 0;
  final int calibrationNeeded = 10;
  int maxIntensity = 0;
  int minIntensity = 255;
  bool? previousState;
  bool samplingInProgress = false;
  int samplingStartTime = 0;
  int currentBitIndex = 0;
  int sampledByte = 0;

  LightSignalAnalyzer(this.onByteReceived, {this.bitDurationMs = 200});

  void analyze(CameraImage image) {
    try {
      Uint8List bytes = image.planes[0].bytes;
      int width = image.width;
      int height = image.height;
      int centerX = width ~/ 2;
      int centerY = height ~/ 2;
      int roiSize = 50;

      int totalIntensity = 0;
      int pixelCount = 0;
      for (int y = centerY - roiSize ~/ 2; y < centerY + roiSize ~/ 2; y++) {
        for (int x = centerX - roiSize ~/ 2; x < centerX + roiSize ~/ 2; x++) {
          int index = y * width + x;
          if (index < bytes.length) {
            totalIntensity += bytes[index];
            pixelCount++;
          }
        }
      }
      int currentIntensity = pixelCount > 0 ? totalIntensity ~/ pixelCount : 0;

      maxIntensity = max(maxIntensity, currentIntensity);
      minIntensity = min(minIntensity, currentIntensity);

      if (calibrationCount < calibrationNeeded) {
        calibrationCount++;
        previousState = null;
        return;
      }

      int threshold = (maxIntensity + minIntensity) ~/ 2;
      bool currentState = currentIntensity > threshold;
      int currentTime = DateTime.now().millisecondsSinceEpoch;

      if (!samplingInProgress && previousState == true && !currentState) {
        samplingInProgress = true;
        currentBitIndex = 0;
        sampledByte = 0;
        samplingStartTime = currentTime + ((bitDurationMs * 3) ~/ 2);
      }
      previousState = currentState;

      if (samplingInProgress && currentTime >= samplingStartTime + (currentBitIndex * bitDurationMs)) {
        int bit = currentState ? 1 : 0;
        sampledByte |= (bit << currentBitIndex);
        currentBitIndex++;

        if (currentBitIndex == 8) {
          String character = String.fromCharCode(sampledByte);
          if (sampledByte >= 32 && sampledByte <= 126) {
            onByteReceived(character);
          }
          samplingInProgress = false;
        }
      }
    } catch (e) {
      print("Error in analyzing frame: $e");
    }
  }
}
