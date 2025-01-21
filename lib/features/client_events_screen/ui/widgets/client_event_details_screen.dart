import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/public_appbar.dart';
import '../../data/models/client_event_response.dart';

class ClientEventDetailsScreen extends StatefulWidget {
  final ClientEventDetails clientEventDetailsItem;

  const ClientEventDetailsScreen({super.key, required this.clientEventDetailsItem});

  @override
  State<ClientEventDetailsScreen> createState() => _ClientEventDetailsScreenState();
}

class _ClientEventDetailsScreenState extends State<ClientEventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorOverlay,
      appBar: publicAppBar(context, "attendance_info".tr()),
    );
  }
}
