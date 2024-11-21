import 'package:eye_app_devfest_2024/utils/extension.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

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
  // final options2 = LocalObjectDetectorOptions(
  //   modelPath: modelPath, // This path is from your project: such as assets/json/
  //   mode: mode,
  //   classifyObjects: true,
  //   multipleObjects: true,
  // );

  Future<void> processImage({required String imgPath}) async {
    var objectDetector = ObjectDetector(options: options); //initialize the object detector
    final inputImage = InputImage.fromFilePath(imgPath); // convert file image to Input image
    final List<DetectedObject> objects = await objectDetector.processImage(inputImage);

    for (DetectedObject detectedObject in objects) {
      final rect = detectedObject.boundingBox;
      final trackingId = detectedObject.trackingId;
      'this is the rect: $rect, trackingId: $trackingId, labels: ${detectedObject.labels}'.logError(name: 'process_image');
      for (Label label in detectedObject.labels) {
        print('${label.text} ${label.confidence}');
      }
    }
  }
}
