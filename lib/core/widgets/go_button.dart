import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../dimensions/dimensions.dart';

class GoButton extends StatelessWidget {
  const GoButton({required this.fun, required this.titleKey, this.w, this.fontWeight, this.icon, this.alignment, this.loaderColor, this.vertical, this.curvy, this.gradient = false, this.fontSize, this.loading = false, this.hi, this.btColor, this.borderColor, this.textColor, this.enable = true, super.key});

  final Alignment? alignment;
  final Function fun;
  final double? w;
  final double? hi;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? curvy;
  final String titleKey;
  final Color? btColor;
  final Color? borderColor;
  final Color? textColor;
  final bool loading;
  final Color? loaderColor;
  final bool enable;
  final bool? vertical;
  final bool gradient;
  final Widget? icon;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (enable && !loading) {
          fun();
        }
      },
      child: Container(
        height: hi ?? 45.h,
        width: w ?? width.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient:gradient ? gradient1: null,
          color: enable ? btColor ?? Colors.black : Colors.black,
          borderRadius: BorderRadius.circular(curvy ?? curvyRadius*2),
        ),
        child: vertical ?? false
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon ?? const SizedBox.shrink(),
                  if (icon != null) const SizedBox(height: 5),
                  SubTitleText(
                    text: titleKey,
                    color: textColor ?? Colors.black,
                    fontSize: fontSize ?? 16,
                  )
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon ?? const SizedBox.shrink(),
                  if (icon != null) const SizedBox(width: 2),
                  SubTitleText(
                    text: titleKey,
                    color: textColor ?? Colors.black,
                    fontSize: fontSize ?? 16,
                  ),
                ],
              ),
      ),
    );
  }
}
