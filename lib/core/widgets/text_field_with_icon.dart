import 'package:app/core/dimensions/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theming/colors.dart';
Widget textFieldWithIcon({
  Color? bgColor,
  required Widget icon,
  required String hint,
  required TextEditingController controller,
  double height = 45,
  Widget suffix = const SizedBox(),
  bool obscureText = false,
  List<TextInputFormatter>? formatter,
  TextInputType inputType = TextInputType.text,
  FocusNode? focusNode
}) {
  // Ensure we always have a valid background color
  final Color safeColor = bgColor ?? bgColorOverlay;

  try {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: safeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 6),
          Expanded(
            child: SizedBox(
              width: width,
              child: TextFormField(
                inputFormatters: formatter ?? [],
                controller: controller,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                keyboardType: inputType,
                textAlignVertical: TextAlignVertical.top,
                obscureText: obscureText,
                focusNode: focusNode,
                decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.white.withAlpha(128), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          suffix
        ],
      ),
    );
  } catch (e) {
    // Fallback to a simpler version if something goes wrong
    debugPrint('Error in textFieldWithIcon: $e');
    return Container(
      height: height,
      color: Colors.grey[800],
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}