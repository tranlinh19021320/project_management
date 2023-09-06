import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;
  NumericRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final number =  double.tryParse(newValue.text);

    if (number == null) {
      return oldValue;
    }

    if (number < min) {
      newValue.copyWith(text: min.toString());

    } else if (number > max) {
      newValue.copyWith(text: max.toString());
    } else {
      return newValue;
    }
    throw UnimplementedError();
  }

}