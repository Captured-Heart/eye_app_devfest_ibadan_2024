import 'package:eye_app_devfest_2024/domain/respository/object_detection_service.dart';
import 'package:eye_app_devfest_2024/utils/extension.dart';
import 'package:eye_app_devfest_2024/utils/image_picker_utils.dart';
import 'package:eye_app_devfest_2024/utils/typedefs.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class EyeScanNotifier extends ChangeNotifier {
  ValueNotifyString filePath = ValueNotifyString('');
  ValueNotifyString errorMessage = ValueNotifyString('');
  ValueNotifyBool isLoadingPick = ValueNotifyBool(false);
  ValueNotifier isLoadingScan = ValueNotifyBool(false);
  ValueNotifier objectList = ValueNotifier<List<DetectedObject>>([]);

  void pickImage(BuildContext context) {
    if (filePath.value.isNotEmptyOrNull) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Reset, pick a new image!!'),
          backgroundColor: context.colorScheme.error,
        ),
      );
      return;
    }
    isLoadingPick.value = true;
    notifyListeners();

    ImagePickerUtils.pickImageMethod(isImage: true).then((value) {
      if (value != null) {
        filePath.value = value.path;
        notifyListeners();
      }
      isLoadingPick.value = false;
      notifyListeners();
    });
  }

  void resetImage() {
    filePath.value = '';
    objectList.value.clear();
    isLoadingPick.value = false;
    isLoadingScan.value = false;
    errorMessage.value = '';
    notifyListeners();
  }

  void scanImage(BuildContext context2) {
    isLoadingScan.value = true;
    notifyListeners();
    ObjectDetectionService.instance.processImage(imgPath: filePath.value).then(
      (value) {
        if (value.$2.isNotEmptyOrNull) {
          objectList.value = value.$2!;
          isLoadingScan.value = false;
          notifyListeners();
        }

        if (value.$1.isNotEmptyOrNull) {
          isLoadingScan.value = false;
          errorMessage.value = value.$1!;
          notifyListeners();
        }
      },
    );
  }
}
