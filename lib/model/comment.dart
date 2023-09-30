import 'package:cloud_firestore/cloud_firestore.dart';

class CommentReport {
  final String commentId;
  final String comment;
  final String companyId;
  final String reportId;
  final String ownId;
  final DateTime createDate;
  final bool isManager;
  final String ownName;
  final String photoURL;
  final String photoComment;
  
  const CommentReport({
    required this.commentId,
    required this.comment,
    required this.companyId,
    required this.reportId,
    required this.createDate,
    required this.ownId,
    required this.isManager,
    required this.ownName,
    required this.photoURL,
    required this.photoComment,
  });
  Map<String, dynamic> toJson() => {
        'commentId': commentId,
        'comment' : comment,
        'companyId': companyId,
        'reportId': reportId,
        'ownId': ownId,
        'isManager': isManager,
        'ownName': ownName,
        'photoURL': photoURL,
        'photoComment': photoComment,
        'createDate': createDate,
      };
  static CommentReport fromSnap({required DocumentSnapshot doc}) => CommentReport(
        commentId: doc['commentId'],
        comment : doc['comment'],
        companyId: doc['companyId'],
        reportId: doc['reportId'],
        ownId: doc['ownId'],
        isManager: doc['isManager'],
        ownName: doc['ownName'],
        photoURL: doc['photoURL'],
        photoComment: doc['photoComment'],
        createDate: doc['createDate'].toDate(),
      );
}
