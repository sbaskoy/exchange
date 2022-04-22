import 'package:flutter/material.dart';
import 'package:kurtakip/widgets/texts/custom_text.dart';

class TitleText extends CustomText {
  final String title;
  final Color? titleColor;

  const TitleText({Key? key, required this.title, this.titleColor})
      : super(
          key: key,
          text: title,
          color: titleColor ?? Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        );
}
