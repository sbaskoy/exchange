import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final double? height;
  final double? margin;
  final TextInputType? type;
  final Function(String?)? onChange;
  final bool? readOnly;
  const CustomFormField(
      {Key? key,
      this.height,
      this.controller,
      this.hint,
      this.label,
      this.margin,
      this.type,
      this.onChange,
      this.readOnly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 35,
      margin: EdgeInsets.all(margin ?? 0),
      child: TextField(
        controller: controller,
        onChanged: onChange,
        readOnly: readOnly ?? false,
        keyboardType: type ?? TextInputType.number,
        decoration: InputDecoration(
            hintText: hint,
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(2.0)))),
      ),
    );
  }
}
