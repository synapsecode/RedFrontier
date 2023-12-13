import 'package:flutter/material.dart';
import 'package:redfrontier/widgets/circularchart.dart';

class ResourcesTab extends StatelessWidget {
  const ResourcesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularChart(title: 'Energy', value: 75, color: Colors.yellow),
            SizedBox(
              height: 20,
            ),
            CircularChart(title: 'Fuel', value: 60, color: Colors.orange),
            SizedBox(
              height: 20,
            ),
            CircularChart(title: 'Waste', value: 40, color: Colors.red),
            SizedBox(
              height: 20,
            ),
            CircularChart(title: 'Rations', value: 85, color: Colors.green),
            SizedBox(
              height: 20,
            ),
            CircularChart(title: 'Oxygen', value: 90, color: Colors.blue),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
