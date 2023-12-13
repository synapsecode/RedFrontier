import 'package:flutter/material.dart';
import 'package:redfrontier/widgets/resources_tab.dart';

import '../../widgets/habitat_tab.dart';

class MyDashboard extends StatelessWidget {
  const MyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Data Dashboard',
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(fontSize: 25),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Resources'),
              Tab(text: 'Habitat'),
            ],
          ),
          backgroundColor: Colors.transparent,
        ),
        body: const TabBarView(
          children: [
            ResourcesTab(),
            HabitatTab(),
          ],
        ),
      ),
    );
  }
}
