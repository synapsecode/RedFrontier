import 'package:uuid/uuid.dart';

class Report {
  final String id;
  final String creatorUid;
  final String mediaUrl;
  final String title;
  final String description;

  Report({
    required this.id,
    required this.creatorUid,
    required this.mediaUrl,
    required this.title,
    required this.description,
  });

  // Factory constructor to create a Report instance from a Map
  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'] ?? '',
      creatorUid: map['creator_uid'] ?? '',
      mediaUrl: map['media_url'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }
}

final dummyReports = [
  {
    'image': 'assets/images/astronautpng1.png',
    'title': 'Found Water',
    'description': 'jeyrfg  ghwey gywgyryg wrgrhgwhrgwbgwrhgwrhgowhrogwrhgb'
  },
  {
    'image': 'assets/images/astronautpng1.png',
    'title': 'Found Air',
    'description': 'jeyrfg  ghwey gywgyryg wrgrhgwhrgwbgwrhgwrhgowhrogwrhgb'
  },
  {
    'image': 'assets/images/astronautpng1.png',
    'title': 'Found Brain',
    'description': 'jeyrfg  ghwey gywgyryg wrgrhgwhrgwbgwrhgwrhgowhrogwrhgb'
  },
  {
    'image': 'assets/images/astronautpng1.png',
    'title': 'paani piladijiye',
    'description': 'jeyrfg  ghwey gywgyryg wrgrhgwhrgwbgwrhgwrhgowhrogwrhgb'
  }
];
