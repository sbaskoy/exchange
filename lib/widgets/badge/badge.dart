import 'package:flutter/material.dart';
import 'package:kurtakip/widgets/texts/custom_text.dart';

class CustomBadge extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final VoidCallback? onPressed;
  const CustomBadge({Key? key, required this.text, this.width, this.height, this.color, this.textColor, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          width: width ?? 50,
          height: height ?? 35,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: color ?? Colors.pink,
            borderRadius: BorderRadius.circular(10)
          ),
          alignment: Alignment.center,
          child: FittedBox(
            child: CustomText(text: text, color: textColor ?? Colors.white),
          )),
    );
  }
}
