import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redfrontier/common/dialogs.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/widgets/habitat_tab.dart';
import 'package:redfrontier/widgets/resources_tab.dart';

class FirestoreDashboard {
  static final CollectionReference resourceDataCollection =
      FirebaseFirestore.instance.collection('resourcedata');

  static final CollectionReference habitatDataCollection =
      FirebaseFirestore.instance.collection('habitatdata');

  static listenToResourceChanges(String uid) {
    resourceDataCollection.doc(uid).snapshots().listen((event) {
      if (event.exists) {
        gpc.read(resourceProvider).loadFromMap(event.data() as Map);
      }
    });
  }

  static listenToHabitatChanges(String uid) {
    habitatDataCollection.doc(uid).snapshots().listen((event) {
      if (event.exists) {
        gpc.read(habitatProvider).loadFromMap(event.data() as Map);
      }
    });
  }
}
