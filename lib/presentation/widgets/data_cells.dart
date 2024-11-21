import 'package:eye_app_devfest_2024/utils/extension.dart';
import 'package:flutter/material.dart';

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
