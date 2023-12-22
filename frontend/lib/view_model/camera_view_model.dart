import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraViewModel with ChangeNotifier {
  List<CameraDescription> _cameras = [];
  List<CameraDescription> get cameras => List.from(_cameras);

  CameraController? _cameraController;
  CameraController? get controller => _cameraController;

  CameraViewModel() {
    _loadCamera();
  }

  Future<void> _loadCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras.first, ResolutionPreset.max);
    notifyListeners();
  }
}
