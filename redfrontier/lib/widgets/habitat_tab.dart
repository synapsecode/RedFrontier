import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redfrontier/extensions/extensions.dart';
import 'package:redfrontier/models/redfrontier_user.dart';
import 'package:redfrontier/services/firestore/dashboard.dart';
import 'package:redfrontier/widgets/circularchart.dart';

class HabitatData extends ChangeNotifier {
  int windSpeed = 0;
  int dustStormProbability = 0;
  int meteorImpactProbability = 0;

  loadFromMap(Map x) {
    windSpeed = x['wind'] ?? 0;
    dustStormProbability = x['dust'] ?? 0;
    meteorImpactProbability = x['meteor'] ?? 0;

    notifyListeners();
  }
}

final habitatProvider = ChangeNotifierProvider((ref) => HabitatData());

class HabitatTab extends ConsumerStatefulWidget {
  const HabitatTab({super.key});

  @override
  ConsumerState<HabitatTab> createState() => _HabitatTabState();
}

class _HabitatTabState extends ConsumerState<HabitatTab> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 200), () {
      final uid = ref.read(currentRFUserProvider)!.id;
      FirestoreDashboard.listenToHabitatChanges(uid);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final res = ref.watch(habitatProvider);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("${res.windSpeed} kmph").size(60).color(Colors.white),
          Text('Wind Speed').color(Colors.white54).center(),
          SizedBox(height: 20),
          CircularChart(
              title: '',
              value: res.dustStormProbability.toDouble(),
              color: Colors.brown),
          Text('Dust Storm Probability')
              .color(Colors.white)
              .size(22)
              .addTopMargin(30),
          SizedBox(height: 20),
          CircularChart(
              title: '',
              value: res.meteorImpactProbability.toDouble(),
              color: Colors.grey),
          Text('Meteor Strike Probability')
              .color(Colors.white)
              .size(22)
              .addTopMargin(30),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
