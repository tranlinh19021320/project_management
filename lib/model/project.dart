import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String nameProject;
  final String description;
  final String projectId;
  final String companyId;
  final DateTime createDate;
  final DateTime startDate;
  final DateTime endDate;
  final int missions;
  final int title;
  const Project({
    this.missions = 0,
    this.title = 0,
    required this.companyId,
    required this.projectId,
    required this.nameProject,
    required this.description,
    required this.createDate,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() => {
        'companyId': companyId,
        'projectId': projectId,
        'nameProject': nameProject,
        'description': description,
        'createDate': createDate,
        'startDate': startDate,
        'endDate': endDate,
        'missions': missions,
        'title' : title,
      };

  static Project fromSnap(DocumentSnapshot doc) {
    return Project(
      missions: doc['missions'],
      companyId: doc['companyId'],
      projectId: doc['projectId'],
      nameProject: doc['nameProject'],
      description: doc['description'],
      createDate: doc['createDate'].toDate(),
      startDate: doc['startDate'].toDate(),
      endDate: doc['endDate'].toDate(),
      title: doc['title'],
    );
  }
}
