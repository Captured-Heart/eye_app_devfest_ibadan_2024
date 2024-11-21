// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class LabelModel extends Equatable {
  final double? confidence;

  final int? index;

  final String? text;

  const LabelModel({
    this.confidence,
    this.index,
    this.text,
  });

  /// Returns an instance of [Label] from a given [json].
  // factory LabelModel.fromJson(Map<dynamic, dynamic> json) => LabelModel(
  //       confidence: json['confidence'],
  //       index: json['index'],
  //       text: json['text'],
  //     );

  LabelModel copyWith({
    double? confidence,
    int? index,
    String? text,
  }) {
    return LabelModel(
      confidence: confidence ?? this.confidence,
      index: index ?? this.index,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'confidence': confidence,
      'index': index,
      'text': text,
    };
  }

  factory LabelModel.fromMap(Map<String, dynamic> map) {
    return LabelModel(
      confidence: map['confidence'] != null ? map['confidence'] as double : null,
      index: map['index'] != null ? map['index'] as int : null,
      text: map['text'] != null ? map['text'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LabelModel.fromJson(String source) =>
      LabelModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [confidence, index, text];
}
