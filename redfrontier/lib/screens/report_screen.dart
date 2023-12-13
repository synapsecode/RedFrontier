import 'package:flutter/material.dart';
import 'package:redfrontier/models/reports.dart';
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

  void _openReport() {
    showDialog(context: context, builder: (context) => RepNewsDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: dummyReports.length,
          itemBuilder: (context, index) {
            final _reports = dummyReports[index];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: _openReport,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tileColor: Color(0xFFD2B48C),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(_reports['image'].toString()),
                    radius: 32,
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                  title: Text(
                    _reports['title'] as String,
                    style: TextStyle(color: Color.fromARGB(255, 143, 30, 4)),
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddReport,
        child: const Icon(Icons.add),
      ),
    );
  }
}
