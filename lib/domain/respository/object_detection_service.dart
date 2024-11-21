import 'dart:async';
import 'dart:io';

import 'package:eye_app_devfest_2024/strings.dart';
import 'package:eye_app_devfest_2024/utils/extension.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ObjectDetectionService {
  ObjectDetectionService._();

  static final ObjectDetectionService _instance = ObjectDetectionService._();

  static ObjectDetectionService get instance => _instance;

  ///  use [DetectionMode.stream] if you are using Camera
  static const mode = DetectionMode.single;

  //! WITH THE BASE MODEL THAT IS BUNDLED WITH THE SDK
  final options = ObjectDetectorOptions(
    mode: mode,
    classifyObjects: true, //Indicates whether the object classification feature is enabled
    multipleObjects:
        true, // If set to false, the detector returns only the most prominent object detected.
  );

  //! WITH THE MODEL THAT IS HOSTED ON FIREBASE
  //  final options2 = FirebaseObjectDetectorOptions(
  //   modelName: modelName, // you must pass model name here
  //   mode: mode,
  //   classifyObjects: true,
  //   multipleObjects: true,
  //

  //! WITH THE MODEL THAT IS LOCALLY ON PROJECT
  Future<LocalObjectDetectorOptions> optionsLocal() async {
    String modelPath = await getModelPath(StringConst.modelPath);
    return LocalObjectDetectorOptions(
      modelPath: modelPath, // This path is from your project: such as assets/json/
      mode: mode,
      classifyObjects: true,
      multipleObjects: true,
    );
  }

  Future<(String?, List<DetectedObject>?)> processImage({required String imgPath}) async {
    //await optionsLocal()
    var objectDetector =
        ObjectDetector(options: await optionsLocal()); //initialize the object detector
    final inputImage = InputImage.fromFilePath(imgPath); // convert file image to Input image
    try {
      final List<DetectedObject> objects = await objectDetector.processImage(inputImage).timeout(
        const Duration(seconds: 35),
        onTimeout: () {
          throw TimeoutException('timed out');
        },
      );
      if (objects.isNullOrEmpty) {
        return ('No objects found', objects);
      } else {
        return (null, objects);
      }
    } catch (e) {
      'this is the error: $e'.logError(name: 'process image');
      return ('e.toString()', null);
    }
  }
}

Future<String> getModelPath(String asset) async {
  final path = '${(await getApplicationSupportDirectory()).path}/$asset';
  await Directory(dirname(path)).create(recursive: true);
  final file = File(path);
  if (!await file.exists()) {
    final byteData = await rootBundle.load(asset);
    await file
        .writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
  'this is the file path: ${file.path}'.logError();
  return file.path;
}
