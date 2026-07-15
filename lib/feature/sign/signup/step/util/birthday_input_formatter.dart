import 'package:flutter/services.dart';

class BirthdayInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final numbersOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (numbersOnly.length > 8) {
      return oldValue;
    }

    final buffer = StringBuffer();

    for (int i = 0; i < numbersOnly.length; i++) {
      if (i == 4 || i == 6) {
        buffer.write('-');
      }
      buffer.write(numbersOnly[i]);
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
