import 'package:flutter/material.dart';
import 'package:redfrontier/models/reports.dart';

class RepNewsDetails extends StatefulWidget {
  const RepNewsDetails({super.key});

  @override
  State<RepNewsDetails> createState() => _RepNewsDetailsState();
}

class _RepNewsDetailsState extends State<RepNewsDetails> {
  final _data = dummyReports[0];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AlertDialog(
      title: Text(_data['title'] as String,
          style: Theme.of(context).textTheme.displayLarge),
      content: Column(children: [
        Image.asset(_data['image'] as String),
        Text(_data['description'] as String)
      ]),
    ));
  }
}
