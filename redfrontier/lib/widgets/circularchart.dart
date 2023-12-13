import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CircularChart extends StatelessWidget {
  final String title;
  final double value;
  final Color color;

  const CircularChart({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 150,
          height: 150,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: color,
                  value: value,
                  title: '$value%',
                  radius: 50,
                  titleStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  color: Colors.grey[300]!,
                  value: 100 - value,
                  title: '$title',
                  radius: 50,
                ),
              ],
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 40,
              sectionsSpace: 0,
            ),
          ),
        ),
      ],
    );
  }
}
