import 'package:flutter/material.dart';
import 'package:kurtakip/widgets/texts/custom_text.dart';

class ErrorText extends CustomText {
  final String error;

  const ErrorText({Key? key, required this.error})
      : super(key: key, text: error, color: Colors.red, fontSize: 18,);
}
