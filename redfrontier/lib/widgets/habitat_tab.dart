import 'package:flutter/material.dart';
import 'package:redfrontier/widgets/circularchart.dart';

class HabitatTab extends StatelessWidget {
  const HabitatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircularChart(title: 'Wind Speed', value: 50, color: Colors.cyan),
          CircularChart(title: 'Dust Storm', value: 30, color: Colors.brown),
          CircularChart(title: 'Asteroid', value: 15, color: Colors.grey),
        ],
      ),
    );
  }
}
