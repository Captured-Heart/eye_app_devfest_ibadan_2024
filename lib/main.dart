import 'dart:io';

import 'package:eye_app_devfest_2024/services/object_detection_service.dart';
import 'package:eye_app_devfest_2024/utils/extension.dart';
import 'package:eye_app_devfest_2024/utils/image_picker_utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String filePath = '';
  bool isLoading = false;

  void _pickImage() {
    isLoading = true;
    setState(() {});
    ImagePickerUtils.pickImageMethod(isImage: true).then((value) {
      if (value != null) {
        setState(() {
          filePath = value.path;
        });
      }
      isLoading = false;
      setState(() {});
    });
  }

  void _resetImage() {
    setState(() {
      filePath = '';
    });
  }

  void _scanImage() {
    ObjectDetectionService.instance.processImage(imgPath: filePath);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData.light(useMaterial3: false),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Eye_App Demo Devfest Ibadan 2024'),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (filePath.isNotEmpty)
                Image.file(
                  File(filePath),
                  height: context.deviceHeight(0.5),
                  width: context.deviceWidth(1),
                  fit: BoxFit.fill,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: isLoading ? _loader() : const Text('Pick Image'),
                  ),
                  if (filePath.isNotEmpty)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: _resetImage,
                      child: isLoading ? _loader() : const Text('Reset Image'),
                    ),
                ].paddingInRow(10),
              ),
              if (filePath.isNotEmpty)
                SizedBox(
                  width: context.deviceWidth(0.6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: _scanImage,
                    child: const Text('Scan image'),
                  ),
                ),
              Flexible(
                child: DataTable(
                  horizontalMargin: 10,
                  columnSpacing: 30,
                  border: TableBorder.all(color: Theme.of(context).primaryColor.withOpacity(0.8)),
                  columns: [
                    dataColumn(context, title: 'Test'),
                    dataColumn(context, title: 'Result'),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        dataCell(context, title: 'Rect'),
                        dataCell(context, title: 'Tracking'),
                      ],
                    ),
                  ],
                ),
              ),
            ].paddingInColumn(20),
          ),
        ),
      ),
    );
  }

// loader
  Widget _loader() => const SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
// data cell
  DataCell dataCell(BuildContext context, {required String title}) {
    return DataCell(
      Text(
        title,
        style: context.textTheme.displayMedium?.copyWith(
          fontSize: 14,
        ),
      ),
    );
  }

  // data column
  DataColumn dataColumn(BuildContext context, {required String title}) {
    return DataColumn(
      label: Flexible(
        child: Text(
          title,
          style: context.textTheme.displayMedium?.copyWith(
            fontSize: 14,
          ),
          maxLines: 2,
        ),
      ),
    );
  }
}
