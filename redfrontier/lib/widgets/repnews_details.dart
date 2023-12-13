import 'package:flutter/material.dart';
import 'package:redfrontier/models/reports.dart';

class RepNewsDetails extends StatefulWidget {
  final Report report;
  const RepNewsDetails({super.key, required this.report});

  @override
  State<RepNewsDetails> createState() => _RepNewsDetailsState();
}

class _RepNewsDetailsState extends State<RepNewsDetails> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AlertDialog(
      title: Text(widget.report.title,
          style: Theme.of(context).textTheme.displayLarge),
      content: Column(children: [
        if (widget.report.mediaUrl != 'none')
          Image.asset(widget.report.mediaUrl),
        Text(widget.report.description),
      ]),
    ));
  }
}
