import 'dart:developer';
import 'dart:io';
import 'package:eye_app_devfest_2024/domain/result_metrics.dart';
import 'package:eye_app_devfest_2024/presentation/widgets/data_cells.dart';
import 'package:eye_app_devfest_2024/presentation/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:eye_app_devfest_2024/controller/eye_scan_controller.dart';
import 'package:eye_app_devfest_2024/domain/models/label_model.dart';
import 'package:eye_app_devfest_2024/utils/extension.dart';

class EyeScanView extends StatefulWidget {
  const EyeScanView({super.key});

  @override
  State<EyeScanView> createState() => _EyeScanViewState();
}

class _EyeScanViewState extends State<EyeScanView> {
  final EyeScanNotifier _eyeScanNotifier = EyeScanNotifier();

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eye_App Demo Devfest Ibadan 2024'),
      ),
      body: ListenableBuilder(
        listenable: _eyeScanNotifier,
        builder: (context, _) {
          String? filePath = _eyeScanNotifier.filePath.value;
          String errorMessage = _eyeScanNotifier.errorMessage.value;
          bool isLoadingPick = _eyeScanNotifier.isLoadingPick.value;
          bool isLoadingScan = _eyeScanNotifier.isLoadingScan.value;
          List<DetectedObject> objectList = _eyeScanNotifier.objectList.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(
              // physics: NeverScrollableScrollPhysics(),
              child: SizedBox(
                height: context.deviceHeight(1),
                width: context.deviceWidth(1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (filePath.isNotEmptyOrNull && !isLandscape)
                      Flexible(
                        child: Image.file(
                          File(filePath),
                          width: context.deviceWidth(1),
                          fit: BoxFit.fill,
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLandscape)
                          SizedBox(
                            height: 150,
                            width: 300,
                            child: Image.file(
                              File(filePath),
                              width: context.deviceWidth(1),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ElevatedButton(
                          onPressed: () {
                            _eyeScanNotifier.pickImage(context);
                          },
                          // _pickImage,
                          child: isLoadingPick ? const Loader() : const Text('Pick Image'),
                        ),
                        if (filePath.isNotEmptyOrNull)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: _eyeScanNotifier.resetImage,
                            child: const Text('Reset Image'),
                          ),
                      ].paddingInRow(10),
                    ),
                    if (filePath.isNotEmptyOrNull)
                      Column(
                        children: [
                          if (errorMessage.isNotEmptyOrNull)
                            Text(
                              '$errorMessage....',
                              style: context.textTheme.bodyLarge?.copyWith(color: Colors.red),
                            ),
                          Builder(
                            builder: (context) {
                              return SizedBox(
                                width: context.deviceWidth(0.6),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  onPressed: () => _eyeScanNotifier.scanImage(context),
                                  child: isLoadingScan ? const Loader() : const Text('Scan image'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    if (objectList.isNotEmptyOrNull)
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            horizontalMargin: 10,
                            columnSpacing: 30,
                            border: TableBorder.all(
                                color: Theme.of(context).primaryColor.withOpacity(0.8)),
                            columns: [
                              dataColumn(context, title: 'Rect'),
                              dataColumn(context, title: 'Labels'),
                              dataColumn(context, title: 'Diagnosis'),
                            ],
                            rows: [
                              ...List.generate(
                                objectList.length,
                                (index) {
                                  var object = objectList[index];
                                  // 'this is ${object.labels[0].text.substring(6)}'.logError();
                                  String title() {
                                    return '${List.generate(object.labels.length, (index) {
                                      Label labels = object.labels[index];
                                      var newLabel = LabelModel(
                                          confidence: labels.confidence,
                                          index: labels.index,
                                          text: labels.text);

                                      return newLabel.toMap();
                                    })}';
                                  }

                                  return DataRow(
                                    cells: [
                                      dataCell(context, title: object.boundingBox.toString()),
                                      dataCell(context, title: title()),
                                      object.labels.isNotEmptyOrNull
                                          ? dataCell(context,
                                              title: DiagnosisLevel.labeltext(
                                                      object.labels[0].text.substring(6).trim())
                                                  .toMap)
                                          : dataCell(context, title: ''),
                                    ],
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                  ].paddingInColumn(20),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
