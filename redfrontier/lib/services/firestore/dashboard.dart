import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redfrontier/common/dialogs.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/redfrontier_user.dart';
import 'package:redfrontier/widgets/habitat_tab.dart';
import 'package:redfrontier/widgets/resources_tab.dart';

class FirestoreDashboard {
  static final CollectionReference resourceDataCollection =
      FirebaseFirestore.instance.collection('resourcedata');

  static final CollectionReference habitatDataCollection =
      FirebaseFirestore.instance.collection('habitatdata');

  static createInitialResourceForUser(RedFrontierUser user) async {
    try {
      await resourceDataCollection.doc(user.id).set({
        'energy': 100,
        'fuel': 0,
        'waste': 0,
        'rations': 100,
        'oxygen': 100,
      });
      print('User created successfully');
    } catch (e) {
      CustomDialogs.showDefaultAlertDialog(
        navigatorKey.currentState!.context,
        contentTitle: 'ResourceCreation Error',
        contentText: '$e',
      );
    }
  }

  static createInitialHabitatForUser(RedFrontierUser user) async {
    try {
      await habitatDataCollection.doc(user.id).set({
        'wind': 10,
        'dust': 10,
        'meteor': 10,
      });
      print('User created successfully');
    } catch (e) {
      CustomDialogs.showDefaultAlertDialog(
        navigatorKey.currentState!.context,
        contentTitle: 'HabitatCreation Error',
        contentText: '$e',
      );
    }
  }

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
