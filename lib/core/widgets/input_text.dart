import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../dimensions/dimensions.dart';


class InputText extends StatefulWidget {
  const InputText({
    this.title,
    this.width,
    this.controller,
    this.maxLine,
    this.enable,
    this.subTitle,
    this.borderColor,
    this.hint,
    this.radius,
    this.fillColor,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.suffixIcon,
    this.obscureText = false,
    this.isPassword = false,
    this.hasValidationSpace = true,
    this.inputColor,
    super.key,
  });

  final double? width;
  final String? title;
  final String? subTitle;
  final String? hint;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText, isPassword, hasValidationSpace;
  final bool? enable;
  final ValueChanged<String>? onChanged;
  final Color? fillColor;
  final Color? borderColor;
  final double? radius;
  final int? maxLine;
  final Color? inputColor;

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  late final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? width.w/2,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(curvyRadius)),
      child: TextField(
        focusNode: _focusNode,
        // Attach the FocusNode
        onTapOutside: (value) => FocusScope.of(context).unfocus(),

        keyboardType: widget.keyboardType,
        controller: widget.controller,
      //  style: TextStyle(color: widget.inputColor ?? titleColor.getColor()),
        maxLines: widget.maxLine ?? 1,
        obscureText: widget.isPassword ? _securePass : widget.obscureText,
        enabled: widget.enable ?? true,
        onChanged: widget.onChanged ?? (v) {},

        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
                horizontal: 16, vertical: widget.maxLine != null ? 12 : 0),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(6.0), // Padding applied here
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF187B96),
                  borderRadius: BorderRadius.circular(5.0),

                ),

                child: widget.prefixIcon, // Placeholder child
              ),
            ),

            border: OutlineInputBorder(

                borderRadius: BorderRadius.circular(curvyRadius),
                borderSide: const BorderSide(
                    color: Colors.transparent),
            ),
            // focusedBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(curvyRadius),
            //     //borderSide: const BorderSide(color: borderColor, width: 1),
            // ),
            // enabledBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(curvyRadius),
            //     // borderSide: BorderSide(
            //     //     color: widget.borderColor ?? borderColor, width: 1),
            // ),
            // disabledBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(curvyRadius),
            //     // borderSide: BorderSide(
            //     //     color:
            //     //     widget.borderColor ?? secondButtonColor.getColor(),
            //     //     width: 1),
            // ),
            hintText: widget.hint,
            hintStyle: const TextStyle(
                color:Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400),
            // fillColor: (widget.enable ?? true)
            //     ? Colors.transparent
            //     : secondButtonColor.getColor(),
            filled: true,
    suffixIcon: widget.isPassword
    ? GestureDetector(
    onTap: _changeVisibility,
    child: Icon(
    _securePass ? Icons.visibility_off : Icons.visibility,
    ),
    )
        : const SizedBox.shrink()
    )
    )
    );

  }

  bool _securePass = true;

  _changeVisibility() {
    _securePass = !_securePass;
    setState(() {});
  }
}
