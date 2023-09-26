import 'package:cloud_firestore/cloud_firestore.dart';

class Progress {
  final String date;
  final String description;
  final String missionId;
  final DateTime createDate;
  final double percent;
  final int state;

  const Progress({
    required this.createDate,
    required this.date,
    required this.description,
    required this.state,
    required this.missionId,
    required this.percent,
  });

  Map<String, dynamic> toJson() => {
        'missionId': missionId,
        'description': description,
        'createDate': createDate,
        'percent': percent,
        'date': date,
        'state': state
      };

  static Progress fromSnap({required DocumentSnapshot doc}) => Progress(
        missionId: doc['missionId'],
        description: doc['description'],
        createDate: doc['createDate'].toDate(),
        percent: doc['percent'],
        date: doc['date'],
        state: doc['state'],
      );
}
