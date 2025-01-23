import 'package:app/core/widgets/subtitle_text.dart';
import'package:flutter/material.dart';

import '../theming/colors.dart';
AppBar publicAppBar(BuildContext context,String title) {
  return AppBar(
    backgroundColor: bgColor,
    elevation: 0,
    title: SubTitleText(
      text: title,
      color: Colors.white,
      fontSize: 20,
    ),
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
      onPressed: () => Navigator.of(context).pop(),
    ),
  );
}