import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/theming/colors.dart';
import '../../../core/widgets/public_appbar.dart';

class ClientStatisticsScreen extends StatefulWidget {
  const ClientStatisticsScreen({super.key});

  @override
  State<ClientStatisticsScreen> createState() => _ClientStatisticsScreenState();
}

class _ClientStatisticsScreenState extends State<ClientStatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorOverlay,
      appBar: publicAppBar(context, "events_calendar".tr()),
    );
  }
}
