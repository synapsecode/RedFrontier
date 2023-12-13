import 'package:flutter/material.dart';
import 'package:redfrontier/extensions/miscextensions.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/redfrontier_user.dart';
import 'package:redfrontier/models/reports.dart';
import 'package:redfrontier/services/firestore/reports.dart';
import 'package:redfrontier/widgets/addreport_dialog.dart';
import 'package:redfrontier/widgets/repnews_details.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  void _openAddReport() {
    showDialog(context: context, builder: (context) => AddReportDialog());
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
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddReport,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ReportBody extends StatelessWidget {
  final Report model;
  const ReportBody({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    void _openReport() {
      showDialog(
          context: context,
          builder: (context) => RepNewsDetails(
                report: model,
              ));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: _openReport,
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          tileColor: Color(0xFFD2B48C),
          leading: CircleAvatar(
            backgroundImage:
                model.mediaUrl != 'none' ? AssetImage(model.mediaUrl) : null,
            radius: 32,
          ),
          trailing: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
          title: Text(
            model.title,
            style: TextStyle(color: Color.fromARGB(255, 143, 30, 4)),
          ),
        ),
      ),
    );
  }
}
