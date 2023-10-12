import 'package:cloud_firestore/cloud_firestore.dart';

class Title {
  final String companyId;
  final String projectId;
  final String title;
  final int number;
  final DateTime createDate;
  final DateTime startDate;
  final DateTime endDate;

  const Title({
    required this.companyId,
    required this.projectId,
    required this.title,
    required this.createDate,
    required this.startDate,
    required this.endDate,
    required this.number,
  });

  Map<String, dynamic> toJson() => {
        'companyId': companyId,
        'projectId': projectId,
        'title': title,
        'createDate': createDate,
        'startDate': startDate,
        'endDate': endDate,
        'number' : number,
      };

  static Title fromSnap({required DocumentSnapshot doc}) => Title(
        companyId: doc['companyId'],
        projectId: doc['projectId'],
        title: doc['title'],
        createDate: doc['createDate'].toDate(),
        startDate: doc['startDate'].toDate(),
        endDate: doc['endDate'].toDate(),
        number : doc['number']
      );
}