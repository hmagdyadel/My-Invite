import 'package:flutter/material.dart';


class SubTitleText extends StatelessWidget {
  const SubTitleText(
      {required this.text,
      this.align,
      this.decoration,
      this.color,
      this.fontSize,
      this.fontFamily,
      super.key});

  final String text;
  final Color? color;
  final String? fontFamily;
  final double? fontSize;
  final TextAlign? align;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color ?? Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: fontSize ?? 24,
          fontFamily: fontFamily ?? "Almarai",
          decoration: decoration ?? TextDecoration.none,
          decorationColor: Colors.white),
      textAlign: align ?? TextAlign.center,
    );
  }
}
