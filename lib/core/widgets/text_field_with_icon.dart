import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theming/colors.dart';

Widget textFieldWithIcon({Color bgColor = bgColorOverlay, required Widget icon, required String hint, required TextEditingController controller, double height = 45, Widget suffix = const SizedBox(), bool obscureText = false, List<TextInputFormatter>? formatter, TextInputType inputType = TextInputType.text,FocusNode? focusNode}) {
  return Container(
    height: height,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
    child: Row(
      children: [
        icon,
        const SizedBox(
          width: 6,
        ),
        Expanded(
          child: TextFormField(
            inputFormatters: formatter ?? [],
            controller: controller,
            style: TextStyle(color: Colors.white, fontSize: 14),
            keyboardType: inputType,
            textAlignVertical: TextAlignVertical.top,
            obscureText: obscureText,
            focusNode: focusNode,
            decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: Colors.white.withAlpha(128), fontSize: 14), border: InputBorder.none, contentPadding: EdgeInsets.zero),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        suffix
      ],
    ),
  );
}
