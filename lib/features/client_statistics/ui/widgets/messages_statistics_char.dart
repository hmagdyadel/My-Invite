import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/subtitle_text.dart';
import '../../data/models/bar_chart_model.dart';
import '../../data/models/client_messages_statistics_response.dart';

class MessagesStatisticsChart extends StatelessWidget {
  final String title;
  final ClientMessagesStatisticsDetails details;

  const MessagesStatisticsChart({super.key, required this.title, required this.details});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Container(
        decoration: BoxDecoration(color: bgColorOverlay, borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SubTitleText(
                  text: title,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBarChart(),
            const SizedBox(height: 16),
            _buildChartLegends(),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return AspectRatio(
      aspectRatio: 1.4,
      child: BarChart(_buildBarChartData()),
    );
  }

  BarChartData _buildBarChartData() {
    return BarChartData(
      barTouchData: _buildBarTouchData(),
      barGroups: _buildBarGroups(),
      titlesData: _buildTitlesData(),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
    );
  }

  BarTouchData _buildBarTouchData() {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (_) => Colors.transparent,
        tooltipPadding: EdgeInsets.zero,
        getTooltipItem: (group, _, rod, __) => BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final chartData = [
      BarChartModel(value: (details.readNumber ?? 0).toDouble(), title: "read_number".tr(), color: primaryColor),
      BarChartModel(value: (details.deliverdNumber ?? 0).toDouble(), title: "delivered_number".tr(), color: secondaryColor),
      BarChartModel(value: (details.sentNumber ?? 0).toDouble(), title: "sent_number".tr(), color: Colors.red),
      BarChartModel(value: (details.failedNumber ?? 0).toDouble(), title: "failed_number".tr(), color: Colors.yellowAccent),
      BarChartModel(value: (details.notSentNumber ?? 0).toDouble(), title: "not_sent_number".tr(), color: Colors.purple),
    ];

    return List.generate(chartData.length, (index) => BarChartGroupData(x: index, barRods: [BarChartRodData(toY: chartData[index].value, color: chartData[index].color, width: 20)]));
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) => Text(
            value.toInt().toString(),
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          reservedSize: 40,
        ),
      ),
    );
  }

  Widget _buildChartLegends() {
    final legendData = [
      Legend("read_number".tr(), primaryColor),
      Legend("delivered_number".tr(), secondaryColor),
      Legend("sent_number".tr(), Colors.red),
      Legend("failed_number".tr(), Colors.yellowAccent),
      Legend("not_sent_number".tr(), Colors.purple),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: legendData.map((legend) => _buildLegendItem(legend.name, legend.color)).toList(),
    );
  }

  Widget _buildLegendItem(String name, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class Legend {
  Legend(this.name, this.color);

  final String name;
  final Color color;
}
