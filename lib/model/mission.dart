import 'package:cloud_firestore/cloud_firestore.dart';

class Mission {
  final String companyId;
  final String projectId;
  final String titleId;
  final String missionId;
  final String nameProject;
  final String nameMission;
  final String description;
  final DateTime createDate;
  final DateTime startDate;
  final DateTime endDate;
  final double percent;
  final String staffId;

  const Mission({
    required this.nameProject,
    required this.companyId,
    required this.projectId,
    required this.titleId,
    required this.missionId,
    required this.nameMission,
    required this.description,
    required this.createDate,
    required this.startDate,
    required this.endDate,
    required this.percent,
    required this.staffId,
  });

  Map<String, dynamic> toJson() => {
    'nameProject' : nameProject,
        'companyId': companyId,
        'projectId': projectId,
        'titleId' : titleId,
        'missionId': missionId,
        'nameMission': nameMission,
        'description': description,
        'createDate': createDate,
        'startDate': startDate,
        'endDate': endDate,
        'percent': percent,
        'staffId': staffId,
      };

  static Mission fromSnap({required DocumentSnapshot doc}) => Mission(
    nameProject: doc['nameProject'],
        companyId: doc['companyId'],
        projectId: doc['projectId'],
        titleId: doc['titleId'],
        missionId: doc['missionId'],
        nameMission: doc['nameMission'],
        description: doc['description'],
        createDate: doc['createDate'].toDate(),
        startDate: doc['startDate'].toDate(),
        endDate: doc['endDate'].toDate(),
        percent: doc['percent'],
        staffId: doc['staffId'],
      );
}
