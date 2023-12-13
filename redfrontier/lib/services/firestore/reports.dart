import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redfrontier/common/dialogs.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/reports.dart';
import 'package:uuid/uuid.dart';

class FirestoreReportService {
  static final CollectionReference reportsCollection =
      FirebaseFirestore.instance.collection('reports');

  static Future<void> createReport(Report report) async {
    try {
      CollectionReference reportsCollection =
          FirebaseFirestore.instance.collection('reports');

      final id = Uuid().v1();
      await reportsCollection.doc(id).set({
        'creator_uid': report.creatorUid,
        'media_url': report.mediaUrl,
        'title': report.title,
        'description': report.description,
        'id': id,
      });

      print('Report created successfully');
    } catch (e) {
      print('Error creating report: $e');
      CustomDialogs.showDefaultAlertDialog(
        navigatorKey.currentState!.context,
        contentTitle: 'ReportCreation Error',
        contentText: '$e',
      );
    }
  }

  // Get all reports where creator_uid is myuid
  static Future<List<Report>> getMyReports(String myUid) async {
    try {
      QuerySnapshot querySnapshot =
          await reportsCollection.where('creator_uid', isEqualTo: myUid).get();

      return querySnapshot.docs
          .map((doc) => Report.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting my reports: $e');
      CustomDialogs.showDefaultAlertDialog(
        navigatorKey.currentState!.context,
        contentTitle: 'MyReportFetch Error',
        contentText: '$e',
      );
      return [];
    }
  }

  // Get all reports where creator_uid is not myuid
  static Future<List<Report>> getFeedReports(String myUid) async {
    try {
      QuerySnapshot querySnapshot = await reportsCollection
          .where('creator_uid', isNotEqualTo: myUid)
          .get();

      return querySnapshot.docs
          .map((doc) => Report.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting feed reports: $e');
      CustomDialogs.showDefaultAlertDialog(
        navigatorKey.currentState!.context,
        contentTitle: 'FeedReportFetch Error',
        contentText: '$e',
      );
      return [];
    }
  }

  // Delete a report by ID
  static Future<void> deleteReport(String id) async {
    try {
      await reportsCollection.doc(id).delete();
      print('Report deleted successfully');
    } catch (e) {
      print('Error deleting report: $e');
      CustomDialogs.showDefaultAlertDialog(
        navigatorKey.currentState!.context,
        contentTitle: 'ReportDelete Error',
        contentText: '$e',
      );
    }
  }
}
