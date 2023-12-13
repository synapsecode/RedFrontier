import 'package:flutter/material.dart';
import 'package:redfrontier/extensions/miscextensions.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/redfrontier_user.dart';
import 'package:redfrontier/models/reports.dart';
import 'package:redfrontier/screens/report_screen.dart';
import 'package:redfrontier/services/firestore/reports.dart';
import '../widgets/repnews_details.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  void _openNews(Report model) {
    showDialog(
      context: context,
      builder: (context) => RepNewsDetails(
        report: model,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = gpc.read(currentRFUserProvider)!.id;
    return Scaffold(
      body: FutureBuilder(
        future: FirestoreReportService.getMyReports(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final data = snapshot.data;
            if (data == null || data.isEmpty)
              return Text('No Reports').center();
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => ReportBody(model: data[index]),
            );
          }
          return CircularProgressIndicator().center();
        },
      ),
    );
  }
}
