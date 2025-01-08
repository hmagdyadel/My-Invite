import 'package:app/core/theming/colors.dart';
import 'package:app/core/widgets/subtitle_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dimensions/dimensions.dart';

void animatedLoaderWithTitle({required BuildContext context, bool dismissible = false, required String title}) {
  showDialog(
    barrierDismissible: dismissible,
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
            padding: EdgeInsets.all(edge * 1.5),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CupertinoActivityIndicator(
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 12,
                ),
                Flexible(
                  child: SubTitleText(
                    text: title,
                    align: TextAlign.center,
                    color: Colors.white,
                  ),
                )
              ],
            )),
      );
    },
  );
}

void showLoader({required BuildContext context, bool dismissible = false}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double dialogSize = 40;
  showDialog(
    barrierDismissible: dismissible,
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: (screenWidth / 2) - dialogSize),
        child: Container(
          height: dialogSize * 2,
          width: dialogSize,
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
          child: const Center(
            child: CupertinoActivityIndicator(
              color: Colors.white,
            ),
          ),
        ),
      );
    },
  );
}

void dialogWithSingleAction({required BuildContext context, required String title, required String msg, String? actionText, Function? onActionTap, bool dismissible = true}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: SubTitleText(
          text: title,
        ),
        content: SubTitleText(
          text: msg,
        ),
        backgroundColor: Colors.black,
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              if (onActionTap != null) {
                onActionTap();
              } else {
                popDialog(context);
              }
            },
            child: SubTitleText(
              text: actionText ?? "close".tr(),
              color: Colors.white,
            ),
          ),
        ],
      );
    },
  );
}

void popDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
