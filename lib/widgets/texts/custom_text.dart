import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  
  const CustomText({Key? key, required this.text, this.fontSize, this.fontWeight, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color ?? Colors.black, fontWeight: fontWeight ?? FontWeight.w500, fontSize: fontSize ?? 18),
    );
  }
}
