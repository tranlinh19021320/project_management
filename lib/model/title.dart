import 'package:cloud_firestore/cloud_firestore.dart';

class TitleProject {
  final String companyId;
  final String projectId;
  final String titleId;
  final String title;
  final int missions;
  final DateTime createDate;
  final DateTime startDate;
  final DateTime endDate;

  const TitleProject({
    required this.companyId,
    required this.projectId,
    required this.titleId,
    required this.title,
    required this.createDate,
    required this.startDate,
    required this.endDate,
    this.missions = 0,
  });

  Map<String, dynamic> toJson() => {
        'companyId': companyId,
        'projectId': projectId,
        'titleId' : titleId,
        'title': title,
        'createDate': createDate,
        'startDate': startDate,
        'endDate': endDate,
        'missions' : missions,
      };

  static TitleProject fromSnap({required DocumentSnapshot doc}) => TitleProject(
        companyId: doc['companyId'],
        projectId: doc['projectId'],
        titleId : doc['titleId'],
        title: doc['title'],
        createDate: doc['createDate'].toDate(),
        startDate: doc['startDate'].toDate(),
        endDate: doc['endDate'].toDate(),
        missions : doc['missions']
      );
}