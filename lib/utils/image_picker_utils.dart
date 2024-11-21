import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImagePickerUtils {
  const ImagePickerUtils._();
  static const ImagePickerUtils _instance = ImagePickerUtils._();

  static ImagePickerUtils get instance => _instance;

// PICK IMAGE FROM DEVICE
  static Future<XFile?> pickImageMethod({
    bool? pickCamera,
    bool? cameraRear,
    required bool isImage,
  }) async {
    final picker = ImagePicker();

    if (isImage == true) {
      final selectedImage = await picker.pickImage(
        source: pickCamera == true ? ImageSource.camera : ImageSource.gallery,
        preferredCameraDevice: cameraRear == true ? CameraDevice.rear : CameraDevice.front,
        imageQuality: 95,
        maxHeight: 400,
      );
      if (selectedImage != null) {
        String? croppedImage = await cropImage(imgPath: selectedImage.path);
        if (croppedImage == null) return null;

        return XFile(croppedImage);
      }
      return null;
    } else {
      final selectedVideo = await picker.pickVideo(
          source: pickCamera == true ? ImageSource.camera : ImageSource.gallery,
          preferredCameraDevice: cameraRear == true ? CameraDevice.rear : CameraDevice.front,
          maxDuration: const Duration(seconds: 100));
      if (selectedVideo != null) {
        return selectedVideo;
      }
      return null;
    }
  }

// --------- CROP IMAGE ----------------------------
  static Future<String?> cropImage({required String imgPath}) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imgPath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.transparent,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: '',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
      ],
    );
    if (croppedFile != null) {
      return croppedFile.path;
    }
    return null;
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
