import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redfrontier/extensions/extensions.dart';
import 'package:redfrontier/models/redfrontier_user.dart';
import 'package:redfrontier/services/firestore/dashboard.dart';
import 'package:redfrontier/widgets/circularchart.dart';

class ResourceData extends ChangeNotifier {
  int energyLeftPercentage = 100;
  int fuelConsumedPercentage = 0;
  int wasteFilledPercentage = 0;
  int rationsLeftPercentage = 100;
  int oxygenLeft = 100;

  loadFromMap(Map x) {
    energyLeftPercentage = x['energy'] ?? 100;
    fuelConsumedPercentage = x['fuel'] ?? 0;
    wasteFilledPercentage = x['waste'] ?? 0;
    rationsLeftPercentage = x['rations'] ?? 100;
    oxygenLeft = x['oxygen'] ?? 100;
    notifyListeners();
  }
}

final resourceProvider = ChangeNotifierProvider((ref) => ResourceData());

class ResourcesTab extends ConsumerStatefulWidget {
  const ResourcesTab({super.key});

  @override
  ConsumerState<ResourcesTab> createState() => _ResourcesTabState();
}

class _ResourcesTabState extends ConsumerState<ResourcesTab> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 200), () {
      final uid = ref.read(currentRFUserProvider)!.id;
      FirestoreDashboard.listenToResourceChanges(uid);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final res = ref.watch(resourceProvider);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularChart(
                title: '',
                value: res.energyLeftPercentage.toDouble(),
                color: Colors.yellow[800]!),
            Text('Energy Left').color(Colors.white).size(22).addTopMargin(30),
            SizedBox(height: 20),
            CircularChart(
                title: '',
                value: res.fuelConsumedPercentage.toDouble(),
                color: Colors.orange),
            Text('Fuel Consumption')
                .color(Colors.white)
                .size(22)
                .addTopMargin(30),
            SizedBox(height: 20),
            CircularChart(
                title: '',
                value: res.wasteFilledPercentage.toDouble(),
                color: Colors.red),
            Text('Waste Filled').color(Colors.white).size(22).addTopMargin(30),
            SizedBox(
              height: 20,
            ),
            CircularChart(
                title: '',
                value: res.rationsLeftPercentage.toDouble(),
                color: Colors.green),
            Text('Rations Left').color(Colors.white).size(22).addTopMargin(30),
            SizedBox(
              height: 20,
            ),
            CircularChart(
                title: '',
                value: res.oxygenLeft.toDouble(),
                color: Colors.blue),
            Text('Oxygen Left').color(Colors.white).size(22).addTopMargin(30),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
