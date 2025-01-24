import 'package:flutter/material.dart';
import '../../../../../core/widgets/subtitle_text.dart';
import '../../../../../core/dimensions/dimensions.dart';

class MessagesStatisticsHeader extends StatelessWidget {
  final String title;

  const MessagesStatisticsHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: edge, vertical: edge * 0.8),
      child: SubTitleText(
        text: title,
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }
}
