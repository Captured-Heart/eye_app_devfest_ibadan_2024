import 'dart:developer';

import 'package:eye_app_devfest_2024/utils/animations/toggle_animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension ThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Size get size => MediaQuery.sizeOf(this);
  double get totlaDeviceHeight => size.height;
  double deviceHeight(double h) => size.height * h;
  double deviceWidth(double w) => size.width * w;
}

extension PaddingExtension on Widget {
  Padding padAll([double value = 0.0]) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  Padding padSymmetric({double horizontal = 0, double vertical = 0.0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  Padding padOnly({
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
    double left = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: top, right: right, bottom: bottom, left: left),
      child: this,
    );
  }
}

extension ChildrenListSpacing on List<Widget> {
  List<Widget> paddingInColumn(double height) {
    return expand(
      (element) => [
        element,
        SizedBox(
          height: height,
        )
      ],
    ).toList();
  }

  List<Widget> paddingInRow(double width) {
    return expand(
      (element) => [
        element,
        SizedBox(
          width: width,
        )
      ],
    ).toList();
  }
}

extension DebugBorderWidgetExtension on Widget {
  Widget debugBorder({Color? color}) {
    if (kDebugMode) {
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: color ?? Colors.red, width: 4),
        ),
        child: this,
      );
    } else {
      return this;
    }
  }
}

extension GestureExtension on Widget {
  Widget onTap({required VoidCallback? onTap, required String tooltip}) {
    return ToggleAnimation(
      onTap: onTap,
      child: Tooltip(message: tooltip, child: this),
    );
  }

  Widget onTapWithoutAnimation({required VoidCallback? onTap, required String tooltip}) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(message: tooltip, child: this),
    );
  }
}

extension StringExtension on String {
  void logError({String? name}) => kDebugMode ? log(this, name: name ?? '') : null;
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() =>
      replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

extension StringExtensionOnNull on String {
  String makeStringEmptyIfNull() => isNotEmpty ? this : '';
}

extension StringNullableExtension on String? {
  bool get isEmptyOrNull => this == null || this?.isEmpty == true;
  bool get isNotEmptyOrNull => this != null && !isEmptyOrNull;
}

extension BoolNullableExtension on bool? {
  bool get isNotNullAndFalse => this != null && this == false;
  bool get isNotNullAndTrue => this != null && this == true;
}

extension ListIsNullExtension on List<dynamic>? {
  bool get isNullOrEmpty => this == null || this?.isEmpty == true;
  bool get isNotEmptyOrNull => this != null && !isNullOrEmpty;
}
