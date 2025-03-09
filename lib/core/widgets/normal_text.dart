import 'package:flutter/material.dart';


class NormalText extends StatelessWidget {
  const NormalText(
      {required this.text,
      this.align,
      this.color,
      this.decoration,
      this.fontSize,
      this.textOverflow,
      this.fontFamily,
      super.key});

  final String text;
  final Color? color;
  final String? fontFamily;
  final double? fontSize;
  final TextAlign? align;
  final TextDecoration? decoration;
  final TextOverflow? textOverflow;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: color ?? Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: fontSize ?? 16,
            fontFamily: "SFPro",
            decoration: decoration ?? TextDecoration.none,
            decorationColor: color),
        textAlign: align ?? TextAlign.center,
        overflow: textOverflow);
  }
}
